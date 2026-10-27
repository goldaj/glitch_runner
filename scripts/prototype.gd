extends Node2D
## Long-form movement level (10 x P1 length). Original silhouettes, no enemy or glitch.
const Course = preload("res://scripts/course_profile.gd")
const MovementModel = preload("res://scripts/movement_model.gd")
const FINISH_X: float = Course.END_X - 125.0
const VIEW_HALF: float = 920.0
const ZONE_COLORS = [
	Color("#8cd3cc"), Color("#a9d9c3"), Color("#b4d7e9"), Color("#9fc7ca"),
	Color("#f0cfb3"), Color("#afc4b6"), Color("#97d4dd"), Color("#bfd8dc"),
	Color("#ebc7ac"), Color("#b6c7e3")
]
var runner = MovementModel.new()
var ticks: int = 0
var finished: bool = false
var reset_held: bool = false
var profile_one_held: bool = false
var profile_two_held: bool = false
var jumps: int = 0
var max_run_speed: float = 0.0
var checkpoint_index: int = 0
var restarts: int = 0
var pickups: Array[Vector2] = []
var collected: Dictionary = {}
var follow_camera: Camera2D
var hud: Label

func _ready() -> void:
	pickups = Course.collectible_positions()
	follow_camera = Camera2D.new()
	add_child(follow_camera)
	follow_camera.position = Vector2(runner.feet.x, 380.0)
	follow_camera.make_current()
	var layer: CanvasLayer = CanvasLayer.new()
	add_child(layer)
	var bg: ColorRect = ColorRect.new()
	bg.position = Vector2(12.0, 12.0)
	bg.size = Vector2(1015.0, 145.0)
	bg.color = Color(0.04, 0.12, 0.17, 0.82)
	layer.add_child(bg)
	hud = Label.new()
	hud.position = Vector2(25.0, 20.0)
	hud.add_theme_font_size_override("font_size", 19)
	layer.add_child(hud)
	_update_hud()

func _physics_process(delta: float) -> void:
	var one: bool = Input.is_key_pressed(KEY_1)
	var two: bool = Input.is_key_pressed(KEY_2)
	if one and not profile_one_held:
		_select_profile(true)
	if two and not profile_two_held:
		_select_profile(false)
	profile_one_held = one
	profile_two_held = two

	var resetting: bool = Input.is_key_pressed(KEY_R)
	if resetting and not reset_held:
		var full_reset: bool = Input.is_key_pressed(KEY_SHIFT)
		_restart(full_reset)
	reset_held = resetting

	if not finished:
		var axis: float = Input.get_axis("ui_left", "ui_right")
		var jump_down: bool = Input.is_action_just_pressed("ui_accept")
		var jump_held: bool = Input.is_action_pressed("ui_accept")
		if jump_down and runner.grounded:
			jumps += 1
		runner.step(axis, jump_down, jump_held, delta)
		if runner.dead:
			_restart(false)
		else:
			var vx: float = runner.ground_speed if runner.grounded else runner.air_velocity.x
			max_run_speed = maxf(max_run_speed, absf(vx))
			ticks += 1
			_collect_nearby()
			var next_checkpoint: int = checkpoint_index + 1
			if next_checkpoint < Course.SECTION_COUNT and runner.feet.x >= float(next_checkpoint) * Course.SECTION_LENGTH + 120.0:
				checkpoint_index = next_checkpoint
			if runner.feet.x >= FINISH_X:
				finished = true

	var horizontal_speed: float = runner.ground_speed if runner.grounded else runner.air_velocity.x
	var lookahead: float = clampf(horizontal_speed * 0.3, -200.0, 200.0)
	var look_at: Vector2 = Vector2(
		runner.feet.x + lookahead,
		clampf(Course.height_at(runner.feet.x) - 170.0, 275.0, 490.0)
	)
	follow_camera.position = follow_camera.position.lerp(look_at, minf(1.0, delta * 5.0))
	_update_hud()
	queue_redraw()

func _restart(from_beginning: bool) -> void:
	if from_beginning:
		checkpoint_index = 0
		collected.clear()
		restarts = 0
	else:
		restarts += 1
	var start_x: float = float(checkpoint_index) * Course.SECTION_LENGTH + 130.0
	runner.respawn_at(start_x)
	ticks = 0
	jumps = 0
	max_run_speed = 0.0
	finished = false
	follow_camera.position = Vector2(start_x, clampf(Course.height_at(start_x) - 170.0, 275.0, 490.0))

func _select_profile(is_responsive: bool) -> void:
	runner.set_responsive_profile(is_responsive)
	_restart(true)

func _collect_nearby() -> void:
	var player_center: Vector2 = runner.feet + Vector2(0.0, -17.0)
	for i in range(pickups.size()):
		if collected.has(i):
			continue
		var coin: Vector2 = pickups[i]
		if absf(player_center.x - coin.x) < 23.0 and player_center.distance_to(coin) < 37.0:
			collected[i] = true

func _update_hud() -> void:
	var index: int = Course.section_index(runner.feet.x)
	var label: String = "A réactif" if runner.responsive_profile else "B inertiel"
	var vx: float = runner.ground_speed if runner.grounded else runner.air_velocity.x
	var grade: float = Course.slope_at(runner.feet.x) * signf(vx) if runner.platform_index < 0 else 0.0
	var slope_label: String = "plat / passerelle"
	if grade > 0.025:
		slope_label = "descente"
	elif grade < -0.025:
		slope_label = "montée"
	if not Course.has_ground_at(runner.feet.x):
		slope_label = "au-dessus du vide"
	var state: String = "ARRIVÉE !" if finished else "Parcours exploratoire · sans ennemis"
	var extra: String = " + ÉLAN" if absf(vx) > MovementModel.GROUND_SPEED_CAP else ""
	hud.text = "%s   |   %02d/10 : %s   |   %s (1/2)\n" % [state, index + 1, Course.STAGE_NAMES[index], label]
	hud.text += "Progression : %.0f / 31 000 px   |   vx : %.0f%s   |   max : %.0f px/s   |   terrain : %s\n" % [runner.feet.x, vx, extra, max_run_speed, slope_label]
	hud.text += "Éclats : %d/%d   |   Sauts : %d   |   Reprises : %d   |   Chrono tentative : %.1f s\n" % [collected.size(), pickups.size(), jumps, restarts, float(ticks) / 60.0]
	hud.text += "← → courir · Espace/Entrée sauter · 1/2 profil · R reprise zone · Maj+R début"

func _draw() -> void:
	var lo: float = maxf(0.0, follow_camera.position.x - VIEW_HALF)
	var hi: float = minf(Course.END_X, follow_camera.position.x + VIEW_HALF)

	# Distinct visual identities per region, drawn only near the camera.
	for zone in range(Course.SECTION_COUNT):
		var first: float = float(zone) * Course.SECTION_LENGTH
		if first > hi or first + Course.SECTION_LENGTH < lo:
			continue
		draw_rect(Rect2(first, -200.0, Course.SECTION_LENGTH, 1350.0), ZONE_COLORS[zone], true)
		for landmark in range(6):
			var mountain_x: float = first + 140.0 + float(landmark) * 550.0
			if mountain_x + 450.0 < lo or mountain_x - 90.0 > hi:
				continue
			var mountain: PackedVector2Array = PackedVector2Array([
				Vector2(mountain_x - 240.0, 800.0),
				Vector2(mountain_x + 80.0, 230.0 + float((zone + landmark) % 3) * 55.0),
				Vector2(mountain_x + 410.0, 800.0)
			])
			draw_colored_polygon(mountain, Color(0.34, 0.58, 0.60, 0.16))
			var cloud_x: float = mountain_x + 200.0
			var cloud_y: float = 50.0 + float((zone + landmark * 3) % 5) * 48.0
			draw_circle(Vector2(cloud_x, cloud_y), 36.0, Color(1.0, 1.0, 1.0, 0.45))
			draw_circle(Vector2(cloud_x + 38.0, cloud_y + 8.0), 28.0, Color(1.0, 1.0, 1.0, 0.45))
			draw_circle(Vector2(cloud_x - 39.0, cloud_y + 9.0), 26.0, Color(1.0, 1.0, 1.0, 0.45))

	# The earth polygons are split exactly at each authored pit.
	var left: float = 0.0
	for hole in Course.GAPS:
		_draw_ground_span(maxf(left, lo - 50.0), minf(hole.x, hi + 50.0))
		left = hole.y
	_draw_ground_span(maxf(left, lo - 50.0), minf(Course.END_X, hi + 50.0))

	for gap in Course.GAPS:
		if gap.y < lo or gap.x > hi:
			continue
		draw_rect(Rect2(gap.x, 730.0, gap.y - gap.x, 420.0), Color("#273449"), true)
		draw_line(Vector2(gap.x - 35.0, Course.height_at(gap.x) - 22.0), Vector2(gap.x - 5.0, Course.height_at(gap.x) - 22.0), Color("#ff8a60"), 5.0)
		draw_line(Vector2(gap.y + 5.0, Course.height_at(gap.y) - 22.0), Vector2(gap.y + 35.0, Course.height_at(gap.y) - 22.0), Color("#ff8a60"), 5.0)

	for i in range(Course.PLATFORM_SPECS.size()):
		var platform: Rect2 = Course.platform_rect(i)
		if platform.end.x < lo or platform.position.x > hi:
			continue
		draw_rect(Rect2(platform.position.x, platform.position.y + 3.0, platform.size.x, 15.0), Color("#324a62"), true)
		draw_rect(Rect2(platform.position.x, platform.position.y, platform.size.x, 7.0), Color("#ffe5a3"), true)
		for x in range(int(platform.position.x) + 12, int(platform.end.x) - 8, 36):
			draw_circle(Vector2(float(x), platform.position.y + 7.0), 3.5, Color("#a77b73"))

	for spring_x in Course.SPRINGS:
		if spring_x < lo or spring_x > hi:
			continue
		var ground_y: float = Course.height_at(spring_x)
		draw_rect(Rect2(spring_x - 21.0, ground_y - 10.0, 42.0, 10.0), Color("#29354f"), true)
		draw_circle(Vector2(spring_x, ground_y - 17.0), 19.0, Color("#f3799d"))
		draw_circle(Vector2(spring_x, ground_y - 18.0), 9.0, Color("#ffd8e5"))

	for i in range(pickups.size()):
		if collected.has(i):
			continue
		var pos: Vector2 = pickups[i]
		if pos.x < lo or pos.x > hi:
			continue
		draw_circle(pos, 11.0, Color("#fdf1a9"))
		draw_circle(pos, 6.0, Color("#f8a841"))

	for zone in range(1, Course.SECTION_COUNT):
		var mark_x: float = float(zone) * Course.SECTION_LENGTH
		if mark_x < lo or mark_x > hi:
			continue
		var mark_y: float = Course.height_at(mark_x)
		draw_line(Vector2(mark_x, mark_y), Vector2(mark_x, mark_y - 90.0), Color("#334459"), 4.0)
		draw_colored_polygon(PackedVector2Array([
			Vector2(mark_x, mark_y - 90.0),
			Vector2(mark_x + 50.0, mark_y - 75.0),
			Vector2(mark_x, mark_y - 59.0)
		]), Color("#f4c46b"))

	draw_line(Vector2(FINISH_X, Course.height_at(FINISH_X) - 125.0), Vector2(FINISH_X, Course.height_at(FINISH_X)), Color("#ffd581"), 7.0)
	var draw_vx: float = runner.ground_speed if runner.grounded else runner.air_velocity.x
	var speed_ratio: float = clampf(absf(draw_vx) / MovementModel.GROUND_SPEED_CAP, 0.0, 1.0)
	draw_rect(Rect2(runner.feet.x - 11.0, runner.feet.y - 31.0, 22.0, 31.0), Color(0.97, 0.87 - speed_ratio * 0.3, 0.33), true)
	draw_circle(Vector2(runner.feet.x, runner.feet.y - 36.0), 8.0, Color("#fff5b4"))

func _draw_ground_span(left: float, right: float) -> void:
	if right <= left:
		return
	var outline: PackedVector2Array = PackedVector2Array()
	outline.append(Vector2(left, Course.height_at(left)))
	for point in Course.POINTS:
		if point.x > left and point.x < right:
			outline.append(point)
	outline.append(Vector2(right, Course.height_at(right)))
	var fill: PackedVector2Array = PackedVector2Array()
	fill.append(Vector2(left, 1150.0))
	fill.append_array(outline)
	fill.append(Vector2(right, 1150.0))
	draw_colored_polygon(fill, Color("#42665f"))
	draw_polyline(outline, Color("#d3ec9b"), 5.0)
