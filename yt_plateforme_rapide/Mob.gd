extends KinematicBody2D

enum {WALKING, IDLE, ATTACK}

const MAX_VELOCITY = 50
const MAX_FALL_VELOCITY = 500
const GRAVITY = 100

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

var other_body

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
	state_machine.travel("Attack")

func move_character(delta):

	if direction_flip:
		direction_flip = false
		scale.x *= -1
		debug("velocity: " + str(velocity))

	if (not is_on_floor()):
		velocity.y += GRAVITY
		if velocity.y > MAX_FALL_VELOCITY:
			velocity.y = MAX_FALL_VELOCITY

	velocity.x = MAX_VELOCITY * direction
	if velocity.x > MAX_VELOCITY:
		velocity.x = MAX_VELOCITY
	elif velocity.x < -MAX_VELOCITY:
		velocity.x = -MAX_VELOCITY

	velocity = move_and_slide(velocity, Vector2.UP)


func detect_direction_change():
    if is_on_floor():
        if $WallDetector.is_colliding() or not $FloorDetector.is_colliding():
            direction *= -1
            direction_flip = true
            debug("direction: " + str(direction))
    
func debug(msg):
	print("[" + str(OS.get_ticks_msec()) + "] : " + msg)

func _on_PlayerDetector_body_entered(body:Node):
	if body.get_name() == "Player":
		current_state = IDLE
		other_body = body as KinematicBody2D
		debug(body.get_name())
	pass # Replace with function body.


func attack_done():
	current_state = WALKING
	debug("attack done")

func _on_AnimationPlayer_animation_finished(anim_name:String):
	debug ("animation finished: " + anim_name)
	pass # Replace with function body.
