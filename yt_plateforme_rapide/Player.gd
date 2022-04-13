extends KinematicBody2D

const GRAVITY = 35
const JUMP_FORCE = 550
const SPEED = 300
const ACCEL = 0.4

onready var sprite = $Sprite
var state_machine
var is_dead = false
var dir = 0
var velocity = Vector2.ZERO

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta):
	
	if is_dead:
		return

	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir != 0:
		sprite.scale.x = dir
	
	if is_on_floor():
		if dir != 0:
			state_machine.travel("Run")
		else:
			state_machine.travel("Idle")
		
		if Input.is_action_just_pressed("Jump"):
			velocity.y = -JUMP_FORCE
			state_machine.travel("Jump")
		
		if Input.is_action_pressed("Attack_1"):
			state_machine.travel("Attack_1")
			return
		
		if Input.is_action_pressed("Attack_2"):
			state_machine.travel("Attack_2")
			return
			
		if Input.is_action_pressed("Attack_3"):
			state_machine.travel("Attack_3")
			return

		if Input.is_action_just_pressed("Suicide"):
			state_machine.travel("Dead")
			is_dead = true
			return
	else:
		if velocity.y > 0:
			state_machine.travel("Falling")
		
	
	velocity.y += GRAVITY
	velocity.x = lerp(velocity.x, SPEED * dir, ACCEL)
	velocity = move_and_slide(velocity, Vector2.UP);

	