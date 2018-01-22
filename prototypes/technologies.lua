data:extend(
{
  {
    type = "technology",
    name = "artillery-delivery",
    icon = "__ArtilleryDelivery__/graphics/icons/delivery-artillery.png",
    icon_size = 128,
    prerequisites =
    {
      "artillery",
      "logistics-2"
    },
    effects =
    {
      {
	    type = "unlock-recipe",
		recipe = "artillery-delivery-turret"
      },
      {
	    type = "unlock-recipe",
		recipe = "artillery-delivery-target"
      }
    },
    unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
      },
      time = 15
    },
    order = "a-f-c",
  }
}
)