-- i got too lazy to add more
local value_offset = nil

http.get("https://offsets.ntgetwritewatch.workers.dev/offsets.hpp", function(v)
    local offset = v:match("inline%s+constexpr%s+uintptr_t%s+Value%s*=%s*(0x%x+)%s*;")
    if offset then
        value_offset = offset
    end
end)

local local_player = globals.localplayer()
local workspace = globals.workspace()

ui.label("Welcome "..utils.get_username().." Thanks for using my script <3")
ui.label("Main Settings")
local inf_ammo_checkbox = ui.new_checkbox("Inf Ammo")
ui.label("")
ui.label("Teleport Settings")
local dropoff_teleport_button = ui.button("Tp To Dropoff Zone")

local primary_ammo_value = local_player:ModelInstance():FindChild("PrimaryAmmo")
if not primary_ammo_value then
    return print("Stamina Value Not Found!")
end

local secondary_ammo_value = local_player:ModelInstance():FindChild("SecondaryAmmo")
if not secondary_ammo_value then
    return print("Max Stamina Value Not Found!")
end

local last_saved_position = nil

function get_dropoff_zone()
    return workspace:FindChild("BagSecuredArea") and workspace:FindChild("BagSecuredArea"):FindChildByClass("Part") or nil
end

cheat.set_callback("paint", function()
    if inf_ammo_checkbox:get() then
        utils.read_memory("float", primary_ammo_value:Address() + value_offset)
        utils.read_memory("float", secondary_ammo_value:Address() + value_offset)
        utils.write_memory("float", primary_ammo_value:Address() + value_offset, 100)
        utils.write_memory("float", secondary_ammo_value:Address() + value_offset, 100)
    end

    if dropoff_teleport_button:get() then
        local dropoff_zone = get_dropoff_zone()
        if (not dropoff_zone) then
            return print("Dropoff Zone Not Found!")
        end
        local_player:ModelInstance():FindChild("HumanoidRootPart"):Primitive():SetPartPosition(dropoff_zone:Primitive():GetPartPosition())
    end
end)
