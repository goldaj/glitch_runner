extends RefCounted
## Minimal movement experiment; collision only with a sampled floor. NOT G1-ready.
const Course = preload("res://scripts/course_profile.gd")
const GROUND_ACCEL: float = 850.0
const GROUND_BRAKE: float = 1800.0
# B: low rolling friction allows terrain to build and retain momentum.
const ROLL_FRICTION: float = 85.0
const SLOPE_FORCE: float = 1100.0
# A cap only on acceleration from input; terrain is allowed to exceed it.
const GROUND_SPEED_CAP: float = 420.0
const OVERSPEED_DRAG: float = 0.45
const GROUND_SAFETY_CAP: float = 900.0
const AIR_ACCEL: float = 420.0
const AIR_SPEED_CAP: float = 550.0
const JUMP_SPEED: float = 495.0
const GRAVITY: float = 1250.0

var feet: Vector2 = Vector2.ZERO
var ground_speed: float = 0.0
var air_velocity: Vector2 = Vector2.ZERO
var grounded: bool = true
var responsive_profile: bool = false
var platform_index: int = -1
var dead: bool = false
var spring_armed: bool = true
var bounce_flight: bool = false

func respawn_at(x: float) -> void:
	var safe_x: float = clampf(x, 30.0, Course.END_X - 30.0)
	if not Course.has_ground_at(safe_x):
		safe_x = maxf(30.0, Course.next_gap_ahead(safe_x).y + 30.0)
	feet = Vector2(safe_x, Course.height_at(safe_x))
	ground_speed = 0.0
	air_velocity = Vector2.ZERO
	grounded = true
	platform_index = -1
	dead = false
	spring_armed = true
	bounce_flight = false


func set_responsive_profile(is_responsive: bool) -> void:
	responsive_profile = is_responsive
	reset()

func _init() -> void:
	reset()

func reset() -> void:
	respawn_at(130.0)

func step(axis: float, jump_pressed: bool, jump_held: bool, dt: float) -> void:
	if dt <= 0.0 or dead:
		return
	axis = clampf(axis, -1.0, 1.0)
	if grounded:
		var slope: float = 0.0 if platform_index >= 0 else Course.slope_at(feet.x)
		if absf(axis) > 0.05:
			var force: float = GROUND_ACCEL * (2.0 if responsive_profile else 1.0)
			if ground_speed * axis < 0.0:
				# Opposite input acts as a deliberate brake, even above normal running speed.
				force = GROUND_BRAKE * (1.5 if responsive_profile else 1.0)
			else:
				# Only player input fades out at the normal running speed.
				# Do NOT clamp the resulting speed here: this would destroy slope momentum.
				var input_headroom: float = clampf((GROUND_SPEED_CAP - ground_speed * axis) / GROUND_SPEED_CAP, 0.0, 1.0)
				force *= input_headroom
			ground_speed += axis * force * dt
		else:
			ground_speed = move_toward(ground_speed, 0.0, ROLL_FRICTION * (7.0 if responsive_profile else 1.0) * dt)
		# +slope moves down in screen coordinates; gravity pulls the runner right on
		# a downward-right slope, left on an upward-right slope. Works both directions.
		var slope_gravity: float = SLOPE_FORCE * (0.4 if responsive_profile else 1.0) * slope / sqrt(1.0 + slope * slope)
		ground_speed += slope_gravity * dt
		# Terrain-earned overspeed survives crests and flat ground, but gently fades.
		# Separate high emergency bound is only a protection for this simplistic P1 floor.
		var surplus: float = maxf(0.0, absf(ground_speed) - GROUND_SPEED_CAP)
		if surplus > 0.0:
			ground_speed = move_toward(ground_speed, 0.0, surplus * OVERSPEED_DRAG * dt)
		ground_speed = clampf(ground_speed, -GROUND_SAFETY_CAP, GROUND_SAFETY_CAP)
		if jump_pressed:
			bounce_flight = false
			grounded = false
			platform_index = -1
			air_velocity = Vector2(ground_speed, -JUMP_SPEED + minf(0.0, ground_speed * slope * 0.16))
			feet.y -= 0.25
		elif platform_index < 0:
			var near_any_spring: bool = false
			for spring_x in Course.SPRINGS:
				var distance: float = absf(feet.x - spring_x)
				if distance < 28.0:
					near_any_spring = true
				if distance <= 12.0 and spring_armed:
					grounded = false
					air_velocity = Vector2(ground_speed, -JUMP_SPEED * 1.35)
					feet.y -= 0.25
					bounce_flight = true
					spring_armed = false
					break
			if not near_any_spring:
				spring_armed = true
	if grounded:
		feet.x = clampf(feet.x + ground_speed * dt, Course.START_X, Course.END_X)
		if platform_index >= 0:
			var ledge: Rect2 = Course.platform_rect(platform_index)
			if feet.x >= ledge.position.x and feet.x <= ledge.end.x:
				feet.y = ledge.position.y
			else:
				grounded = false
				platform_index = -1
				air_velocity = Vector2(ground_speed, 0.0)
		elif Course.has_ground_at(feet.x):
			feet.y = Course.height_at(feet.x)
		else:
			grounded = false
			air_velocity = Vector2(ground_speed, 0.0)
	else:
		# Air steering fades near the normal air speed, but does NOT erase
		# momentum that a slope (or later a legitimate glitch) gave us.
		var air_steer: float = AIR_ACCEL
		if air_velocity.x * axis >= 0.0:
			var air_headroom: float = clampf((AIR_SPEED_CAP - air_velocity.x * axis) / AIR_SPEED_CAP, 0.0, 1.0)
			air_steer *= air_headroom
		air_velocity.x = clampf(air_velocity.x + axis * air_steer * dt, -GROUND_SAFETY_CAP, GROUND_SAFETY_CAP)
		if not jump_held and not bounce_flight and air_velocity.y < -155.0:
			air_velocity.y = -155.0
		air_velocity.y += GRAVITY * dt
		var previous_feet: Vector2 = feet
		feet += air_velocity * dt
		feet.x = clampf(feet.x, Course.START_X, Course.END_X)
		# Sweep along the actual motion segment, breaking it at terrain vertices
		# and at genuine pits. The old test compared the PREVIOUS y with the
		# NEXT ground y, which missed a moving player landing on a rising slope.
		var floor_hit: Dictionary = Course.first_ground_contact(previous_feet, feet)
		var first_fraction: float = INF
		var landed_platform: int = -1
		var ground_contact: Vector2 = Vector2.ZERO
		if not floor_hit.is_empty():
			first_fraction = floor_hit["fraction"]
			ground_contact = floor_hit["position"]
		if air_velocity.y >= 0.0 and feet.y > previous_feet.y:
			# One-way ledges only catch a descending player. Compare impact
			# fractions, not only surface Y at the final X, to respect first contact.
			for i in range(Course.PLATFORM_SPECS.size()):
				var ledge: Rect2 = Course.platform_rect(i)
				if previous_feet.y <= ledge.position.y and feet.y >= ledge.position.y:
					var t: float = (ledge.position.y - previous_feet.y) / (feet.y - previous_feet.y)
					var impact_x: float = lerpf(previous_feet.x, feet.x, t)
					if impact_x >= ledge.position.x + 8.0 and impact_x <= ledge.end.x - 8.0:
						if t < first_fraction:
							first_fraction = t
							ground_contact = Vector2(impact_x, ledge.position.y)
							landed_platform = i
		if first_fraction < INF:
			feet = ground_contact
			grounded = true
			platform_index = landed_platform
			ground_speed = air_velocity.x * 0.96
			air_velocity = Vector2.ZERO
			bounce_flight = false
		if feet.y > Course.FALL_LIMIT:
			dead = true

func speed() -> float:
	if grounded:
		return absf(ground_speed)
	return air_velocity.length()
