extends RefCounted
## Ten original traversal zones. This P1 heightfield is NOT a full 2D solid-wall solver.
## Data layout: section length 3100 px, terrain sampled as continuous segments;
## intentional gaps are separately excluded from the solid floor.
const SECTION_LENGTH: float = 3100.0
const SECTION_COUNT: int = 10
const START_X: float = 0.0
const END_X: float = 31000.0
const FALL_LIMIT: float = 1100.0
const STAGE_NAMES = ["Clairière","Collines vivantes","Terrasses suspendues","Grande dévalée","Ponts du vent","Hauts plateaux","Vallée des sauts","Jardins mécaniques","Longues crêtes","Dernier élan"]
const POINTS = [
	Vector2(0.0, 530.0),
	Vector2(360.0, 530.0),
	Vector2(740.0, 598.0),
	Vector2(1120.0, 470.0),
	Vector2(1570.0, 470.0),
	Vector2(1950.0, 575.0),
	Vector2(2380.0, 540.0),
	Vector2(2680.0, 510.0),
	Vector2(3100.0, 510.0),
	Vector2(3470.0, 570.0),
	Vector2(3880.0, 605.0),
	Vector2(4260.0, 480.0),
	Vector2(4640.0, 480.0),
	Vector2(5000.0, 590.0),
	Vector2(5410.0, 590.0),
	Vector2(5740.0, 445.0),
	Vector2(6200.0, 510.0),
	Vector2(6580.0, 570.0),
	Vector2(6890.0, 590.0),
	Vector2(7250.0, 420.0),
	Vector2(7720.0, 420.0),
	Vector2(8110.0, 560.0),
	Vector2(8500.0, 560.0),
	Vector2(8850.0, 525.0),
	Vector2(9300.0, 505.0),
	Vector2(9720.0, 530.0),
	Vector2(10260.0, 650.0),
	Vector2(10730.0, 650.0),
	Vector2(11110.0, 460.0),
	Vector2(11600.0, 460.0),
	Vector2(12080.0, 535.0),
	Vector2(12400.0, 520.0),
	Vector2(12820.0, 635.0),
	Vector2(13210.0, 635.0),
	Vector2(13680.0, 485.0),
	Vector2(14120.0, 485.0),
	Vector2(14590.0, 560.0),
	Vector2(15000.0, 560.0),
	Vector2(15500.0, 530.0),
	Vector2(16020.0, 530.0),
	Vector2(16430.0, 355.0),
	Vector2(16970.0, 355.0),
	Vector2(17410.0, 610.0),
	Vector2(17830.0, 580.0),
	Vector2(18230.0, 470.0),
	Vector2(18600.0, 510.0),
	Vector2(19000.0, 540.0),
	Vector2(19540.0, 660.0),
	Vector2(19950.0, 660.0),
	Vector2(20440.0, 460.0),
	Vector2(20900.0, 460.0),
	Vector2(21300.0, 550.0),
	Vector2(21700.0, 520.0),
	Vector2(22070.0, 590.0),
	Vector2(22460.0, 590.0),
	Vector2(22830.0, 435.0),
	Vector2(23210.0, 435.0),
	Vector2(23670.0, 610.0),
	Vector2(24120.0, 610.0),
	Vector2(24440.0, 490.0),
	Vector2(24800.0, 515.0),
	Vector2(25190.0, 550.0),
	Vector2(25760.0, 660.0),
	Vector2(26190.0, 660.0),
	Vector2(26590.0, 430.0),
	Vector2(27090.0, 430.0),
	Vector2(27510.0, 565.0),
	Vector2(27900.0, 525.0),
	Vector2(28340.0, 570.0),
	Vector2(28810.0, 630.0),
	Vector2(29270.0, 460.0),
	Vector2(29760.0, 460.0),
	Vector2(30250.0, 535.0),
	Vector2(30620.0, 535.0),
	Vector2(31000.0, 515.0),
]
## Open-bottom gaps: start/end X. The player must jump or use the upper path.
const GAPS = [
	Vector2(8150.0, 8300.0),
	Vector2(11600.0, 11765.0),
	Vector2(14700.0, 14875.0),
	Vector2(21050.0, 21230.0),
	Vector2(23250.0, 23425.0),
	Vector2(27140.0, 27330.0),
	Vector2(29400.0, 29565.0),
]
## One-way ledges: x, width, lift above sampled ground at their center.
## They can be landed on from above, but do not block the player from below/side.
const PLATFORM_SPECS = [
	Vector3(1050.0, 150.0, 72.0),
	Vector3(1710.0, 195.0, 82.0),
	Vector3(2320.0, 150.0, 95.0),
	Vector3(4150.0, 150.0, 80.0),
	Vector3(4810.0, 195.0, 82.0),
	Vector3(5420.0, 150.0, 95.0),
	Vector3(7250.0, 150.0, 88.0),
	Vector3(7910.0, 195.0, 82.0),
	Vector3(8520.0, 150.0, 95.0),
	Vector3(10350.0, 150.0, 72.0),
	Vector3(11010.0, 195.0, 82.0),
	Vector3(11620.0, 150.0, 95.0),
	Vector3(13450.0, 150.0, 80.0),
	Vector3(14110.0, 195.0, 82.0),
	Vector3(14720.0, 150.0, 95.0),
	Vector3(16550.0, 150.0, 88.0),
	Vector3(17210.0, 195.0, 82.0),
	Vector3(17820.0, 150.0, 95.0),
	Vector3(19650.0, 150.0, 72.0),
	Vector3(20310.0, 195.0, 82.0),
	Vector3(20920.0, 150.0, 95.0),
	Vector3(22750.0, 150.0, 80.0),
	Vector3(23410.0, 195.0, 82.0),
	Vector3(24020.0, 150.0, 95.0),
	Vector3(25850.0, 150.0, 88.0),
	Vector3(26510.0, 195.0, 82.0),
	Vector3(27120.0, 150.0, 95.0),
	Vector3(28950.0, 150.0, 72.0),
	Vector3(29610.0, 195.0, 82.0),
	Vector3(30220.0, 150.0, 95.0),
]
## Trails: start x, spacing, number, height above local ground.
const PICKUP_GROUPS = [
	Vector4(420.0, 68.0, 6.0, 40.0),
	Vector4(1380.0, 64.0, 7.0, 115.0),
	Vector4(2300.0, 63.0, 6.0, 42.0),
	Vector4(3520.0, 68.0, 6.0, 40.0),
	Vector4(4480.0, 64.0, 7.0, 115.0),
	Vector4(5400.0, 63.0, 6.0, 42.0),
	Vector4(6620.0, 68.0, 6.0, 40.0),
	Vector4(7580.0, 64.0, 7.0, 115.0),
	Vector4(8500.0, 63.0, 6.0, 42.0),
	Vector4(9720.0, 68.0, 6.0, 40.0),
	Vector4(10680.0, 64.0, 7.0, 115.0),
	Vector4(11600.0, 63.0, 6.0, 42.0),
	Vector4(12820.0, 68.0, 6.0, 40.0),
	Vector4(13780.0, 64.0, 7.0, 115.0),
	Vector4(14700.0, 63.0, 6.0, 42.0),
	Vector4(15920.0, 68.0, 6.0, 40.0),
	Vector4(16880.0, 64.0, 7.0, 115.0),
	Vector4(17800.0, 63.0, 6.0, 42.0),
	Vector4(19020.0, 68.0, 6.0, 40.0),
	Vector4(19980.0, 64.0, 7.0, 115.0),
	Vector4(20900.0, 63.0, 6.0, 42.0),
	Vector4(22120.0, 68.0, 6.0, 40.0),
	Vector4(23080.0, 64.0, 7.0, 115.0),
	Vector4(24000.0, 63.0, 6.0, 42.0),
	Vector4(25220.0, 68.0, 6.0, 40.0),
	Vector4(26180.0, 64.0, 7.0, 115.0),
	Vector4(27100.0, 63.0, 6.0, 42.0),
	Vector4(28320.0, 68.0, 6.0, 40.0),
	Vector4(29280.0, 64.0, 7.0, 115.0),
	Vector4(30200.0, 63.0, 6.0, 42.0),
]
const SPRINGS = [4800.0, 13950.0, 20200.0, 28630.0]

static func section_index(x: float) -> int:
	return clampi(int(floor(x / SECTION_LENGTH)), 0, SECTION_COUNT - 1)

static func height_at(x: float) -> float:
	var clamped_x: float = clampf(x, START_X, END_X)
	for i in range(POINTS.size() - 1):
		var a: Vector2 = POINTS[i]
		var b: Vector2 = POINTS[i + 1]
		if clamped_x <= b.x:
			return lerpf(a.y, b.y, (clamped_x - a.x) / (b.x - a.x))
	return POINTS[-1].y

static func slope_at(x: float) -> float:
	var clamped_x: float = clampf(x, START_X, END_X - 0.01)
	for i in range(POINTS.size() - 1):
		var a: Vector2 = POINTS[i]
		var b: Vector2 = POINTS[i + 1]
		if clamped_x < b.x:
			return (b.y - a.y) / (b.x - a.x)
	return 0.0

static func has_ground_at(x: float) -> bool:
	for hole in GAPS:
		if x >= hole.x and x < hole.y:
			return false
	return x >= START_X and x <= END_X

static func platform_rect(index: int) -> Rect2:
	var spec: Vector3 = PLATFORM_SPECS[index]
	return Rect2(spec.x, height_at(spec.x + spec.y * 0.5) - spec.z, spec.y, 14.0)

static func collectible_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for group in PICKUP_GROUPS:
		var trail: Vector4 = group
		for i in range(int(trail.z)):
			var x: float = trail.x + float(i) * trail.y
			var arch: float = sin(float(i) / maxf(1.0, trail.z - 1.0) * PI) * 32.0
			positions.append(Vector2(x, height_at(x) - trail.w - arch))
	return positions

static func next_gap_ahead(x: float) -> Vector2:
	for gap in GAPS:
		if gap.y > x:
			return gap
	return Vector2(-1.0, -1.0)
