extends SceneTree
## Reproducer for #8: fast moving airborne player enters an uphill solid segment.
## "y" increases down the screen. No designed gap is involved in these tests.
const Course = preload("res://scripts/course_profile.gd")
const Model = preload("res://scripts/movement_model.gd")
const DT: float = 1.0 / 60.0
var failures: Array[String] = []
var checks: int = 0

func _initialize() -> void:
	call_deferred("_run")

func _expect(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)

func _airborne(x: float, right_speed: float, vertical_speed: float, margin: float) -> RefCounted:
	var model = Model.new()
	model.feet = Vector2(x, Course.height_at(x) - margin)
	model.grounded = false
	model.air_velocity = Vector2(right_speed, vertical_speed)
	return model

func _run() -> void:
	# x=1000 is a regular upward-right slope, not a pit or special tile.
	var hit = _airborne(1000.0, 900.0, 40.0, 3.0)
	_expect(Course.has_ground_at(1000.0) and Course.has_ground_at(1015.0), "repro area is fully solid")
	hit.step(1.0, false, true, DT)
	_expect(hit.grounded, "fast diagonal touchdown on an uphill slope must register")
	_expect(hit.feet.y <= Course.height_at(hit.feet.x) + 0.01, "runner must never pass below visible solid terrain")

	# On a steep uphill-right slope, terrain may catch the player even while rising.
	var rising = _airborne(1000.0, 900.0, -75.0, 3.0)
	rising.step(1.0, false, true, DT)
	_expect(rising.grounded, "solid slope stops diagonal upward clipping, not only falling velocity")

	# Other direction: descending terrain to the right means rising terrain to the left.
	var reverse = _airborne(17220.0, -900.0, 45.0, 3.0)
	reverse.step(-1.0, false, true, DT)
	_expect(reverse.grounded, "left-moving fast diagonal contact on uphill-left slope")

	# Seam on a continuous surface: flying over a vertex must not fall through it.
	var crest = _airborne(1100.0, 900.0, 40.0, 2.0)
	crest.step(1.0, false, true, DT)
	_expect(crest.grounded and crest.feet.y <= Course.height_at(crest.feet.x) + 0.01, "junction between slope and flat cannot tunnel")

	# A real gap remains empty. Neither a physics tolerance nor the sweep can bridge it.
	var gap: Vector2 = Course.GAPS[0]
	var fall = Model.new()
	var hole_mid: float = (gap.x + gap.y) / 2.0
	fall.feet = Vector2(hole_mid, Course.height_at(gap.x) - 6.0)
	fall.grounded = false
	fall.air_velocity = Vector2(0.0, 125.0)
	for i in range(100):
		fall.step(0.0, false, true, DT)
		if fall.dead:
			break
	_expect(fall.dead, "genuine gap still causes a fall")

	# Emerging below the far lip of a genuine gap must not teleport onto the surface.
	var far_edge = Model.new()
	far_edge.feet = Vector2(gap.y - 5.0, Course.height_at(gap.y) + 60.0)
	far_edge.grounded = false
	far_edge.air_velocity = Vector2(880.0, 180.0)
	far_edge.step(1.0, false, true, DT)
	_expect(not far_edge.grounded and far_edge.feet.y > Course.height_at(far_edge.feet.x), "pit exit from below is not an automatic rescue")

	if failures.is_empty():
		print("PASS ground_contact: %d checks" % checks)
		quit(0)
	else:
		for msg in failures:
			push_error("FAIL ground_contact: " + msg)
		quit(1)
