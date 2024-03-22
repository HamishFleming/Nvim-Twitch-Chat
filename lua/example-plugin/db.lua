local sqlite3 = require("ljsqlite3")
local notify = require("example-plugin.notifier")

local M = {}

local db

local function open_database()
    if not db then
        db = sqlite3.open("nvim-tc.db")
    end
end

local function close_database()
    if db then
        db:close()
        db = nil
    end
end

local function execute_query(query)
    open_database()
    local result = db:exec(query)
    close_database()
    return result
end

local function dump_result(query)
	open_database()
	local result = db:exec(query)
	if result == sqlite3.OK then
		local rows = {}
		local row = {}
		while db:step() == sqlite3.ROW do
			for i = 0, db:columns() - 1 do
				row[db:column_name(i)] = db:column_text(i)
			end
			table.insert(rows, row)
		end
		print(vim.inspect(rows))
		return rows
	end
	close_database()
end

local function check_if_channel_exists(channel)
    local rows = execute_query("SELECT * FROM twitch_channels WHERE name = '"..channel.."'")
    print(vim.inspect(rows))
    if not rows then
	return false
    end
    return #rows > 0
end


function M.create_table()
    execute_query("CREATE TABLE IF NOT EXISTS twitch_channels(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);")
end

function M.get_channels()
    local channels = {}
    local rows = execute_query("SELECT * FROM twitch_channels")
    for _, row in ipairs(rows.name) do
	table.insert(channels, row)
    end
    -- Remove duplicates using a Lua table as a set
    local uniqueChannels = {}
    for _, name in ipairs(channels) do
        uniqueChannels[name] = true
    end
    -- Convert the set back to a list
    local uniqueChannelList = {}
    for name, _ in pairs(uniqueChannels) do
        table.insert(uniqueChannelList, name)
    end
    print(vim.inspect(uniqueChannelList))
    return uniqueChannelList
end


function M.get_channels_count()
    local rows = execute_query("SELECT COUNT(*) FROM twitch_channels")
    print(tonumber(rows[1][1]))
    return tonumber(rows[1][1])
end

function M.get_users()
    local users = {}
    local rows = execute_query("SELECT * FROM twitch_users")
    for _, row in ipairs(rows) do
        table.insert(users, row.name)
    end
    return users
end

function M.get_auth()
    local auth = {}
    local rows = execute_query("SELECT * FROM twitch_auth")
    for _, row in ipairs(rows) do
        table.insert(auth, row.token)
    end
    return auth
end

function M.add_channel(channel)
    if check_if_channel_exists(channel) then
	    notify.notify("Channel already exists")
	return
    end
    execute_query("INSERT INTO twitch_channels(name) VALUES('"..channel.."')")
end

function M.add_user(user)
    execute_query("INSERT INTO twitch_users (name) VALUES ('"..user.."')")
end

function M.add_auth(token)
    execute_query("INSERT INTO twitch_auth (token) VALUES ('"..token.."')")
end

return M
