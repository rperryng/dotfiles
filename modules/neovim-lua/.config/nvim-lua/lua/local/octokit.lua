local M = {}
local curl = require('plenary.curl')

local API_URL = 'https://api.github.com'

local function u(path)
  return API_URL .. path
end

local function headers(h)
  return {
    Authorization = string.format('Bearer %s', os.getenv('GITHUB_TOKEN')),
    Accept = 'application/vnd.github+json',
    ['X-GitHub-Api-Version'] = '2022-11-28',
    -- table.unpack(h or {})
  }
end

local function parse_link_header(header)
  local result = {}

  for part in string.gmatch(header, '([^,]+)') do
    -- Extract the URL and relation type
    local url = string.match(part, '<(.+)>')
    local rel = string.match(part, 'rel="(.+)"')
    assert(url, 'could not parse url', header)
    assert(rel, 'could not parse rel', header)

    local page = url.match(url, 'page=(%d+)')
    assert(page, 'could not parse page number', url)

    if url and rel then
      result[rel] = {
        url = url,
        page = tonumber(page),
      }
    end
  end

  return result
end

local function parse_data(data)
  -- If the data is an array, return that
  if data[1] ~= nil then
    return data
  end

  -- Some endpoints respond with 204 No Content instead of empty array
  -- when there is no data. In that case, return an empty array.
  if not data then
    return {}
  end

  Log('keys:')
  for k, _ in data do
    Log(k)
  end

  -- Otherwise, the array of items that we want is in an object
  -- Delete keys that don't include the array of items
  data.incomplete_results = nil
  data.repository_selection = nil
  data.total_count = nil

  -- Pull out the array of items
  local namespace_key = data[1]
  data = data[namespace_key]

  return data
end

local function get_paginated_data(path)
  local next_url = u(path)
  local data = {}
  local count = 0

  while next_url ~= nil do
    count = count + 1
    local response = curl.get(next_url, {
      headers = headers(),
    })

    local parsed_data = parse_data(vim.fn.json_decode(response.body))
    for _, item in ipairs(parsed_data) do
      table.insert(data, item)
    end

    local link_header = nil
    for _, header in ipairs(response.headers) do
      if header:match('^link:') then
        link_header = header
        break
      end
    end

    if link_header == nil then
      next_url = nil
    else
      local link = parse_link_header(link_header)
      next_url = link and link.next and link.next.url
    end
  end

  return data
end

function M.get_paginated_data(path)
  return coroutine.wrap(function()
    coroutine.yield(get_paginated_data(path))
  end)
end

function M.commits()
  return get_paginated_data('/repos/rperryng/dotfiles/commits')
  -- return curl.get(u('/repos/rperryng/dotfiles/commits'), {
  --   headers = headers(),
  -- })
end

-- function M.repos()
--   return curl.get(u('/user/repos'), {
--     headers = headers(),
--   })
-- end

function M.repos()
  return get_paginated_data('/user/repos')
end

return M
