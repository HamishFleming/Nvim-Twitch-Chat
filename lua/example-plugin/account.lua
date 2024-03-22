local vim = vim
local notify = require("example-plugin.notifier")
local M = {}

-- this will handle setting the account
function M.set_account()
    local account = vim.fn.input('Enter account: ')
    vim.g.exampleplugin_account = account
    notify.notify('Account set to ' .. account)
end

return M
