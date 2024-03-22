local sqlite3 = require("ljsqlite3")


local M = {}

local db = sqlite3.open("nvim-tc.db")

local function create_table()
local db = sqlite3.open("nvim-tc.db")
  -- Create channel table
    --[[ local db_results = db:exec("SELECT * FROM todo_list WHERE completed == 'No';") ]]
  --[[ db:exec[[ ]]
  --[[   CREATE TABLE IF NOT EXISTS twitch_channels ( ]]
  --[[     id INTEGER PRIMARY KEY AUTOINCREMENT, ]]
  --[[     name TEXT NOT NULL, ]]
  --[[   ); ]]
  db:exec( "CREATE TABLE IF NOT EXISTS twitch_channels (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);")

  -- Create user table
  --[[ db:exec[[ ]]
  --[[   CREATE TABLE IF NOT EXISTS twitch_users ( ]]
  --[[     id INTEGER PRIMARY KEY AUTOINCREMENT, ]]
  --[[     name TEXT NOT NULL, ]]
  --[[   ); ]]

  -- Create Auth table
  --[[ db:exec[[ ]]
  --[[   CREATE TABLE IF NOT EXISTS twitch_auth ( ]]
  --[[     id INTEGER PRIMARY KEY AUTOINCREMENT, ]]
  --[[     token TEXT NOT NULL ]]
  --[[   ); ]]
end

function M.get_channels()
local db = sqlite3.open("nvim-tc.db")
  local channels = {}
  for row in db:nrows("SELECT * FROM twitch_channels") do
    table.insert(channels, row)
  end
  return channels
end


function M.get_users()
local db = sqlite3.open("nvim-tc.db")
  local users = {}
  for row in db:nrows("SELECT * FROM twitch_users") do
    table.insert(users, row)
  end
  return users
end

function M.get_auth()
local db = sqlite3.open("nvim-tc.db")
  local auth = {}
  for row in db:nrows("SELECT * FROM twitch_auth") do
    table.insert(auth, row)
  end
  return auth
end

function M.add_channel(channel)
local db = sqlite3.open("nvim-tc.db")
  db:exec("INSERT INTO twitch_channels (name) VALUES ('"..channel.."')")
end

function M.add_user(user)
local db = sqlite3.open("nvim-tc.db")
  db:exec("INSERT INTO twitch_users (name) VALUES ('"..user.."')")
end

function M.add_auth(token)
local db = sqlite3.open("nvim-tc.db")
  db:exec("INSERT INTO twitch_auth (token) VALUES ('"..token.."')")
end


create_table()

return M
