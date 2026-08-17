-- source: https://gist.github.com/Leenuus/db3607091a0cf2f7d8450adaff0132d3

local function Redir(opts)
  local cmd = opts.fargs[1]
  local range = opts.range
  local line1 = opts.line1 - 1
  local line2 = opts.line2
  line2 = line1 == line2 and line1 + 1 or line2

  local output

  local Job = require('plenary.job')
  if string.match(cmd, '^!') then
    cmd = vim.fn.split(cmd)

    local command = cmd[1]:sub(2)
    local args = {}
    for i, t in ipairs(cmd) do
      if i ~= 1 then
        table.insert(args, t)
      end
    end

    if range == 0 then
      -- NOTE: no input given, call command
      Job:new({
        command = command,
        args = args,
        on_exit = function(j, _)
          output = j:result()
        end,
      }):sync()
    else
      -- NOTE: setup input in temp file
      local lines = vim.api.nvim_buf_get_lines(0, line1, line2, false)
      local input = vim.fn.join(lines, '\n')
      local file = vim.fn.tempname()
      local f = io.open(file, 'w+')
      if not f then
        return
      end
      f:write(input)
      f:close()

      table.insert(args, file)

      Job:new({
        command = command,
        args = args,
        on_exit = function(j, _)
          output = j:result()
        end,
      }):sync()
    end
  else
    -- NOTE: vim command
    vim.cmd('redir => output')
    vim.cmd(cmd)
    vim.cmd('redir END')
    output = vim.fn.split(vim.g.output, '\n')
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, output)
  vim.cmd('buffer ' .. buf)
  vim.cmd('normal G')
end

vim.api.nvim_create_user_command('Redir', Redir, {
  nargs = 1,
  complete = 'command',
  range = true,
})
vim.cmd([[cabbrev R Redir]])

local interepters = {
  python = 'python',
  sh = 'bash',
  bash = 'bash',
  fish = 'fish',
  lua = 'luajit',
}

local function redir(range)
  return function()
    local line = vim.fn.getline(1)
    local interepter = string.match(line, '^#!(.*)')

    if not interepter then
      local ft = vim.o.ft
      interepter = interepters[ft]
    end

    if interepter then
      vim.cmd(string.format('silent %sRedir !%s', range, interepter))
    else
      -- FIXME: setcmdline not work
      vim.fn.setcmdline(string.format('silent %sRedir !', range))
    end
  end
end

vim.api.nvim_create_user_command('RedirEvalLine', redir('.'), {})
vim.api.nvim_create_user_command('RedirEvalFile', redir('%'), {})

vim.keymap.set(
  'n',
  '<space>rem',
  ':Redir messages<cr>',
  { desc = "Redirect ':messages' output to scratch buffer" }
)

-- TODO: fix me
-- vim.api.nvim_create_user_command("RedirEvalRange", redir("'<,'>"), {})
