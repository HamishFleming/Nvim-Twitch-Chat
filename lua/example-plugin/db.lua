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

function M.create_table()
    execute_query("CREATE TABLE IF NOT EXISTS twitch_channels(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);")
end

function M.get_channels()
    local channels = {}
    local rows = execute_query("SELECT * FROM twitch_channels")
    for _, row in ipairs(rows) do
	    --[[ print(vim.inspect(row)) ]]
        table.insert(channels, row.name)
    end
    print(vim.inspect(channels))

    return channels
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
    execute_query("INSERT INTO twitch_channels(name) VALUES('"..channel.."')")
end

function M.add_user(user)
    execute_query("INSERT INTO twitch_users (name) VALUES ('"..user.."')")
end

function M.add_auth(token)
    execute_query("INSERT INTO twitch_auth (token) VALUES ('"..token.."')")
end

return M
