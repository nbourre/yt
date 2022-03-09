extends KinematicBody2D

class_name Player

const GRAVITY = 35
const JUMP_FORCE = 550
const SPEED = 300
const ACCEL = 0.4

onready var sprite = $AnimatedSprite

var velocity = Vector2.ZERO
var isDead = false
var isAttacking = false



func _ready():
	$AnimationTree.active = true
	
func _physics_process(_delta):
	velocity.y += GRAVITY

	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if (Input.is_action_just_released("Jump") && not is_on_floor()):
		$AnimationTree.set("parameters/in_air/current", 0)
		

	if dir != 0:
		$Sprite.flip_h = dir < 0
	
	if is_on_floor():
		if isDead:
			$AnimationTree.set("parameters/movement/current", 3)
		elif isAttacking:
			$AnimationTree.set("parameters/movement/current", 2)
		else:
			if dir != 0:
				$AnimationTree.set("parameters/movement/current", 1)
			else:
				$AnimationTree.set("parameters/movement/current", 0)
	
	velocity.x = lerp(velocity.x, SPEED * dir, ACCEL)
	velocity = move_and_slide(velocity, Vector2.UP);

	$AnimationTree.set("parameters/in_air_state/current", int(!$RayCast2D.is_colliding()))

func _unhandled_input(event):
	if is_on_floor():
		if event.is_action_pressed("Jump"):
			velocity.y = -JUMP_FORCE
			$AnimationTree.set("parameters/in_air/current", 1)
			pass

		if event.is_action_pressed("attack_a"):
			isAttacking  = true
			$AnimationTree.set("parameters/attack_state/current", 0)
			pass
	

func _on_AnimationPlayer_animation_finished(anim_name:String):
	print("animation finished: " + anim_name)
	if (anim_name == "attack_1"):
		isAttacking = false
		$AnimationTree.set("parameters/movement/current", 0)
		pass

func testPrint():
	print("test")

func set_animation(param_name:String, value):
	$AnimationTree.set(param_name, value)
	pass