local notify = require("example-plugin.notifier")
local M = {}


-- This will handle adding new lines if the message is too long
local function split_message(message)
  local lines = {}
  local line = ''
  for i = 1, #message do
    line = line .. message:sub(i, i)
    if i % 80 == 0 then
      table.insert(lines, line)
      line = ''
    end
  end
  table.insert(lines, line)
  return lines
end


function M.connect()
  -- check that the account is set
  if vim.g.exampleplugin_account == nil then
    notify.notify('Account not set')
    return
  end
  local channel = vim.g.exampleplugin_account
  notify.notify('Connecting to channel')
  local cmd = 'tc connect ' .. channel

  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      notify.notify(split_message(data))
    end,
    on_stderr = function(_, data, _)
      notify.notify(data)
    end,
    on_exit = function(_, code, _)
      notify.notify('Exited with code ' .. code)
    end
  })
end

return M
