extends Node2D

export(PackedScene) var Fan
export(PackedScene) var stompinst
export(PackedScene) var tmp_stompinst
export(PackedScene) var spring_stompinst
export(PackedScene) var ufo_stompinst
export(PackedScene) var invis_stompinst
export(PackedScene) var spikes_inst

export(String, FILE) var game_ovg_scene_path := ""

var width
var height
var X_MIN
var X_MAX
var ymin
var ymax
var stomp_width = 64
var stomp_height = 16
var fan_height = 64
var prev_pos
var score
var offset

var ufo_tile_spawn_location_y

var game_over = false
var game_started = false

var score_factor = 0.1
var is_fan_allowed = false
var fan_wait_time = 10
var st
var other_tiles_allowed = false
var can_fan = false
var hack_on = false


func _ready():
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	X_MIN = stomp_width
	X_MAX = width - stomp_width
	ymin = height * (1 / 10.0)
	ymax = height * (3 / 10.0)
	prev_pos = Vector2(width / 2, height * 0.9)
	$Player/camera.smoothing_enabled = false
	$Player/camera.current = false
	st = [stompinst, tmp_stompinst, spring_stompinst, invis_stompinst, spikes_inst]
	offset = height
	randomize()


func _process(_delta):
	if game_started and !game_over:
		if abs(prev_pos.y - $Player.position.y) < 5000:
			var index = randi() % st.size()
			if st[index] != stompinst and !other_tiles_allowed:
				index = 0
			if other_tiles_allowed:
				if st[index] == invis_stompinst or st[index] == spikes_inst:
					index -= randi() % 2

			if st[index] != stompinst:
				is_fan_allowed = false

			var stomp_inst = st[index].instance()
			stomp_inst.position.x = floor(rand_range(X_MIN, X_MAX))
			stomp_inst.position.y = prev_pos.y - floor(rand_range(ymin, ymax))
			prev_pos = stomp_inst.position
			$Node.add_child(stomp_inst)

			if can_fan and is_fan_allowed:
				var fan_ints = Fan.instance()
				fan_ints.position.x = stomp_inst.position.x
				fan_ints.position.y = stomp_inst.position.y - (fan_height + stomp_height) / 2.0
				get_tree().get_root().add_child(fan_ints)
			is_fan_allowed = (floor(exp(-pow(randi() % 2, 2))))

		if game_started:
			if $Player.position.y < -score and $Player.velocity.y < 0:
				score = -floor($Player.position.y * score_factor)
				$HUD.update_score(score)

		if $Player.velocity.y < 0:
			$Area2D.position.y = $Player.position.y + offset
			$Player/camera.limit_bottom = min($Area2D.position.y, height)
#			print($Area2D.position.y)
		if hack_on and Input.is_mouse_button_pressed(1):
			$Player.position = get_global_mouse_position()


func _on_HUD_start_game():
	$Timer.start()
	score = 0
#	hack_on = true
	game_started = true
	is_fan_allowed = true
	$Player/camera.smoothing_enabled = true
	$Player/camera.current = true
	$HUD.update_score(score)


func _on_Player_flying():
	$Player/fly.play()


func _on_Player_on_spikes():
	$Player/death.play()
	game_over = true
	game_started = false
	$Player/AnimatedSprite.play()
	yield(get_tree().create_timer(0.5), "timeout")
	$Player/AnimatedSprite.stop()
	$Player.die()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene(game_ovg_scene_path)


func _on_Player_on_spring():
	$Player/spring.play()

func _on_Player_on_stomp():
	$Player/jump.play()


func _on_Player_on_tmp_tile():
	$Player/tmp_tile.play()


func _on_Area2D_body_entered(_body):
	if _body.is_in_group("player"):
		game_over = true
		game_started = false
		print("poped player")
		_body.die()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene(game_ovg_scene_path)
	else:
		print("poped body")
		_body.queue_free()


func _on_Area2D_area_entered(_area):
	_area.queue_free()


func _on_Timer_timeout():
	other_tiles_allowed = true
	can_fan = true
