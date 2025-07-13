-- offsets might not always be correct
local attribute_to_value_offset = 0x30
local frame_position_x_offset = 0x3B8

local local_player = globals.localplayer()
local workspace = globals.workspace()

local root_part = local_player:ModelInstance():FindChild("HumanoidRootPart")
local player_gui = local_player:FindChild("PlayerGui")
local backpack = local_player:FindChild("Backpack")

local active = workspace:FindChild("Active")
if not active then
    return print("Active Folder Not Found!")
end

local pizza_customer = active:FindChild("PizzaCustomers")
if not pizza_customer then
    return print("Pizza Customers Folder Not Found!")
end

local world = workspace:FindChild("World")
if not world then
    return print("World Folder Not Found!")
end

local npcs = world:FindChild("NPCs")
if not npcs then
    return print("NPCs Not Found!")
end

local interactive = world:FindChild("Interactive")
if not interactive then
    return print("Interactive Folder Not Found!")
end

local purchaseable = interactive:FindChild("Purchaseable")
if not purchaseable then
    return print("Purchaseable Folder Not Found!")
end

local enchanting = interactive:FindChild("Enchanting")
if not enchanting then
    return print("Enchanting Folder Not Found!")
end

local item_names = {}
local npc_names = {}

local last_click_time = 0

for _, v in ipairs(npcs:Children()) do
    table.insert(npc_names, v:Name())
end

for _, v in ipairs(purchaseable:Children()) do
    table.insert(item_names, v:Name())
end

ui.label("Welcome "..utils.get_username().." Thanks for using my script <3")
ui.label("Note: Tp is maybe detected use at own risk!")
ui.label("")
ui.label("Dig Settings")
local dig_minigame = ui.new_checkbox("Auto Dig Minigame")
local dig_minigame_method = ui.new_combo("Select Dig Minigame Option", "Legit,Blatant")
ui.label("")
ui.label("Pizza Delivery Settings")
local pizza_penguin_teleport = ui.button("Teleport To Pizza Penguin")
local customer_teleport = ui.button("Teleport To Customer")
ui.label("")
ui.label("Main Teleport Settings")
local npc_dropdown = ui.new_combo("Select Npc", npc_names)
local npc_teleport_button = ui.button("Teleport To Selected Npc")
local item_dropdown = ui.new_combo("Select Item", item_names)
local item_teleport_button = ui.button("Teleport To Selected Item")
ui.label("")
ui.label("Misc Teleport Settings")
local enchantment_table_teleport = ui.button("Teleport To Enchantment Table")
local merchant_teleport = ui.button("Teleport To Merchant")
local meteor_teleport = ui.button("Teleport To Meteor")

cheat.set_callback("paint", function()
    if dig_minigame:get() then
        if player_gui:FindChild("Dig") then
            local current_time = globals.curtime()
            local strong_hit = player_gui:FindChild("Dig"):FindChild("Safezone"):FindChild("Holder"):FindChild("Area_Strong")
            local player_bar = player_gui:FindChild("Dig"):FindChild("Safezone"):FindChild("Holder"):FindChild("PlayerBar")
            if globals.is_focused() then
                local clicked_time = globals.curtime()
                local last_positon = utils.read_memory("float", strong_hit:Address() + frame_position_x_offset)
                if dig_minigame_method:get() == 1 then
                    utils.write_memory("float", player_bar:Address() + frame_position_x_offset, utils.read_memory("float", strong_hit:Address() + frame_position_x_offset))
                    if clicked_time - last_click_time >= 0.25 then
                        input.click()
                        last_click_time = clicked_time
                    end
                elseif dig_minigame_method:get() == 0 then
                    local distance = utils.read_memory("float", player_bar:Address() + frame_position_x_offset) - utils.read_memory("float", strong_hit:Address() + frame_position_x_offset)
                    if distance < 0.02 and clicked_time - last_click_time >= 1 and distance ~= last_positon then 
                        input.click()
                        last_click_time = clicked_time
                    end
                end
            end
        end
    end

    if pizza_penguin_teleport:get() then
        root_part:Primitive():SetPartPosition(npcs:FindChild("Pizza Penguin"):FindChild("HumanoidRootPart"):Primitive():GetPartPosition())
    end

    if customer_teleport:get() then
        if not pizza_customer:FindChildByClass("Model") then
            return print("Pizza Customer Not Found!")
        end
        root_part:Primitive():SetPartPosition(pizza_customer:FindChildByClass("Model"):FindChild("HumanoidRootPart"):Primitive():GetPartPosition())
    end

    if meteor_teleport:get() then
        if active:FindChild("Meteor") then
            root_part:Primitive():SetPartPosition(active:FindChild("Meteor"):Primitive():GetPartPosition())
        else
            print("Meteor Not Found!")
        end
    end

    if merchant_teleport:get() then
        if npcs:FindChild("Merchant Cart") then
            root_part:Primitive():SetPartPosition(npcs:FindChild("Merchant Cart"):FindChild("DO NOT DELETE!!!"):Primitive():GetPartPosition())
        end
    end

    if enchantment_table_teleport:get() then
        root_part:Primitive():SetPartPosition(enchanting:FindChild("EnchantmentAltar"):FindChild("EnchantPart"):Primitive():GetPartPosition())
    end

    if npc_teleport_button:get() then
        for i in ipairs(npcs:Children()) do
            if i == npc_dropdown:get() then
                root_part:Primitive():SetPartPosition(npcs:FindChild(npc_names[i]):FindChild("HumanoidRootPart"):Primitive():GetPartPosition())
            end
        end
    end

    if item_teleport_button:get() then
        for i in ipairs(purchaseable:Children()) do
            if i == item_dropdown:get() then
                if not purchaseable:FindChild(item_names[i]):FindChildByClass("Part") then
                    return print("Cant Teleport To This Item As It Dosent Have A Part Or Is Missing!")
                end
                root_part:Primitive():SetPartPosition(purchaseable:FindChild(item_names[i]):FindChildByClass("Part"):Primitive():GetPartPosition())
            end
        end
    end
end)
