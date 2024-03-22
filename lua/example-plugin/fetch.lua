local notify = require("example-plugin.notifier")


local M = {}



-- run npm command 'tc connect <channel>'
--[[ function M.connect(channel) ]]
function M.connect()
  local channel = "V3x_Tech"
  local cmd = 'tc connect ' .. channel
  local handle = io.popen(cmd)
  -- send every line to the notifier
  for line in handle:lines() do
    notify.notify(line)
  end
end


return M
