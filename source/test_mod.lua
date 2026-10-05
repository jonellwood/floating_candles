local path=arg[1] or 'hogwarts_candles'
local nodes,crafts,world,messages={}, {}, {}, {}
local consume=0
local protected=false;local creative=false;local interact=true;local loaded=true
minetest={LIGHT_MAX=14}
local mt=minetest
function mt.get_current_modname()return 'hogwarts_candles'end
function mt.register_node(n,d)nodes[n]=d end
function mt.register_craft(d)crafts[#crafts+1]=d end
function mt.chat_send_player(n,s)messages[#messages+1]=s end
function mt.check_player_privs()return interact end
function mt.is_protected()return protected end
function mt.record_protection_violation()end
function mt.is_creative_enabled()return creative end
local function key(p)return p.x..','..p.y..','..p.z end
function mt.get_node_or_nil(p)if loaded then return world[key(p)] or {name='air'} end end
function mt.set_node(p,n)world[key(p)]=n end
local player={pos={x=0,y=0,z=0},dir={x=0,y=0,z=1}}
function player:is_player()return true end
function player:get_player_name()return 'tester'end
function player:get_pos()return self.pos end
function player:get_look_dir()return self.dir end
function player:get_properties()return {eye_height=1.625} end
local function item(n)return {get_name=function()return n end,take_item=function()consume=consume+1 end}end
local function reset()world={};consume=0;protected=false;creative=false;interact=true;loaded=true end
dofile(path..'/init.lua')
local count=0
for name,d in pairs(nodes)do
 count=count+1
 assert(d.light_source==14 and d.walkable==false)
 assert(not d.groups.attached_node and not d.groups.falling_node)
 assert(not d.on_timer and not d.on_construct,'support/fuel timer unexpected')
 assert(d.tiles[1].animation.aspect_w==64 and d.tiles[1].animation.aspect_h==64)
 reset();d.on_secondary_use(item(name),player);assert(world['0,2,4'].name==name and consume==1)
 reset();creative=true;d.on_secondary_use(item(name),player);assert(world['0,2,4'].name==name and consume==0)
 reset();protected=true;d.on_secondary_use(item(name),player);assert(next(world)==nil and consume==0)
 reset();interact=false;d.on_secondary_use(item(name),player);assert(next(world)==nil and consume==0)
 reset();loaded=false;d.on_secondary_use(item(name),player);assert(next(world)==nil and consume==0)
 reset();world['0,2,4']={name='test:stone'};d.on_secondary_use(item(name),player);assert(world['0,2,4'].name=='test:stone' and consume==0)
 reset();world['0,2,4']={name='ignore'};d.on_secondary_use(item(name),player);assert(world['0,2,4'].name=='ignore' and consume==0)
 reset();d.on_secondary_use(item(name),nil);assert(next(world)==nil)
 reset();player.dir={x=-1,y=0,z=0};d.on_secondary_use(item(name),player);assert(world['-4,2,0'].name==name);player.dir={x=0,y=0,z=1}
end
assert(count==2 and #crafts==2)
print('PASS: two support-free light-14 candles; air placement, negative coordinates, creative consumption, protection, interact privilege, blocked/unloaded cells, nil player and size conversion.')
