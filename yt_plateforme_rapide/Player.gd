extends KinematicBody2D

const GRAVITY = 35
const JUMP_FORCE = 550
const SPEED = 300
const ACCEL = 0.4

enum { RUNNING, IDLE, ATTACKING, SUICIDE, DEAD, JUMPING }

var current_state = IDLE

onready var sprite = $Sprite
var state_machine
var is_dead = false
var dir = 0
var facing_right = 1
var velocity = Vector2.ZERO

var is_attacking = false

export var knockback = 1000
export var knockup = -750


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.travel("Idle")

func _physics_process(delta):
	
	match (current_state):
		DEAD:
			return
		IDLE:
			idle(delta)
		RUNNING:
			running(delta)
		ATTACKING:
			attacking(delta)
		SUICIDE:
			harakiri(delta)
		JUMPING:
			jumping(delta)
	
	
	velocity.y += GRAVITY
	velocity.x = lerp(velocity.x, SPEED * dir, ACCEL)
	velocity = move_and_slide(velocity, Vector2.UP)

func attack(delta:float, attack_name:String):
	is_attacking = true
	state_machine.travel(attack_name)
	current_state = ATTACKING
	set_attack_monitoring()
	
func attacking(delta:float):
	dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if dir != 0:
		sprite.scale.x = dir
		facing_right = dir
		if (not is_attacking):
			state_machine.travel("Run")
			current_state = RUNNING
	else :
		if (not is_attacking):
			state_machine.travel("Idle")
			current_state = IDLE

func idle(delta:float):
	dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if dir != 0:
		sprite.scale.x = dir
		facing_right = dir
		state_machine.travel("Run")
		current_state = RUNNING
	
	check_inputs(delta)

func check_inputs(delta:float):
	if Input.is_action_pressed("Attack_1") :
		attack(delta, "Attack_1")
		return
	
	if Input.is_action_pressed("Attack_2"):
		attack(delta, "Attack_2")
		return
		
	if Input.is_action_pressed("Attack_3"):
		attack(delta, "Attack_3")
		return
		
	if Input.is_action_just_pressed("Suicide"):
		harakiri(delta)
		return
		
	if Input.is_action_just_pressed("Jump"):
		jump(delta)
		return
		
func running(delta:float):
	dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if dir != 0:
		sprite.scale.x = dir
		facing_right = dir
	else:
		state_machine.travel("Idle")
		current_state = IDLE
		
	check_inputs(delta)
	

func jump(delta:float):
	velocity.y = -JUMP_FORCE
	state_machine.travel("Jump")
	current_state = JUMPING
	
func jumping(delta:float):
	if velocity.y > 0:
		state_machine.travel("Falling")
	
	if (is_on_floor()):
		state_machine.travel("Idle")
		current_state = IDLE
	
func harakiri(delta:float):
	state_machine.travel("Dead")
	is_dead = true
	current_state = DEAD

func _on_Hurtbox_area_entered(area:Area2D):
	if area.is_in_group("enemy_hitbox"):
		velocity.x = lerp (velocity.x, knockback * -facing_right, 0.5)
		velocity.y = lerp (0, knockup, 0.6)
		velocity = move_and_slide(velocity, Vector2.UP);
		blink()

func set_attack_monitoring():
	print ("Attacking")
	$Hitbox.monitorable = true
	$Hitbox.monitoring = true
	yield(get_tree().create_timer(0.5), "timeout")
	$Hitbox.monitorable = false
	$Hitbox.monitoring = false
	print ("Attacking done")
	is_attacking = false

func blink():

	$Hurtbox.set_deferred("monitoring", false)
	$Hurtbox.set_deferred("monitorable", false)
	
	sprite.visible = false;
	yield(get_tree().create_timer(0.05), "timeout")
	sprite.visible = true;
	yield(get_tree().create_timer(0.07), "timeout")
	sprite.visible = false;
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.visible = true;

	$Hurtbox.set_deferred("monitoring", true)
	$Hurtbox.set_deferred("monitorable", true)
	


func _on_Hitbox_area_entered(area:Area2D):
	if (area.is_in_group("enemy_hurtbox")):
		Globals.debug ("Hurt")
