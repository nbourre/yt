extends KinematicBody2D

const MAX_VELOCITY = 50
const MAX_FALL_VELOCITY = 200
const GRAVITY = 10

enum {WALKING, ATTACKING, DEATH}

var current_state = WALKING

var velocity = Vector2.ZERO

var direction = 1
var direction_flip = false

func _ready():
	pass

func _physics_process(delta):

	match(current_state):
		WALKING:
			walking(delta)
		ATTACKING:
			attacking(delta)
		DEATH:
			death(delta)
			return


func walking(delta):
	detect_direction_change()
	if direction_flip:
		direction_flip = false
		scale.x *= -1

	velocity.y += GRAVITY if velocity.y < MAX_FALL_VELOCITY else MAX_FALL_VELOCITY

	velocity.x = MAX_VELOCITY * direction

	velocity = move_and_slide(velocity, Vector2.UP)

func attacking(delta):
	pass

func death(delta):
	pass

func detect_direction_change():
	if is_on_floor():
		if not $FloorDetector.is_colliding() or $WallDetector.is_colliding():
			flip_direction()

func flip_direction():
	direction *= -1
	direction_flip = true