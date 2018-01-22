
local artillery_proto = table.deepcopy(data.raw["recipe"]["artillery-turret"])
artillery_proto.name = "artillery-delivery-turret"
artillery_proto.icon = "__ArtilleryDelivery__/graphics/icons/artillery-turret.png"
artillery_proto.icon_size = 32
artillery_proto.result = "artillery-delivery-turret"
artillery_proto.subgroup = "artillery-delivery"
artillery_proto.order = "f[artillery-delivery]-a"

data:extend({artillery_proto})