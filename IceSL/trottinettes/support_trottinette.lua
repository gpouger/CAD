-- how big to make the stand
standSize = 0.09

--pre-drilled screw holes
numberOfScrewHoles = 2

-- the diameter of the scooter wheel
wheelDiameter = 120
wheelRadius = wheelDiameter/ 2.0

-- how wide the wheel is
wheelWidth = 24

-- how curved the tyre tread is
wheelTreadCurvature = 0.4;

-- the smaller the number the snugger the tyre fits
wheelSupportCurvature = 1.0

-- the diameter of the axle ( or the width of the fork if its fatter)
axleDiameter = 25
axleRadius = axleDiameter/ 2.0
axleWidth = 60*10

-- minimum thickness
wallThickness = 3
tolerance = 0.5
screwDistanceFromCenter= 0.50 * wheelRadius

-- screw sizes
screwHeadDiameter = 10
screwThreadDiameter = 5

-- external sizes
maxX = 120
maxY = 135
maxZ = 100

function axle()
    s = ccylinder(axleRadius, axleWidth)
    s2 = translate(wheelDiameter, 0, 0) * ccylinder(axleRadius + tolerance, axleWidth)
    return rotate(0, 270, 0)*convex_hull(union(s, s2))
end

function wheel()
  wheel = scale(wheelTreadCurvature, wheelSupportCurvature, 1)*sphere(wheelRadius)
  cutout = ccube(wheelWidth + tolerance, 4 * wheelDiameter + tolerance, wheelDiameter + tolerance)
  return intersection(wheel, cutout)
end

function scooter()
  s = union(wheel(), axle())
  s = translate(0, 0, wheelRadius + wallThickness) * s
  return rotate(0, 0, 90)*s
end

function screwHole()
  h1 = translate(0, 0, 5)*cylinder(screwHeadDiameter/2, axleWidth)
  h2 = translate(0, 0, -tolerance)*cylinder(screwThreadDiameter/2, axleWidth)
  return union(h1, h2)
end

function screws()
  h = screwHole()
  s = {}
  if numberOfScrewHoles > 0 then
    for i = 0, 360, 360 / numberOfScrewHoles do
      table.insert(s, rotate(0, 0, i-90)*translate(screwDistanceFromCenter, 0, 0) * h)
    end
  end
  return union(s)
end

function flatBottom()
  c = ccube(wheelDiameter * 3)
  return translate(0, 0, wheelDiameter * 3 / -2) * c
end

function cocoonArea()
  edgeBuffer = 2 * 15;
  c = ccube(maxX - edgeBuffer, maxY - edgeBuffer, maxZ - edgeBuffer)
  return translate(0, 0, (maxZ - edgeBuffer)/2) * c
end


function fancyStand()
  shapes = {scale(4, 1, 1) * translate(0, 0, wheelRadius) * sphere(wheelRadius * standSize)}
  
  for i = 0, 360, 360 / 4 do
    table.insert(shapes, rotate(0, 0, i-90)*translate(wheelDiameter/3, 0, 0)*sphere(wheelRadius * standSize))
  end
  
  shape = convex_hull(union(shapes))
  return scale(1, 1.5, 1) * shape
end

function scooterStand()
  return intersection(cocoonArea(), difference({fancyStand(), flatBottom(), scooter(), screws()}))
end

function refreshComputedParameters()
  wheelRadius = wheelDiameter/ 2.0
  axleRadius = axleDiameter/ 2.0
  screwDistanceFromCenter= 0.65 * wheelRadius
  maxX = wheelDiameter
  maxY = wheelDiameter*1.125
  maxZ = wheelDiameter*0.8
end

-- parameters for the Oxelo Town3 (black/blue)
function SetParamsOxeloTown3Stand()
    standSize = 0.09
	wheelDiameter = 175
	wheelWidth = 28
	axleDiameter = 26
end

-- parameters for the Oxelo Play5 (grey/pink)
function SetParamsOxeloPlay5Stand()
    standSize = 0.12
	wheelDiameter = 125
	wheelWidth = 24
	axleDiameter = 30
end

-- parameters for the small Oxelo (grey/red)
function SetParamsOxeloKidStand()
    standSize = 0.09
	wheelDiameter = 120
	wheelWidth = 24
	axleDiameter = 24
end

SetParamsOxeloTown3Stand()
refreshComputedParameters()

emit(scooterStand())

set_setting_value('num_shells_0', 2)
set_setting_value('enable_different_top_bottom_covers_0', true)
set_setting_value('cover_thickness_top_mm_0', 0.9)
set_setting_value('cover_thickness_bottom_mm_0', 0.6)
set_setting_value('slicing_algorithm', 'Polygonal')