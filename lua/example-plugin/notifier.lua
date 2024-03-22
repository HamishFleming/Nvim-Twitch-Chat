


local M = {}

function M.notify(message)
    vim.notify_once(
    	message,
        level = vim.log.levels.INFO,
    )
end


return M
