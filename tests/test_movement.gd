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
	var before_friction: float = runner.ground_speed
	for i in range(12):
		runner.step(0.0, false, false, DT)
	_check(absf(runner.ground_speed) < absf(before_friction), "no input slows speed")

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
	for i in range(60):
		inertial.step(1.0, false, false, DT)
		reactive.step(1.0, false, false, DT)
	for i in range(8):
		inertial.step(0.0, false, false, DT)
		reactive.step(0.0, false, false, DT)
	_check(reactive.responsive_profile, "A responsive mode is active")
	_check(reactive.ground_speed < inertial.ground_speed, "A loses speed faster than B")
	reactive.set_responsive_profile(false)
	_check(not reactive.responsive_profile and reactive.feet.x == 130.0, "profile change resets trial")
	var finisher = Model.new()
	for i in range(1200):
		finisher.step(1.0, false, false, DT)
	_check(finisher.feet.x >= 2970.0, "normal route reaches finish without any glitch")
	if failures.is_empty():
		print("PASS movement_lab: %d invariants" % checks)
		quit(0)
	else:
		for failure in failures:
			push_error("FAIL: " + failure)
		quit(1)
