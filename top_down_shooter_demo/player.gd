extends CharacterBody2D

@export var speed = 1000
@export var acceleration = 0.1
@export var friction = 0.05

var bullet = preload("res://bullet.tscn")
@export var bullet_speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var direction = Vector2()
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = direction.normalized()
	
	if (direction.length() > 0) :
		velocity = velocity.lerp (direction * speed, acceleration)
	else :
		velocity = velocity.lerp (Vector2.ZERO, friction)
		
	look_at(get_global_mouse_position())
	
	move_and_slide()
	
	if (Input.is_action_just_pressed("fire")):
		fire()

func fire() :
	var instance = bullet.instantiate()
	instance.position = get_global_position() + (Vector2.from_angle(rotation) * 25)
	instance.rotation = rotation
	instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", instance)
	

func _on_area_2d_area_entered(area):
	if "Enemy" in area.get_parent().name :
		var _tmp = get_tree().reload_current_scene()
