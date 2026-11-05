-- Motorbike (architecture §7.1): the car profile with motorbike speeds in
-- km/h. The speeds are placeholders until the ETA is tuned in the field:
-- slower than a car on fast roads, faster in town streets.
local car = require('car')

local speeds = {
  motorway = 80,
  motorway_link = 40,
  trunk = 75,
  trunk_link = 40,
  primary = 60,
  primary_link = 30,
  secondary = 50,
  secondary_link = 25,
  tertiary = 40,
  tertiary_link = 20,
  unclassified = 30,
  residential = 30,
  living_street = 15,
  service = 20,
}

function setup()
  local profile = car.setup()
  for highway, speed in pairs(speeds) do
    profile.speeds.highway[highway] = speed
  end
  return profile
end

return {
  setup = setup,
  process_way = car.process_way,
  process_node = car.process_node,
  process_turn = car.process_turn,
}
