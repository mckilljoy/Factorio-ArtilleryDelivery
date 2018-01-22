
function positionString(position)
  return "(" .. position.x .. "," .. position.y .. ")"
end

function onTriggerCreatedEntity(event)
  local prefix = "explosion-"
  local item = string.sub(event.entity.name, string.len(prefix) + 1)

  if item then
    game.surfaces[1].spill_item_stack(event.entity.position, {name = item, count = 50})
  end

end

function onGuiClosed(event)
  if event.entity and (event.entity.name == "artillery-delivery-turret") then
    game.players[1].gui.left["artillery-delivery-targeting"].destroy()
  end
end

function inRange(turret_pos, target_pos)
  local dx = turret_pos.x - target_pos.x
  local dy = turret_pos.y - target_pos.y
  
  local d = math.sqrt( dx * dx + dy * dy )
  if d < 560 then
    return true
  else
    return false
  end
end

local target_camera_gui
local target_ents
local turret_ent
function onGuiOpened(event)
  if event.entity and (event.entity.name == "artillery-delivery-turret") then

    turret_ent = event.entity
	
	-- gui
    local gui = game.players[1].gui.left.add{type = "frame", name = "artillery-delivery-targeting", caption = "Artillery Delivery Target", direction = "vertical"}
	gui.style.minimal_width = 320
	gui.style.minimal_height = 320
	
	-- artillery camera
	gui.add{type = "label", name = "artillery-label", caption = "Turret:"}
	artillery_camera_gui = gui.add{type = "camera", name = "artillery-camera", caption = "Turret", position = event.entity.position, zoom = 0.5 }
	artillery_camera_gui.style.minimal_width = 300
	artillery_camera_gui.style.minimal_height = 300
	artillery_camera_gui.position = turret_ent.position

	-- dropdown
	local drop = gui.add{type = "drop-down", items = {"none"} }
	drop.style.minimal_width = 300
	drop.style.maximal_width = 300
	drop.selected_index = 1
	targets = game.surfaces[1].find_entities_filtered{name= "dummy-artillery-delivery-target", force = "enemy"}
	
	-- target camera
	gui.add{type = "label", name = "target-label", caption = "Target:"}
	target_camera_gui = gui.add{type = "camera", name = "target-camera", caption = "Target", position = event.entity.position, zoom = 0.5 }
	target_camera_gui.style.minimal_width = 300
	target_camera_gui.style.minimal_height = 300
	target_camera_gui.style.maximal_width = 300
	target_camera_gui.style.maximal_height = 300

	-- content
	target_ents = {}
	local index = 1
	local set_index = 1
	for k,v in pairs(targets) do
	  if inRange(turret_ent.position, v.position) then
        drop.add_item("Artillery Target " .. positionString(v.position) )
        table.insert(target_ents, v)
        if turret_ent.shooting_target == v then
          set_index = index + 1
	      target_camera_gui.position = v.position
        end
	  end
      index = index + 1
	end
	
	drop.selected_index = set_index
	
  end
end

function onGuiSelectionStateChanged(event)
  if target_camera_gui then
    local index = event.element.selected_index
	if index == 1 and turret_ent then
      turret_ent.active = false
	  turret_ent.shooting_target = turret_ent
    elseif index > 1 and target_ents then
	  index = index - 1
	  local target = target_ents[index]
	  target_camera_gui.position = target.position
	  turret_ent.shooting_target = target
	  turret_ent.active = true
	end
  end
  
end


function onBuiltEntity(event)
  local ent = event.created_entity
  
  if ent and (ent.name == "artillery-delivery-turret") then
    ent.active = false
  end
  
  if ent and (ent.name == "artillery-delivery-target") then
    local dummy_ent = game.surfaces[1].create_entity{name = "dummy-artillery-delivery-target", force = "enemy", position = ent.position }
	dummy_ent.destructible = false
	dummy_ent.active = false
	dummy_ent.teleport(ent.position)
  end
end

function onRemovedEntity(event)
  local ent = event.entity
  
  if ent and (ent.name == "artillery-delivery-turret") then
  end
  
  if ent and (ent.name == "artillery-delivery-target") then
	local dummy_ent = game.surfaces[1].find_entities_filtered{
	  name = "dummy-artillery-delivery-target",
	  area = { {ent.position.x - 1.0, ent.position.y - 1.0}, {ent.position.x + 1.0, ent.position.y + 1.0}}
	}[1]
	  
	--local dummy_ent = game.surfaces[1].find_entity("dummy-artillery-delivery-target", ent.position)
	--local dummy_ent = game.surfaces[1].find_nearest_enemy{ position = ent.position, max_distance = 4.0 }
	if dummy_ent == nil then
	  game.print("dummy nil")
	  return
	end
    local turrets = game.surfaces[1].find_entities_filtered{name= "artillery-delivery-turret"}
    for k,v in pairs(turrets) do
	  if v.shooting_target == dummy_ent then
		v.active = false
      end
	end
	dummy_ent.destroy()
  end
end

script.on_event(defines.events.on_trigger_created_entity, onTriggerCreatedEntity)

script.on_event(defines.events.on_gui_opened, onGuiOpened)
script.on_event(defines.events.on_gui_closed, onGuiClosed)
script.on_event(defines.events.on_gui_selection_state_changed, onGuiSelectionStateChanged)

script.on_event(defines.events.on_built_entity, onBuiltEntity)
script.on_event(defines.events.on_robot_built_entity, onBuiltEntity)

script.on_event(defines.events.on_entity_died, onRemovedEntity)
script.on_event(defines.events.on_robot_mined_entity, onRemovedEntity)
script.on_event(defines.events.on_player_mined_entity, onRemovedEntity)
