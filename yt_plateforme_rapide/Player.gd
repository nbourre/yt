extends KinematicBody2D

const GRAVITY = 35
const JUMP_FORCE = 550
const SPEED = 300
const ACCEL = 0.4

onready var sprite = $AnimatedSprite

var velocity = Vector2.ZERO

func _physics_process(_delta):
	velocity.y += GRAVITY

	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if dir != 0:
		sprite.scale.x = dir
	
	if is_on_floor():
		if dir != 0:
			sprite.play("Run")
		else:
			sprite.play("Idle")
	
	velocity.x = lerp(velocity.x, SPEED * dir, ACCEL)
	velocity = move_and_slide(velocity, Vector2.UP);

func _unhandled_input(event):
	if event.is_action_pressed("Jump") && is_on_floor():
		velocity.y = -JUMP_FORCE
		sprite.play("Jump")

	