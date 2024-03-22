local notify = require("example-plugin.notifier")
local M = {}

-- Store the current job ID
local current_job_id = nil

-- Function to handle connection and disconnection
local function handle_connection(action)
  if vim.g.exampleplugin_account == nil then
    notify.notify('Account not set')
    return
  end

  local channel = vim.g.exampleplugin_account
  local cmd = 'tc ' .. action .. ' ' .. channel

  -- Start the job and store the job ID
  current_job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      -- check not null
      if data then
	notify.notify(data)
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        notify.notify(data)
      end
    end,
    on_exit = function(_, code, _)
      if data then
      	notify.notify('Exited with code ' .. code)
      end
    end
  })
end

function M.connect()
  notify.notify('Connecting to channel')
  handle_connection('connect')
end

function M.disconnect()
  if current_job_id then
    -- Stop the current job if it exists
    vim.fn.jobstop(current_job_id)
    current_job_id = nil
    notify.notify('Disconnected from channel')
  else
    notify.notify('No active connection to disconnect')
  end
end

return M
