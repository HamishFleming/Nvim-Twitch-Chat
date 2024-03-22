local notify = require("example-plugin.notifier")

local M = {}

-- Function to split long messages into lines
local function split_message(message)
  local lines = {}
  for i = 1, #message, 80 do
    table.insert(lines, message:sub(i, i + 79))
  end
  return lines
end

function M.connect(account)
  if not account then
    notify.notify('Account not set')
    return
  end

  notify.notify('Connecting to channel')
  local cmd = 'tc connect ' .. account

  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(split_message(data)) do
        notify.notify(line)
      end
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
