
require("prototypes.categories")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.entities")
require("prototypes.technologies")

-- Edit this file to add new items
require("supported-items")

-- Misc entities to get everything working
local lamp_item = table.deepcopy(data.raw["item"]["small-lamp"])
lamp_item.name = "artillery-delivery-target"
lamp_item.place_result = "artillery-delivery-target"
lamp_item.subgroup = "artillery-delivery-turrets"
lamp_item.group = "artillery-delivery"
lamp_item.order = "f[artillery-delivery]-b"
data:extend({lamp_item})

local lamp_recipe = table.deepcopy(data.raw["recipe"]["small-lamp"])
lamp_recipe.name = "artillery-delivery-target"
lamp_recipe.result = "artillery-delivery-target"
lamp_recipe.subgroup = "artillery-delivery-turrets"
lamp_recipe.group = "artillery-delivery"
lamp_recipe.order = "f[artillery-delivery]-b"
data:extend({lamp_recipe})

local dummy_gun_ent = table.deepcopy(data.raw["ammo-turret"]["gun-turret"])
local lamp_ent = table.deepcopy(data.raw["lamp"]["small-lamp"])
lamp_ent.name = "artillery-delivery-target"
lamp_ent.minable.result = "artillery-delivery-target"
lamp_ent.collision_box = dummy_gun_ent.selection_box
lamp_ent.selection_box = dummy_gun_ent.selection_box
data:extend({lamp_ent})

local dummy_gun_item = table.deepcopy(data.raw["item"]["gun-turret"])
dummy_gun_item.name = "dummy-artillery-delivery-target"
dummy_gun_item.place_result = "dummy-artillery-delivery-target"
data:extend({dummy_gun_item})

local animation = {
  layers = { 
    { 
	  axially_symmetrical = false, direction_count = 1, frame_count = 1, height = 1, width = 1, priority = "very-low",
      shift = {
              0,
              0
              },
      stripes = {
              {
                filename = "__ArtilleryDelivery__/graphics/entities/invisible-pixel.png",
                height_in_frames = 1,
                width_in_frames = 1
              }
	  }
    }
  }
}

dummy_gun_ent.name = "dummy-artillery-delivery-target"
dummy_gun_ent.collision_box = {{0,0},{0,0}}
dummy_gun_ent.selection_box = {{0,0},{0,0}}
dummy_gun_ent.prepared_animation = animation
dummy_gun_ent.preparing_animation = animation
dummy_gun_ent.folded_animation = animation
dummy_gun_ent.folding_animation = animation
dummy_gun_ent.base_picture = animation
data:extend({dummy_gun_ent})

function ArtilleryShellItem(name, icons, subgroup, order, localized_name)
  
  local item_proto =
  {
    type = "ammo",
    name = "artillery-shell-" .. name,
    subgroup = "artillery-delivery-shells",
    group = "artillery-delivery",
    order = order,
    icon_size = 32,
    icons = icons,
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "artillery-delivery-shell",
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "artillery",
          projectile = "artillery-delivery-projectile-" .. name,
          starting_speed = 1,
          direction_deviation = 0.03,
          range_deviation = 0.03,
          source_effects =
          {
            type = "create-explosion",
            entity_name = "artillery-cannon-muzzle-flash"
          },
        }
      },
    },
    stack_size = 1,
    localised_name =
    {
      "item-name.artillery-delivery-shell",
      {
        localized_name
      }
    },
  }
  
  data:extend({item_proto})
end

function ArtilleryShellProjectile(name, tint)
  
  local projectile_proto =
  {
    type = "artillery-projectile",
    name = "artillery-delivery-projectile-" .. name,
    flags = {"not-on-map"},
    acceleration = 0,
    direction_only = true,
    reveal_map = true,
    map_color = tint,
    picture =
    {
        filename = "__ArtilleryDelivery__/graphics/entities/hr-shell.png",
        width = 64,
        height = 64,
        scale = 0.5,
		tint = tint,
    },
    shadow =
    {
        filename = "__ArtilleryDelivery__/graphics/entities/hr-shell-shadow.png",
        width = 64,
        height = 64,
        scale = 0.5,
    },
    chart_picture =
    {
        filename = "__ArtilleryDelivery__/graphics/entities/artillery-shoot-map-visualization.png",
        flags = { "icon" },
        frame_count = 1,
        width = 64,
        height = 64,
        priority = "high",
        scale = 0.25,
		tint = tint,
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "explosion-" .. name,
			trigger_created_entity = true
          },
          {
            type = "create-entity",
            entity_name = "small-scorchmark",
            check_buildability = true,
          },
        }
      }
    }	  
  }
  
  local explosion_proto = table.deepcopy(data.raw.explosion["big-artillery-explosion"])
  explosion_proto.name = "explosion-" .. name
  
  data:extend({projectile_proto})
  data:extend({explosion_proto})
end

function ArtilleryShellRecipe(name, icons, subgroup, order, localized_name)

  local recipe_proto =
  {
    type = "recipe",
    name = "artillery-shell-" .. name,
    subgroup = "artillery-delivery-shells",
    group = "artillery-delivery",
    order = order,
    energy_required = 1,
    enabled = "false",
    hide_from_stats = true,
    allow_decomposition = false,
    icon_size = 32,
    icons = icons,
    ingredients =
    {
      {type = "item", name = name, amount = 50}
    },
    results =
    {
      {type = "item", name = "artillery-shell-" .. name, amount = 1}
    },
    localised_name =
    {
      "recipe-name.artillery-delivery-shell",
      {
        localized_name
      }
    },
  }
  
  local effects = data.raw["technology"]["artillery-delivery"].effects
  table.insert(effects, {type = "unlock-recipe", recipe = recipe_proto.name})
  data:extend({recipe_proto})
end


for k,item_name in pairs(valid_artillery_items) do
  local item = data.raw.item[item_name]
  local tint = custom_tints[item_name]

  local icons = nil
  
  if tint and settings.startup['ArtilleryDelivery-useTint'] then
    icons =
	{
      {
        icon = "__ArtilleryDelivery__/graphics/icons/empty-artillery-shell.png",
        tint = tint,
      },
    }
  else
    tint = {r = 1, g  = 0, b = 0, a = 1}
    icons =
	{
      {
        icon = "__ArtilleryDelivery__/graphics/icons/artillery-shell.png",
      },
      {
        icon = item.icon,
        scale = 0.5,
        shift = {
          4,
          -4
        }
      }
    }
  end
  
  ArtilleryShellItem(
    item.name,
    icons,
	"artillery-delivery-shells",
	"f[artillery-delivery-shells]-c[" .. item.name .. "]",
	"item-name." .. item.name
  )
  
  ArtilleryShellProjectile( item.name, tint )
  
  ArtilleryShellRecipe(
    item.name,
    icons,
	"artillery-delivery-shells",
	"f[artillery-delivery-shells]-c[" .. item.name .. "]",
	"item-name." .. item.name
  )
end

