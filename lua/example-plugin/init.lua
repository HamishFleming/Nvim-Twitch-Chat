local fetch = require("example-plugin.fetch")
local account = require("example-plugin.account")
local M = {}

M.connect = fetch.connect
M.disconnect = fetch.disconnect
M.set_account = account.set_account
return M
