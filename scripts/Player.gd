extends KinematicBody2D

#export (PackedScene) var fan

signal on_stomp
signal on_spring
signal flying
signal on_spikes
signal on_tmp_tile

var velocity = Vector2.ZERO
var speed = Vector2(400.0,1200.0)
var gravity = 1000.0
var spring_impulse = 1600.0
var stompimpulse = 1000.0
var player_fly_impulse = 3500.0

var floornormal = Vector2.UP
var screen_width
var screen_height
var is_flying = false



func _ready():
	var s = get_viewport_rect().size
	screen_width = s.x
	screen_height = s.y

func _physics_process(delta):
	var dir
	
	dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity.x = speed.x*dir
	velocity.y += gravity*delta
	
	if Input.is_action_pressed("jump") and self.is_on_floor():
		velocity.y = -speed.y
	
	if(position.x > screen_width):
		position.x = 0
	elif(position.x < 0):
		position.x = screen_width
	velocity = move_and_slide(velocity, floornormal)


func calculate_stomp_velocity(lin_velocity: Vector2, impulse: float):
	var ans = lin_velocity
	ans.y = -impulse
	return ans
	
func die():
	queue_free()

func _on_enemydect_body_entered(_body):
	if _body.is_in_group("stomp"):
		if velocity.y >= 0:
			emit_signal("on_stomp")
			velocity = calculate_stomp_velocity(velocity,stompimpulse)
	elif _body.is_in_group("spring"):
		if velocity.y >= 0:
			emit_signal("on_spring")
			velocity = calculate_stomp_velocity(velocity,spring_impulse)
	elif(_body.is_in_group("tmp_tile")):
		if velocity.y >= 0:
			print("on tmp tile")
			_body.can_play = true
			_body.queue_free()
			emit_signal("on_tmp_tile")
			velocity = calculate_stomp_velocity(velocity,stompimpulse)
	elif _body.is_in_group("spike"):
		if velocity.y >= 0:
			emit_signal("on_spikes")
		

func _on_enemydect_area_entered(_area):
	if(_area.is_in_group("boost")):
		if velocity.y >= 0:
			_area.queue_free()
			is_flying = true
			emit_signal("flying")
			velocity = calculate_stomp_velocity(velocity,player_fly_impulse)
