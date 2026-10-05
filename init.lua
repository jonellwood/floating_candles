-- Original floating candles for Asuna / Luanti. No external dependencies.
local mt = minetest
local mod = mt.get_current_modname()
local maximum_light = mt.LIGHT_MAX or 14

local function message(player, text)
    mt.chat_send_player(player:get_player_name(), "[Floating Candles] " .. text)
end
local function place_in_air(itemstack, player)
    if not player or not player:is_player() then return itemstack end
    local name = player:get_player_name()
    if not mt.check_player_privs(name, {interact=true}) then return itemstack end
    local p = player:get_pos()
    local d = player:get_look_dir()
    local height = player:get_properties().eye_height or 1.625
    local target = {
        x=math.floor(p.x+d.x*4+0.5),
        y=math.floor(p.y+height+d.y*4+0.5),
        z=math.floor(p.z+d.z*4+0.5),
    }
    local node = mt.get_node_or_nil(target)
    if not node or node.name=="ignore" then
        message(player,"Target is not loaded. Move closer.")
        return itemstack
    end
    if node.name~="air" then
        message(player,"The spot four blocks ahead is occupied. Aim at clear air.")
        return itemstack
    end
    if mt.is_protected(target,name) then
        mt.record_protection_violation(target,name)
        message(player,"That spot is protected.")
        return itemstack
    end
    mt.set_node(target,{name=itemstack:get_name()})
    if not mt.is_creative_enabled(name) then itemstack:take_item() end
    return itemstack
end

for _,size in ipairs({"tall","short"}) do
    local bottom = size=="tall" and -0.46 or -0.16
    mt.register_node(mod..":candle_"..size, {
        description="Floating Candle ("..(size=="tall" and "Tall" or "Short")..")\nMaximum light; no fuel or support required\nRight-click clear air: place four blocks ahead",
        drawtype="mesh",mesh="floating_candles_"..size..".obj",
        tiles={{name="floating_candles_atlas.png",
                animation={type="vertical_frames",aspect_w=64,aspect_h=64,length=0.8},
                backface_culling=false}},
        use_texture_alpha="clip",
        paramtype="light",light_source=maximum_light,
        sunlight_propagates=true,walkable=false,pointable=true,
        buildable_to=false,is_ground_content=false,stack_max=99,
        groups={dig_immediate=3,floating_candle=1},
        -- No attached_node / falling_node groups: persists without a support.
        selection_box={type="fixed",fixed={-0.1,bottom,-0.1,0.1,0.5,0.1}},
        collision_box={type="fixed",fixed={-0.07,bottom,-0.07,0.07,0.24,0.07}},
        on_secondary_use=place_in_air,
        -- Standard on_place / on_dig retain engine checks and ordinary scaffolding placement.
    })
end
-- Preserve resources when swapping the decorative size.
mt.register_craft({type="shapeless",output=mod..":candle_short",recipe={mod..":candle_tall"}})
mt.register_craft({type="shapeless",output=mod..":candle_tall",recipe={mod..":candle_short"}})
-- The standalone mod is intended for Creative building; it does not guess
-- Asuna-specific wax, torch or honey item identifiers for a base recipe.
