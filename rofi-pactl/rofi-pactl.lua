#!/usr/bin/env lua

local function execute(cmd)
    print((">> Command: %s"):format(cmd))
    local handle = io.popen(cmd)
    if handle ~= nil then
        local result = handle:read("*a")
        handle:close()
        print(("<< Result: %s"):format(result))
        return result
    end
    error(string.format("Command could not be executed: %s", cmd))
end
local rofi_command = "rofi -dmenu -no-fixed-num-lines -yoffset -100 -i -p"

local cards = execute("pactl list short cards")
print(cards)

local divider = "-------------"
local pavucontrol = "Pavucontrol"
local pavucontrol_tabs = { "na", "na", "na", "Input Devices", "Configuration" }
local values = {}
for _, v in ipairs(pavucontrol_tabs) do
    if not v:match("na") then
        values[#values + 1] = ("%s: %s"):format(pavucontrol, v)
    end
end
local pavucontrol_opts = string
    .gsub(
        [[
%s]],
        "NN",
        pavucontrol
    )
    :format(table.concat(values, "\n"))

local card = "bluez_card.94_DB_56_F5_6A_2D"
local profiles = execute(
    ("pactl list cards | grep %s -A 40 | grep Profiles -A 5 | grep Profiles -v -A 10 | grep Active -B 10 | grep -v Active")
    :format(
        card
    )
):gsub("\t", "")
local profiles_table = {}
local set_profile = "Pactl profile"
for profile in profiles:gmatch("([^\n]*)\n?") do
    if #profile > 0 then
        profiles_table[#profiles_table + 1] = ("%s > %s: %s"):format(set_profile, profile:gsub("\\(.*\\)", ""), card)
    end
end

local options_template = string.gsub(
    [[
%sDD
%s
DD
%s
]],
    "D",
    divider
)
local options = string.format(options_template, cards, pavucontrol_opts, table.concat(profiles_table, "\n"))

local function execute_rofi(opts, title)
    local chosen = execute(string.format('echo "%s" | %s "%s"', opts, rofi_command, title))
    return chosen
end

local chosen = execute_rofi(options, "Sound Cards")

if chosen:match(pavucontrol) then
    for k, v in ipairs(pavucontrol_tabs) do
        if chosen:match(v) then
            execute(("pavucontrol --tab=%s"):format(k))
        end
    end
end
if chosen:match(set_profile) then
    local selected_card = card
    local selected_profile = chosen:match(".*> (.*):.*"):gmatch("([^:]+)")()
    execute(("pactl set-card-profile %s %s"):format(selected_card, selected_profile))

    -- for k, v in ipairs(pavucontrol_tabs) do
    --     if chosen:match(v) then
    --         execute(("pavucontrol --tab=%s"):format(k))
    --     end
    -- end
end

-- local chosen_card = string.gsub(chosen, '[\t]', ' ')
-- local chosen = execute_rofi(options, string.format('%s Profile', chosen_card))
-- print(chosen_card)
