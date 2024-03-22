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

local function execute_query(query, ...)
    open_database()
    local stmt = db:prepare(query)
    if stmt then
        stmt:bind_values(...)  -- Bind parameters
        local result = stmt:exec()
        stmt:finalize()  -- Finalize statement
        close_database()
        return result
    end
    close_database()
    return nil
end

function M.create_table()
    execute_query("CREATE TABLE IF NOT EXISTS twitch_channels(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)")
end

function M.get_channels()
    local channels = {}
    local stmt = db:prepare("SELECT name FROM twitch_channels")
    if stmt then
        for row in stmt:nrows() do
            table.insert(channels, row.name)
        end
        stmt:finalize()
    end
    return channels
end

function M.get_channels_count()
    local stmt = db:prepare("SELECT COUNT(*) FROM twitch_channels")
    if stmt then
        local count = stmt:step()
        stmt:finalize()
        return count
    end
    return 0
end

function M.get_users()
    local users = {}
    local stmt = db:prepare("SELECT name FROM twitch_users")
    if stmt then
        for row in stmt:nrows() do
            table.insert(users, row.name)
        end
        stmt:finalize()
    end
    return users
end

function M.get_auth()
    local auth = {}
    local stmt = db:prepare("SELECT token FROM twitch_auth")
    if stmt then
        for row in stmt:nrows() do
            table.insert(auth, row.token)
        end
        stmt:finalize()
    end
    return auth
end

function M.add_channel(channel)
    -- Check if channel already exists
    if M.channel_exists(channel) then
        return false
    end
    return execute_query("INSERT INTO twitch_channels(name) VALUES(?)", channel)
end

function M.add_user(user)
    return execute_query("INSERT INTO twitch_users(name) VALUES(?)", user)
end

function M.add_auth(token)
    return execute_query("INSERT INTO twitch_auth(token) VALUES(?)", token)
end

function M.channel_exists(channel)
    local stmt = db:prepare("SELECT COUNT(*) FROM twitch_channels WHERE name = ?")
    if stmt then
        stmt:bind_values(channel)
        local count = stmt:step()
        stmt:finalize()
        return count > 0
    end
    return false
end

return M
