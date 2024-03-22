local notify = require("example-plugin.notifier")

local M = {}

function M.connect()
  -- check that the account is set
  if vim.g.loaded_exampleplugin.account == nil then
    notify.notify('Account not set')
    return
  end
  local channel = vim.g.exampleplugin_account
  notify.notify('Connecting to channel')
  --[[ local channel = "V3x_Tech" ]]
  local cmd = 'tc connect ' .. channel

  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      notify.notify(data)
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
