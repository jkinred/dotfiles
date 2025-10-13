local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.audible_bell = "Disabled"
config.color_scheme = "Catppuccin Macchiato"
config.enable_scroll_bar = true
--config.enable_wayland = false
config.font_size = 18.0
config.hide_mouse_cursor_when_typing = true
config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.8,
}
config.pane_focus_follows_mouse = true
config.scrollback_lines = 20000
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
--config.webgpu_preferred_adapter = {
--  backend = 'Vulkan',
--  device = 9660,
--  device_type = 'DiscreteGpu',
--  driver = 'NVIDIA',
--  driver_info = '550.54.15',
--  name = 'NVIDIA RTX A1000 6GB Laptop GPU',
--  vendor = 4318,
--}
config.window_background_opacity = 0.9
--config.window_decorations = "RESIZE"

-- Automatically connect to a running domain
config.unix_domains = { { name = "unix" } }
config.default_gui_startup_args = { "connect", "unix" }

config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 150,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 150,
}

config.colors = {
	visual_bell = "#202020",
}

-- Key bindings
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 8000 }

config.keys = {
	-- Tab control and navigation
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({
			args = { "zsh" },
			cwd = wezterm.home_dir,
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{ key = "Space", mods = "LEADER|CTRL", action = act.ActivateLastTab },

	-- Pane control and navigation
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = act.SplitVertical({
			args = { "zsh" },
			cwd = wezterm.home_dir,
		}),
	},
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({
			args = { "zsh" },
			cwd = wezterm.home_dir,
		}),
	},

	-- tmux style command palette
	{ key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },

	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Tab name",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- tmux style key bindings for search and copy
	{
		key = "[",
		mods = "LEADER",
		action = act.Multiple({
			--act.SendKey { key = 's', mods = 'CTRL' },
			act.ActivateKeyTable({
				name = "copy_mode",
				one_shot = false,
			}),
		}),
	},
}

config.key_tables = {
	copy_mode = {
		{ key = "k", action = act.ScrollByLine(-1) },
		{ key = "j", action = act.ScrollByLine(1) },
		{
			key = "s",
			mods = "CTRL",
			action = act.CopyMode("ClearPattern"),
		},
		{
			key = "u",
			mods = "CTRL",
			action = act.ScrollByPage(-1),
		},
		{
			key = "d",
			mods = "CTRL",
			action = act.ScrollByPage(1),
		},
		{
			key = "N",
			mods = "SHIFT",
			action = act.CopyMode("NextMatch"),
		},
		{
			key = "n",
			mods = "NONE",
			action = act.CopyMode("PriorMatch"),
		},
		{
			key = "DownArrow",
			mods = "NONE",
			action = act.CopyMode("NextMatch"),
		},
		{
			key = "UpArrow",
			mods = "NONE",
			action = act.CopyMode("PriorMatch"),
		},
		{
			key = "/",
			mods = "NONE",
			action = act({ Search = { CaseSensitiveString = "" } }),
		},
		{
			key = "?",
			mods = "SHIFT",
			action = { Search = { CaseSensitiveString = "" } },
		},
		{
			key = "Escape",
			action = act.Multiple({
				act.CopyMode("Close"),
				"PopKeyTable",
				"ScrollToBottom",
				--act.SendKey { key = 'q', mods = 'CTRL' },
			}),
		},
		{
			key = "q",
			action = act.Multiple({
				act.CopyMode("Close"),
				"PopKeyTable",
				"ScrollToBottom",
				--act.SendKey { key = 'q', mods = 'CTRL' },
			}),
		},
		{
			key = "c",
			mods = "CTRL",
			action = act.Multiple({
				act.CopyMode("Close"),
				"PopKeyTable",
				"ScrollToBottom",
				--act.SendKey { key = 'q', mods = 'CTRL' },
			}),
		},
	},
	search_mode = {
		-- These are a hack as I don't know if there is a way to disable key
		-- bindings that are currently active (in the preceding copy mode)
		{ key = "k", mods = "NONE", action = act.SendKey({ key = "k" }) },
		{ key = "j", mods = "NONE", action = act.SendKey({ key = "j" }) },
		{ key = "n", mods = "NONE", action = act.SendKey({ key = "n" }) },
		{
			key = "N",
			mods = "SHIFT",
			action = act.SendKey({ key = "N", mods = "SHIFT" }),
		},
		{ key = "q", mods = "NONE", action = act.SendKey({ key = "q" }) },
		{ key = "/", mods = "NONE", action = act.SendKey({ key = "/" }) },
		{
			key = "?",
			mods = "SHIFT",
			action = act.SendKey({ key = "?", mods = "SHIFT" }),
		},
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
		{
			key = "Escape",
			action = act.Multiple({
				act.CopyMode("Close"),
				"PopKeyTable",
				"ScrollToBottom",
				--act.SendKey { key = 'q', mods = 'CTRL' },
			}),
		},
	},
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

--wezterm.on(
--  'format-tab-title',
--  function(tab, tabs, panes, config, hover, max_width)
--    local edge_background = '#0b0022'
--    local background = '#1b1032'
--    local foreground = '#808080'
--
--    if tab.is_active then
--      background = '#2b2042'
--      foreground = '#c0c0c0'
--    elseif hover then
--      background = '#3b3052'
--      foreground = '#909090'
--    end
--
--    local edge_foreground = background
--
--    local title = tab_title(tab)
--
--    -- ensure that the titles fit in the available space,
--    -- and that we have room for the edges.
--    title = wezterm.truncate_right(title, max_width - 2)
--
--    return {
--      { Background = { Color = edge_background } },
--      { Foreground = { Color = edge_foreground } },
--      { Text = SOLID_LEFT_ARROW },
--      { Background = { Color = background } },
--      { Foreground = { Color = foreground } },
--      { Text = title },
--      { Background = { Color = edge_background } },
--      { Foreground = { Color = edge_foreground } },
--      { Text = SOLID_RIGHT_ARROW },
--    }
--  end
--)

-- and finally, return the configuration to wezterm
return config
