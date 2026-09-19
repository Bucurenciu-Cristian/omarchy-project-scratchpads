-- Project Scratchpads keybindings.
-- Loaded from ~/.config/hypr/bindings.lua by bin/install; do not copy it there.

local plugin = os.getenv("HOME") .. "/.config/omarchy/plugins/bucurenciu.project-scratchpads"
local function cmd(name, args)
  return plugin .. "/bin/" .. name .. (args and (" " .. args) or "")
end

o.bind("SUPER + SEMICOLON", "Toggle project scratchpad", cmd("omarchy-project-scratchpad", "toggle"))
o.bind("SUPER + ALT + SEMICOLON", "Send window to project scratchpad", cmd("omarchy-project-scratchpad", "send"))
o.bind("SUPER + SHIFT + P", "Project picker", cmd("omarchy-project-picker"))
o.bind("SUPER + CTRL + ALT + RETURN", "Project terminal", cmd("omarchy-project-terminal"))

for i = 1, 9 do
  o.bind("CTRL + ALT + " .. i, "Switch to project " .. i,
    cmd("omarchy-project-select", i) .. " && " .. cmd("omarchy-project-scratchpad", "toggle"))
  o.bind("CTRL + ALT + SHIFT + " .. i, "Send window to project " .. i,
    cmd("omarchy-project-scratchpad", "send-to " .. i))
end
