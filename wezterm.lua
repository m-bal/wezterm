-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.audible_bell = 'Disabled'
config.default_cursor_style = 'BlinkingBlock'
config.force_reverse_video_cursor = true
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 400
config.front_end = 'WebGpu'
config.font_size = 20
config.use_resize_increments = true
config.color_scheme = 'Ubuntu'
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane.current_working_dir
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	return current_dir:match(".*/(.*)")
end


wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)

  local pane = tab.active_pane
  local title = string.format('  %s  ', get_current_working_dir(tab))

  return {
    { Text = title },
  }
end)

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'fire',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = '',
    -- The username to use on the remote host
    username = 'manvir',
  },
}

wezterm.on('update-status', function(window, pane)
  local meta = pane:get_metadata() or {}
  if meta.is_tardy then
    local secs = meta.since_last_response_ms / 1000.0
    window:set_right_status(string.format('tardy: %5.1fs⏳', secs))
  end
end)

config.tab_max_width = 30
config.font = wezterm.font_with_fallback {
  'Agave Nerd Font',
}
config.send_composed_key_when_right_alt_is_pressed = false


-- and finally, return the configuration to wezterm
return config

