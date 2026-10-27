extends RefCounted
## Minimal movement experiment; collision only with a sampled floor. NOT G1-ready.
const Course = preload("res://scripts/course_profile.gd")
const GROUND_ACCEL: float = 850.0
const GROUND_BRAKE: float = 1800.0
const ROLL_FRICTION: float = 320.0
const SLOPE_FORCE: float = 520.0
const GROUND_SPEED_CAP: float = 420.0
const AIR_ACCEL: float = 420.0
const AIR_SPEED_CAP: float = 550.0
const JUMP_SPEED: float = 495.0
const GRAVITY: float = 1250.0

var feet: Vector2 = Vector2.ZERO
var ground_speed: float = 0.0
var air_velocity: Vector2 = Vector2.ZERO
var grounded: bool = true

func _init() -> void:
	reset()

func reset() -> void:
	feet = Vector2(130.0, Course.height_at(130.0))
	ground_speed = 0.0
	air_velocity = Vector2.ZERO
	grounded = true

func step(axis: float, jump_pressed: bool, jump_held: bool, dt: float) -> void:
	if dt <= 0.0:
		return
	axis = clampf(axis, -1.0, 1.0)
	if grounded:
		var slope: float = Course.slope_at(feet.x)
		if absf(axis) > 0.05:
			var force: float = GROUND_ACCEL
			if ground_speed * axis < 0.0:
				force = GROUND_BRAKE
			ground_speed += axis * force * dt
		else:
			ground_speed = move_toward(ground_speed, 0.0, ROLL_FRICTION * dt)
		ground_speed += SLOPE_FORCE * slope / sqrt(1.0 + slope * slope) * dt
		ground_speed = clampf(ground_speed, -GROUND_SPEED_CAP, GROUND_SPEED_CAP)
		if jump_pressed:
			grounded = false
			air_velocity = Vector2(ground_speed, -JUMP_SPEED + minf(0.0, ground_speed * slope * 0.16))
			feet.y -= 0.25
	if grounded:
		feet.x = clampf(feet.x + ground_speed * dt, Course.START_X, Course.END_X)
		feet.y = Course.height_at(feet.x)
	else:
		air_velocity.x = clampf(air_velocity.x + axis * AIR_ACCEL * dt, -AIR_SPEED_CAP, AIR_SPEED_CAP)
		if not jump_held and air_velocity.y < -155.0:
			air_velocity.y = -155.0
		air_velocity.y += GRAVITY * dt
		feet += air_velocity * dt
		feet.x = clampf(feet.x, Course.START_X, Course.END_X)
		var ground_y: float = Course.height_at(feet.x)
		if air_velocity.y >= 0.0 and feet.y >= ground_y:
			feet.y = ground_y
			grounded = true
			ground_speed = air_velocity.x * 0.96
			air_velocity = Vector2.ZERO

func speed() -> float:
	if grounded:
		return absf(ground_speed)
	return air_velocity.length()
