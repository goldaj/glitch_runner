extends Node2D
## Visible game-feel laboratory P1: no deliberate glitches.
const Course = preload("res://scripts/course_profile.gd")
const MovementModel = preload("res://scripts/movement_model.gd")
const FINISH_X: float = 2970.0

var runner = MovementModel.new()
var ticks: int = 0
var finished: bool = false
var reset_held: bool = false
var follow_camera: Camera2D
var hud: Label

func _ready() -> void:
	follow_camera = Camera2D.new()
	add_child(follow_camera)
	follow_camera.make_current()
	var layer: CanvasLayer = CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(16.0, 16.0)
	hud.add_theme_font_size_override("font_size", 18)
	layer.add_child(hud)
	_update_hud()

func _physics_process(delta: float) -> void:
	var is_reset: bool = Input.is_key_pressed(KEY_R)
	if is_reset and not reset_held:
		runner.reset()
		ticks = 0
		finished = false
	reset_held = is_reset

	if not finished:
		var axis: float = Input.get_axis("ui_left", "ui_right")
		var jump_down: bool = Input.is_action_just_pressed("ui_accept")
		var jump_held: bool = Input.is_action_pressed("ui_accept")
		runner.step(axis, jump_down, jump_held, delta)
		ticks += 1
		if runner.feet.x >= FINISH_X:
			finished = true

	var lookahead: float = clampf(runner.ground_speed * 0.22, -135.0, 135.0)
	var target: Vector2 = Vector2(runner.feet.x + lookahead, 345.0)
	follow_camera.position = follow_camera.position.lerp(target, minf(1.0, delta * 6.0))
	_update_hud()
	queue_redraw()

func _update_hud() -> void:
	var seconds: float = float(ticks) / 60.0
	var status: String = "ARRIVÉE (R pour recommencer)" if finished else "Laboratoire P1 · sans glitch"
	hud.text = "%s\nChrono : %.2f s  |  vitesse : %.0f px/s\nFlèches : déplacement · Espace/Entrée : saut · R : reset" % [status, seconds, runner.speed()]

func _draw() -> void:
	draw_rect(Rect2(0.0, 0.0, Course.END_X, 820.0), Color(0.10, 0.15, 0.22), true)
	for x in range(0, int(Course.END_X), 128):
		draw_line(Vector2(float(x), 0.0), Vector2(float(x), 820.0), Color(0.16, 0.20, 0.29), 1.0)
	var terrain: PackedVector2Array = PackedVector2Array()
	terrain.append(Vector2(0.0, 820.0))
	for point in Course.POINTS:
		terrain.append(point)
	terrain.append(Vector2(Course.END_X, 820.0))
	draw_colored_polygon(terrain, Color(0.23, 0.33, 0.38))
	for i in range(Course.POINTS.size() - 1):
		draw_line(Course.POINTS[i], Course.POINTS[i + 1], Color(0.45, 0.85, 0.74), 4.0)
	draw_line(Vector2(FINISH_X, Course.height_at(FINISH_X) - 115.0), Vector2(FINISH_X, Course.height_at(FINISH_X)), Color(1.0, 0.80, 0.33), 5.0)
	var speed_ratio: float = clampf(runner.speed() / MovementModel.GROUND_SPEED_CAP, 0.0, 1.0)
	draw_rect(Rect2(runner.feet.x - 11.0, runner.feet.y - 31.0, 22.0, 31.0), Color(0.98, 0.95 - speed_ratio * 0.36, 0.34), true)
	draw_circle(Vector2(runner.feet.x, runner.feet.y - 36.0), 8.0, Color(1.0, 0.96, 0.75))
