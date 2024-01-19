local wezterm = require 'wezterm'

local act = wezterm.action
local config = {}


if wezterm.config_builder then
  config = wezterm.config_builder()
end
 
config.color_scheme = 'Catppuccin Macchiato'
config.enable_scroll_bar = true
config.font = wezterm.font 'Hack'
config.font_size = 18.0
config.pane_focus_follows_mouse = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.9

-- Automatically connect to a running domain
config.unix_domains = { { name = 'unix' } }
config.default_gui_startup_args = { 'connect', 'unix' }

-- Key bindings
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 8000 }

config.keys = {
  -- Tab control and navigation
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'Space', mods = 'LEADER|CTRL', action = act.ActivateLastTab },

  -- Pane control and navigation
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = '"', mods = 'LEADER|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },

  },
  {
    key = '%',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- tmux style command palette
  { key = ':', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },


  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Tab name',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- tmux style key bindings for search and copy
  {
    key = '[',
    mods = 'LEADER',
    action = act.Multiple {
      act.SendKey { key = 's', mods = 'CTRL' },
      act.ActivateKeyTable {
        name = 'copy_mode',
        one_shot = false,
      },
    },
  },
}

config.key_tables = {
  copy_mode = {
    { key = 'k', action = act.ScrollByLine(-1) },
    { key = 'j', action = act.ScrollByLine(1) },
    { key = 'u', mods = 'CTRL', action = act.ScrollByPage(-1) },
    { key = 'd', mods = 'CTRL', action = act.ScrollByPage(1) },
    { key = 'N', mods = 'SHIFT', action = act.CopyMode 'NextMatch' },
    { key = 'n', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key="/", mods="NONE", action = act { Search = { CaseSensitiveString="" }}},
    { key="?", mods="SHIFT", action = act { Search = { CaseSensitiveString="" }}},
    { key = 'Escape',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
    { key = 'q',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
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
