-- Custom artillery shells will automatically be created for anything listed here.
valid_artillery_items = 
{
  "raw-wood",
  "coal",
  "stone",
  "iron-ore",
  "copper-ore",
  "uranium-ore"
}

-- Items listed here will get artillery shells with a custom tint.
-- If not present, they will instead get a default red tint on the map,
-- and a vanilla artillery shell icon with the original item icon superimposed.
custom_tints =
{
  ["raw-wood"] = {r = 100, g = 38, b = 13, a = 255},
  ["coal"] = {r = 60, g = 60, b = 60, a = 255},
  ["stone"] = {r = 93, g = 88, b = 73, a = 255},
  ["iron-ore"] = {r = 40, g = 70, b = 100, a = 255},
  ["copper-ore"] = {r = 185, g = 74, b = 32, a = 255},
  ["uranium-ore"] = {r = 50, g = 100, b = 42, a = 255}
}