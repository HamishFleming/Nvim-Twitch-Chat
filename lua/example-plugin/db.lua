local sqlite3 = require("ljsqlite3")

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

local function check_if_channel_exists(channel)
    local rows = execute_query("SELECT * FROM twitch_channels WHERE name = '"..channel.."'")
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
    local rows = execute_query("SELECT name FROM twitch_channels")
    for _, row in ipairs(rows) do
	print(row[0])
        table.insert(channels, row[0])
    end
    print("Channels")
    print(vim.inspect(rows))
    print(vim.inspect(channels))
    print("Channels")
    print(channels)
    return channels
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
