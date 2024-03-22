local M = {}



-- run npm command 'tc connect <channel>'
function M.connect(channel)
  local cmd = 'tc connect ' .. channel
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end



export = M
