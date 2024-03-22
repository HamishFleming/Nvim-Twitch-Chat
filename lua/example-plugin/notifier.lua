


local M = {}

function M.notify(message)
    vim.notify_once(
    	message,
        vim.log.levels.INFO
    )
end


return M
