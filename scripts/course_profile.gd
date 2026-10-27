extends RefCounted
## P1-only terrain: piecewise-linear ground height (NOT general 2D collision).
const START_X: float = 0.0
const END_X: float = 3100.0
const POINTS = [
	Vector2(0.0, 530.0),
	Vector2(300.0, 530.0),
	Vector2(750.0, 620.0),
	Vector2(1100.0, 370.0),
	Vector2(1520.0, 370.0),
	Vector2(2050.0, 545.0),
	Vector2(2420.0, 545.0),
	Vector2(2650.0, 420.0),
	Vector2(3100.0, 420.0)
]

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
