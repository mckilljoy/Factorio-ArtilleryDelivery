--[[
data:extend(
{
  {
    type = "bool-setting",
    name = "artillery-damage",
    setting_type = "startup",
    default_value = false,
    order = "b",
  }
}
)

--]]

data:extend(
    {
        { -- added useTint as option. With a lot of ores it is harder to distinguise between different shells
            type = "bool-setting",
            name = "ArtilleryDelivery-useTint",
            setting_type = "startup",
            default_value = true,
            order = "a"
        }
    }
)