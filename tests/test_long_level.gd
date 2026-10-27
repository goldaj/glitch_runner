extends SceneTree
## Extended P1 level tests: geometry, safe platforms, gaps, bounce pads and normal traversal.
const Course = preload("res://scripts/course_profile.gd")
const Model = preload("res://scripts/movement_model.gd")
const DT: float = 1.0 / 60.0
var failures: Array[String] = []
var checks: int = 0

func _initialize() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)

func _run() -> void:
	_check(is_equal_approx(Course.END_X, 31000.0), "level is 10x previous 3100 px width")
	_check(Course.SECTION_COUNT == 10, "ten named environments")
	_check(Course.STAGE_NAMES.size() == 10, "one name per environment")
	_check(Course.POINTS[0].x == 0.0, "terrain starts at x0")
	_check(Course.POINTS[-1].x == Course.END_X, "terrain reaches finish")
	_check(Course.GAPS.size() >= 5, "jump challenges authored")
	_check(Course.PLATFORM_SPECS.size() >= 20, "upper paths authored")
	_check(Course.SPRINGS.size() >= 3, "optional bouncy obstacles exist")
	var total_collectibles: Array[Vector2] = Course.collectible_positions()
	_check(total_collectibles.size() >= 150, "optional collectible trails throughout level")
	for i in range(1, Course.POINTS.size()):
		var a: Vector2 = Course.POINTS[i - 1]
		var b: Vector2 = Course.POINTS[i]
		_check(b.x > a.x, "terrain x strictly ascending at vertex %d" % i)
		_check(absf((b.y - a.y) / (b.x - a.x)) < 0.8, "terrain traversable slope at vertex %d" % i)
	for section in range(Course.SECTION_COUNT):
		var spawn: float = float(section) * Course.SECTION_LENGTH + 130.0
		_check(Course.has_ground_at(spawn), "safe checkpoint spawn for section %d" % section)
		_check(Course.section_index(spawn) == section, "stable zone indexing %d" % section)
	for gap in Course.GAPS:
		_check(gap.y - gap.x <= 225.0, "pit is jumpable in principle")
		_check(Course.has_ground_at(gap.x - 10.0), "ground at gap approach")
		_check(not Course.has_ground_at((gap.x + gap.y) / 2.0), "no ground in gap")
		_check(Course.has_ground_at(gap.y + 10.0), "ground after gap")
	for i in range(Course.PLATFORM_SPECS.size()):
		var p: Rect2 = Course.platform_rect(i)
		var mid: float = p.position.x + p.size.x * 0.5
		_check(p.position.y + 20.0 < Course.height_at(mid), "ledge is above ground %d" % i)
		_check(p.position.x >= 0.0 and p.end.x <= Course.END_X, "ledge in bounds %d" % i)
	for pos in total_collectibles:
		_check(pos.x >= 0.0 and pos.x <= Course.END_X, "collectible inside world")

	var high_ledge: Rect2 = Course.platform_rect(0)
	var pilot = Model.new()
	pilot.feet = Vector2(high_ledge.position.x + high_ledge.size.x * 0.5, high_ledge.position.y - 14.0)
	pilot.grounded = false
	pilot.air_velocity = Vector2(0.0, 235.0)
	for j in range(12):
		pilot.step(0.0, false, false, DT)
	_check(pilot.grounded and pilot.platform_index == 0, "landing from above on a one-way ledge")
	_check(absf(pilot.feet.y - high_ledge.position.y) < 1.0, "ledge supports feet at exact upper edge")
	pilot.step(0.0, true, true, DT)
	_check(not pilot.grounded and pilot.platform_index == -1, "jumping off a ledge clears contact")

	var spring = Model.new()
	var spring_x: float = Course.SPRINGS[0]
	spring.feet = Vector2(spring_x, Course.height_at(spring_x))
	spring.ground_speed = 0.0
	spring.step(0.0, false, false, DT)
	_check(not spring.grounded and spring.air_velocity.y < -Model.JUMP_SPEED, "bounce surface launches without consuming jump button")

	var fall = Model.new()
	fall.feet = Vector2((Course.GAPS[0].x + Course.GAPS[0].y) * 0.5, Course.height_at(Course.GAPS[0].x) - 8.0)
	fall.grounded = false
	fall.air_velocity = Vector2.ZERO
	for i in range(120):
		fall.step(0.0, false, false, DT)
		if fall.dead:
			break
	_check(fall.dead, "falling into a real gap marks death")
	fall.respawn_at(3230.0)
	_check(fall.grounded and not fall.dead and fall.ground_speed == 0.0, "safe checkpoint restores movement")

	# A normal held-jump must bridge the first gap, without any glitch or special ability.
	var jumper = Model.new()
	var gap: Vector2 = Course.GAPS[0]
	jumper.feet = Vector2(gap.x - 125.0, Course.height_at(gap.x - 125.0))
	jumper.ground_speed = 425.0
	for i in range(68):
		jumper.step(1.0, i == 0, true, DT)
		if jumper.dead:
			break
	_check(not jumper.dead and jumper.feet.x > gap.y + 15.0, "normal jump can cross the first gap")

	if failures.is_empty():
		print("PASS long_level: %d invariants, %d collectibles and %d zones" % [checks, total_collectibles.size(), Course.SECTION_COUNT])
		quit(0)
	else:
		for failure in failures:
			push_error("FAIL long_level: " + failure)
		quit(1)
