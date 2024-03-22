local vim = vim
local notify = require("example-plugin.notifier")
local db = require("example-plugin.db")

local M = {}

-- List all channels in the database
function M.list_channels()
    local channels = db.get_channels()
    for _, channel in ipairs(channels) do
	notify.notify(channel.name)
    end
end

-- List all users in the database
function M.list_users()
    local users = db.get_users()
    for _, user in ipairs(users) do
	notify.notify(user.name)
    end
end

-- List all auth in the database
function M.list_auth()
    local auth = db.get_auth()
    for _, a in ipairs(auth) do
	notify.notify(a.token)
    end
end

local function add_channel(channel)
    local success = db.add_channel(channel)
    if not success then
	notify.notify('Channel ' .. channel .. ' already exists')
	return
    end
    notify.notify('Channel ' .. channel .. ' added')
end

-- Add a user to the database
function M.add_user()
    local user = vim.fn.input('Enter user: ')
    db.add_user(user)
    notify.notify('User ' .. user .. ' added')
end

-- Add an auth to the database
function M.add_auth()
    local auth = vim.fn.input('Enter auth: ')
    db.add_auth(auth)
    notify.notify('Auth ' .. auth .. ' added')
end


function M.set_account()
    local account = vim.fn.input('Enter account: ')
    add_channel(account)
    vim.g.exampleplugin_account = account
end


return M
