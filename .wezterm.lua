local wt = require("wezterm");

local TabBackground = "#000"
local TabForeground = "#aaa"
local TabForegroundActive = "#fff"

function string.split(str, sep)
	local t = {}
	for s in string.gmatch(str, "([^"..sep.."]+)") do
		table.insert(t, s)
	end
	return t
end

function reduce_title(title)
	title = title:gsub("\\", "/")
	title = title:split("/")
	return title[#title]
end

wt.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	return reduce_title(tab.active_pane.title)
end)

wt.on("format-window-title", function(tab, pane, tabs, panes, config)
	return reduce_title(tab.active_pane.title)
end)

return {
	color_scheme = "gooey",
	colors = {
		tab_bar = {
			background = TabBackground,
			active_tab = {
				bg_color = TabBackground,
				fg_color = TabForegroundActive,
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = TabBackground,
				fg_color = TabForeground,
				intensity = "Normal",
			},
			inactive_tab_hover = {
				bg_color = TabBackground,
				fg_color = TabForegroundActive,
				intensity = "Normal",
			},
			new_tab = {
				bg_color = TabBackground,
				fg_color = TabForeground,
			},
			new_tab_hover = {
				bg_color = TabBackground,
				fg_color = TabForegroundActive,
			},
		},
	},
	initial_cols = 90,
	initial_rows = 25,
	font = wt.font("Firacode"),
	font_size = 11,
	default_cursor_style = "BlinkingBar",
	cursor_blink_rate = 500,
	window_decorations="TITLE|RESIZE",
	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 0.85,
	alternate_buffer_wheel_scroll_speed = 1,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	keys = {
		{
			key = "t",
			mods = "CTRL",
			action = wt.action{
				SpawnTab = "DefaultDomain",
			},
		},
		{
			key = "w",
			mods = "CTRL",
			action = wt.action{
				CloseCurrentTab = {
					confirm = false,
				},
			},
		},
		{
			key = "Tab",
			mods = "CTRL",
			action = wt.action{
				ActivateTabRelative = 1,
			},
		},
	},
}
