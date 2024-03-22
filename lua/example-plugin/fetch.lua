local M = {}



-- run npm command 'tc connect <channel>'
--[[ function M.connect(channel) ]]
function M.connect()
  local channel = "V3x_Tech"
  local cmd = 'tc connect ' .. channel
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end


return M
