


local M = {}

function M.notify(message, level)
    vim.notify_once(
    	message,
        {
            title = "Tc Notifications",
            timeout = 1000,
            level = level or vim.log.levels.INFO,
        }
    )
end


return M
