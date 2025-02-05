-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

-- config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 15

-- colorscheme:
config.color_scheme = "Catppuccin Macchiato"

-- set max fps
config.max_fps = 240

-- tmux
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "v",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		mods = "LEADER",
		key = "f",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		mods = "LEADER",
		key = "d",
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = "LEADER",
		key = "r",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_pane_mode",
			one_shot = false,
		}),
	},
}

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane_mode' here corresponds to the name="resize_pane_mode" in
	-- the key assignments above.
	resize_pane_mode = {
		{ key = "LeftArrow", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- smart-splits.nvim integration
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	-- direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "H", "J", "K", "L" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "CTRL", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

local function username()
	return os.getenv("USER") or os.getenv("LOGNAME") or os.getenv("USERNAME")
end

local cwd = ""
-- local default_opts = { max_length = 10 }
local function currentDir(tab)
	local cwd_uri = tab:active_pane():get_current_working_dir()
	if cwd_uri then
		local file_path = cwd_uri.file_path
		cwd = file_path:match("([^/]+)/?$")
		if cwd == username() then
			cwd = "~"
		end
		-- if cwd and #cwd > default_opts.max_length then
		-- 	cwd = cwd:sub(1, default_opts.max_length - 1) .. "…"
		-- end
	end
	return "  " .. (cwd or "") .. " "
end
--
local tabline = wezterm.plugin.require("https://github.com/makramab/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Macchiato",
		color_overrides = {
			-- Defining colors for a new key table
			resize_pane_mode = {
				a = { fg = "#181825", bg = "#cba6f7" },
				b = { fg = "#cba6f7", bg = "#313244" },
				c = { fg = "#cdd6f4", bg = "#181825" },
			},
		},
		section_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thin,
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
	},
	sections = {
		tabline_a = {
			{
				"mode",
				padding = { left = 1, right = 2 },
				fmt = function(mode, window)
					local key_table_name = window:active_key_table()
					if key_table_name == "resize_pane_mode" then
						return wezterm.nerdfonts.md_arrow_expand_all
					elseif window:leader_is_active() then
						return wezterm.nerdfonts.md_keyboard_outline
					elseif mode == "NORMAL" then
						return wezterm.nerdfonts.cod_terminal
					elseif mode == "COPY" then
						return wezterm.nerdfonts.md_scissors_cutting
					elseif mode == "SEARCH" then
						return wezterm.nerdfonts.oct_search
					end

					return mode
				end,
			},
		},
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			--{ "parent", padding = 0 },
			--"/",
			{ "process", padding = { left = 0, right = 1 } },
			-- { "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { currentDir, "ram" },
		tabline_y = {
			"cpu",
		},
		tabline_z = { username },
	},
	extensions = {},
})

tabline.apply_to_config(config)

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

config.tab_and_split_indices_are_zero_based = true

local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
