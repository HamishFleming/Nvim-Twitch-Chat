local fetch = require("example-plugin.fetch")
local account = require("example-plugin.account")
local db = require("example-plugin.db")
local M = {}

M.connect = fetch.connect
M.disconnect = fetch.disconnect
M.set_account = account.set_account

M.list_channels = db.get_channels
M.get_channels_count = db.get_channels_count
return M
