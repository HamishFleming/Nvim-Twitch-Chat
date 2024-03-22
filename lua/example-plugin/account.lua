local vim = vim
local M = {}

-- this will handle setting the account
function M.set_account()
    local account = vim.fn.input('Enter account: ')
    vim.g.exampleplugin_account = account
end

return M
