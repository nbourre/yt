extends KinematicBody2D

enum {WALKING, IDLE, ATTACK}

const MAX_VELOCITY = 50
const MAX_FALL_VELOCITY = 500
const GRAVITY = 100
const CLOSE_ATTACK_DISTANCE = 40

var current_state = WALKING

var acceleration = .5

var velocity = Vector2(0, 0)
var direction = 1
var direction_flip = false

var state_machine

var msg_acc = 0
var msg_rate = .50

var think_acc = 0
var think_rate = .50

var attack_acc = 0
var attack_rate = .2

var other_body
var player_contact = false

func _ready():
	
	state_machine = $AnimationTree.get("parameters/playback")
	#state_machine.start("Walk")
	state_machine.travel("Walk")
	
	
func _physics_process(delta):
	msg_acc += delta

	match (current_state):
		WALKING:
			move_character(delta)
			detect_direction_change()
		IDLE:
			think(delta)
		ATTACK:
			attack(delta)

func think(delta):
	think_acc += delta

	state_machine.travel("Idle")

	if (think_acc >= think_rate):
		think_acc = 0
		current_state = ATTACK

func attack(delta):
	attack_acc += delta

	state_machine.travel("Attack")
	return

	var dist = abs(other_body.position.x - position.x)

	if dist < CLOSE_ATTACK_DISTANCE:
		state_machine.travel("Attack")
	else:
		state_machine.travel("Cast")


func move_character(delta):
	if direction_flip:
		direction_flip = false
		scale.x *= -1
		#debug("velocity: " + str(velocity))

	if (not is_on_floor()):
		velocity.y += GRAVITY
		if velocity.y > MAX_FALL_VELOCITY:
			velocity.y = MAX_FALL_VELOCITY

	velocity.x = MAX_VELOCITY * direction

	velocity = move_and_slide(velocity, Vector2.UP)


func detect_direction_change():
	if is_on_floor():
		if $WallDetector.is_colliding() or not $FloorDetector.is_colliding():
			flip_direction()

func flip_direction():
	direction *= -1
	direction_flip = true			

func debug(msg):	
	print("[" + str(OS.get_ticks_msec()) + "] : " + msg)

func _on_PlayerDetector_body_entered(body:Node):
	return

	if body.get_name() == "Player":

		other_body = body as KinematicBody2D

		var dist = abs(other_body.position.x - position.x)
		
		if dist < CLOSE_ATTACK_DISTANCE:
			current_state = ATTACK
		else:
			current_state = IDLE
		
		debug(body.get_name())


func attack_done():
	current_state = WALKING
	state_machine.travel("Walk")
	if (player_contact):
		player_contact = false
		flip_direction()

	#debug("attack done")

func _on_AnimationPlayer_animation_finished(anim_name:String):
	debug ("animation finished: " + anim_name)
	
func _on_hitbox_front_body_entered(body:Node):
	if body.get_name() == "Player":
		other_body = body as KinematicBody2D

		if (other_body.is_attacking):
			print ("Enemy dead")
			queue_free()
			return
		current_state = ATTACK
		player_contact = true

