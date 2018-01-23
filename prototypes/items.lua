
local artillery_proto = table.deepcopy(data.raw["item"]["artillery-turret"])
artillery_proto.name = "artillery-delivery-turret"
artillery_proto.icon = "__ArtilleryDelivery__/graphics/icons/artillery-turret.png"
artillery_proto.icon_size = 32
artillery_proto.place_result = "artillery-delivery-turret"
artillery_proto.group = "artillery-delivery"
artillery_proto.group = "artillery-delivery-turrets"
artillery_proto.order = "f[artillery-delivery]-a"

data:extend({artillery_proto})