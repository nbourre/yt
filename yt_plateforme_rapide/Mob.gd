extends KinematicBody2D


enum {WALKING, IDLE}
var state_machine

const MAX_VELOCITY = 100
var velocity = Vector2()
var direction = -1

onready var sprite = $Sprite

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	pass

func _physics_process(delta):
	move_character()
	detect_turn_around()

func move_character():
	velocity.y += 20

	if direction == -1:
		velocity.x -= 10
	else:
		velocity.x += 10
	
	if abs(velocity.x) > MAX_VELOCITY:
		velocity.x = MAX_VELOCITY * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)

	# Display
	if (velocity.x != 0):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

	if direction != 0:
		scale.x = direction
		debug ("scale.x: " + str(scale.x))


func detect_turn_around():

	if is_on_floor():
		if not $FloorDetector.is_colliding() :
			direction *= -1
			debug ("Direction : " + str(direction))
		# elif $WallDetector.is_colliding() :
		# 	direction *= -1
		# 	debug ("Time to turn around : Wall")

func debug(msg):
	print ("[" + str(OS.get_ticks_msec()) + "] : " + msg)
