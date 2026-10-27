extends SceneTree
## Run: godot --headless --path . --script res://tests/test_movement.gd
const Course = preload("res://scripts/course_profile.gd")
const Model = preload("res://scripts/movement_model.gd")
const DT: float = 1.0 / 60.0
var failures: Array[String] = []
var checks: int = 0

func _initialize() -> void:
	call_deferred("_run_tests")

func _check(condition: bool, reason: String) -> void:
	checks += 1
	if not condition:
		failures.append(reason)

func _run_tests() -> void:
	var runner = Model.new()
	_check(runner.grounded, "spawn must be grounded")
	_check(is_equal_approx(runner.feet.y, Course.height_at(runner.feet.x)), "spawn feet on ground")
	for i in range(50):
		runner.step(1.0, false, false, DT)
	_check(runner.ground_speed > 100.0, "forward input builds speed")
	var before_brake: float = runner.ground_speed
	for i in range(8):
		runner.step(-1.0, false, false, DT)
	_check(runner.ground_speed < before_brake, "reverse input brakes")
	# Coasting on a slope can ACCELERATE under gravity. Check friction on flat only.
	var rolling = Model.new()
	rolling.feet.x = 1300.0
	rolling.feet.y = Course.height_at(1300.0)
	rolling.ground_speed = 250.0
	var before_friction: float = rolling.ground_speed
	for i in range(12):
		rolling.step(0.0, false, false, DT)
	_check(absf(rolling.ground_speed) < absf(before_friction), "no input slows speed on flat ground")

	var held = Model.new()
	var tapped = Model.new()
	for i in range(18):
		held.step(0.0, i == 0, true, DT)
		tapped.step(0.0, i == 0, false, DT)
	_check(not held.grounded, "held jump leaves floor")
	_check(held.feet.y < tapped.feet.y, "held jump goes higher than tap")

	var downhill = Model.new()
	downhill.feet.x = 500.0
	downhill.feet.y = Course.height_at(500.0)
	downhill.step(0.0, false, false, DT)
	_check(downhill.ground_speed > 0.0, "downhill slope builds speed to right")

	var a = Model.new()
	var b = Model.new()
	for i in range(480):
		var input_x: float = 1.0 if i < 230 else (-1.0 if i < 280 else 0.0)
		var pressed: bool = i == 50 or i == 310
		var hold: bool = (i >= 50 and i < 66) or (i >= 310 and i < 323)
		a.step(input_x, pressed, hold, DT)
		b.step(input_x, pressed, hold, DT)
	_check(a.feet.distance_to(b.feet) < 0.00001, "same inputs produce same position in same runtime")
	_check(is_equal_approx(a.ground_speed, b.ground_speed), "same inputs produce same speed")
	_check(a.grounded == b.grounded, "same inputs produce same contact")
	runner.reset()
	_check(is_equal_approx(runner.ground_speed, 0.0), "reset clears speed")
	_check(is_equal_approx(runner.feet.x, 130.0), "reset restores spawn")
	var inertial = Model.new()
	var reactive = Model.new()
	reactive.set_responsive_profile(true)
	for model in [inertial, reactive]:
		model.feet.x = 1300.0
		model.feet.y = Course.height_at(1300.0)
		model.ground_speed = 300.0
	for i in range(8):
		inertial.step(0.0, false, false, DT)
		reactive.step(0.0, false, false, DT)
	_check(reactive.responsive_profile, "A responsive mode is active")
	_check(reactive.ground_speed < inertial.ground_speed, "A loses speed faster than B on the same flat stretch")
	reactive.set_responsive_profile(false)
	_check(not reactive.responsive_profile and reactive.feet.x == 130.0, "profile change resets trial")
	var finisher = Model.new()
	for i in range(1200):
		finisher.step(1.0, false, false, DT)
	_check(finisher.feet.x >= 2970.0, "normal route reaches finish without any glitch")

	# Control the experiment: identical speed and held-right input on different grades.
	var flat = Model.new()
	var descending = Model.new()
	var climbing = Model.new()
	for candidate in [flat, descending, climbing]:
		candidate.ground_speed = 420.0
	flat.feet = Vector2(1400.0, Course.height_at(1400.0))
	descending.feet = Vector2(400.0, Course.height_at(400.0))
	climbing.feet = Vector2(850.0, Course.height_at(850.0))
	for i in range(15):
		flat.step(1.0, false, false, DT)
		descending.step(1.0, false, false, DT)
		climbing.step(1.0, false, false, DT)
	_check(descending.ground_speed > flat.ground_speed + 25.0, "downhill is faster than flat with identical input")
	_check(climbing.ground_speed < flat.ground_speed - 45.0, "uphill brakes despite holding right")
	_check(descending.ground_speed > Model.GROUND_SPEED_CAP, "downhill can exceed normal running cap")
	_check(climbing.ground_speed > 0.0, "ordinary route can still climb uphill")
	var kept = Model.new()
	kept.feet = Vector2(1210.0, Course.height_at(1210.0))
	kept.ground_speed = Model.GROUND_SPEED_CAP + 100.0
	kept.step(1.0, false, false, DT)
	_check(kept.ground_speed > Model.GROUND_SPEED_CAP, "flat stretch retains terrain-earned overspeed")
	_check(kept.ground_speed < Model.GROUND_SPEED_CAP + 100.0, "terrain-earned overspeed decays gently")
	var descent_from_other_side = Model.new()
	descent_from_other_side.feet = Vector2(980.0, Course.height_at(980.0))
	descent_from_other_side.ground_speed = -250.0
	descent_from_other_side.step(0.0, false, false, DT)
	_check(descent_from_other_side.ground_speed < -250.0, "gravity accelerates descending toward the left too")
	# A slope-generated run must stay fast even when jumping, then landing.
	var flight = Model.new()
	flight.feet = Vector2(1300.0, Course.height_at(1300.0))
	flight.ground_speed = 680.0
	flight.step(1.0, true, true, DT)
	_check(not flight.grounded, "overspeed launch lifts off")
	_check(flight.air_velocity.x > Model.AIR_SPEED_CAP, "jump preserves horizontal speed above air steering cap")
	var airborne_before: float = flight.air_velocity.x
	flight.step(1.0, false, true, DT)
	_check(flight.air_velocity.x >= airborne_before - 0.01, "steering does not clamp exceptional momentum")
	var landing = Model.new()
	landing.feet = Vector2(1300.0, Course.height_at(1300.0) - 1.0)
	landing.grounded = false
	landing.air_velocity = Vector2(670.0, 200.0)
	landing.step(1.0, false, false, DT)
	_check(landing.grounded, "high speed runner lands on flat terrain")
	_check(landing.ground_speed > Model.GROUND_SPEED_CAP, "landing retains exceptional horizontal speed")
	if failures.is_empty():
		print("PASS movement_lab: %d invariants" % checks)
		quit(0)
	else:
		for failure in failures:
			push_error("FAIL: " + failure)
		quit(1)
