local notify = require("example-plugin.notifier")


local M = {}



-- run npm command 'tc connect <channel>'
--[[ function M.connect(channel) ]]
function M.connect()
  notify.notify('Connecting to channel')
  local channel = "V3x_Tech"
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


  --[[ local handle = io.popen(cmd) ]]
  --[[ for line in handle:lines() do ]]
  --[[   notify.notify(line) ]]
  --[[ end ]]


end


return M
