local M = {}
local curl = require('plenary.curl')

local API_URL = 'https://api.github.com'
local DEFAULT_HEADERS = {
  Authorization = string.format('Bearer %s', os.getenv('GITHUB_TOKEN')),
  Accept = 'application/vnd.github+json',
  ['X-GitHub-Api-Version'] = '2022-11-28',
}

local function parse_link_header(header)
  local result = {}

  for part in string.gmatch(header, '([^,]+)') do
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

local function resolve_link(headers)
  local link_header = nil
  for _, header in ipairs(headers) do
    if header:match('^link:') then
      link_header = header
      break
    end
  end

  if link_header == nil then
    return nil
  end

  return parse_link_header(link_header)
end

local function parse_data(data)
  if data[1] ~= nil then
    return data
  end

  if not data then
    return {}
  end

  data.incomplete_results = nil
  data.repository_selection = nil
  data.total_count = nil

  local namespace_key = data[1]
  return data[namespace_key]
end

local function checkToken(path)
  if (os.getenv('GITHUB_TOKEN')) then
    error(string.format('No $GITHUB_TOKEN found, can\'t make GitHub API request "%s"', path))
  end
end

-- TODO: run X requests at a time instead of 1 at a time
local function get_paginated_data(path, callback)
  checkToken(path)

  local next_url = API_URL .. path
  local data = {}
  local page = 1
  local last_page = nil

  local function curl_cb(response)
    local parsed_data = parse_data(vim.fn.json_decode(response.body))
    for _, item in ipairs(parsed_data) do
      table.insert(data, item)
    end

    local link = resolve_link(response.headers)

    if link == nil then
      next_url = nil
    else
      if last_page == nil and link.last then
        last_page = link.last.page
      end

      next_url = link.next and link.next.url
    end

    if callback ~= nil then
      callback({
        data = parsed_data,
        page = page,
        last_page = last_page,
        done = link == nil,
      })
    end

    page = page + 1
    if next_url then
      callback({
        data = parsed_data,
        page = page,
        last_page = last_page,
        done = false,
      })

      curl.get(next_url, {
        headers = DEFAULT_HEADERS,
        callback = function(next_response)
          vim.schedule(function()
            curl_cb(next_response)
          end)
        end
      })
    else
      callback({
        data = data,
        done = true,
      })
    end
  end

  curl.get(next_url, {
    headers = DEFAULT_HEADERS,
    callback = function(response)
      vim.schedule(function()
        curl_cb(response)
      end)
    end,
  })
end

function M.fidget(path, callback)
  local progress = require('fidget.progress')
  local handle = progress.handle.create({
    title = path,
    message = 'Fetching ...',
    percentage = 0,
    lsp_client = { name = 'GitHub' },
  })

  get_paginated_data(path, function(result)
    if result.done then
      handle:finish()
    elseif result.last_page then
      local percentage = vim.fn.round(100 * (result.page / result.last_page))
      handle:report({
        message = string.format('Page %s / %s', result.page, result.last_page),
        percentage = percentage,
      })
    else
      handle:report({
        message = string.format('Page %s ...', result.page),
      })
    end

    callback(result)
  end)
end

function M.commits(callback)
  return get_paginated_data('/repos/rperryng/dotfiles/commits', callback)
end

function M.repos(callback)
  return get_paginated_data('/user/repos', callback)
end

return M
