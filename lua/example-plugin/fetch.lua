local notify = require("example-plugin.notifier")


local M = {}



-- run npm command 'tc connect <channel>'
--[[ function M.connect(channel) ]]
function M.connect()
  notify.notify('Connecting to channel')
  local channel = "V3x_Tech"
  local cmd = 'tc connect ' .. channel
  local handle = io.popen(cmd)
  for line in handle:lines() do
    -- validate the output
    notify.notify(line)
  end
end


return M
