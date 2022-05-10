extends KinematicBody2D

const MAX_VELOCITY = 50
const MAX_FALL_VELOCITY = 200
const GRAVITY = 10

enum {WALKING, ATTACKING, DEATH}

var current_state = WALKING

var velocity = Vector2.ZERO

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
	
	velocity.y += GRAVITY if velocity.y < MAX_FALL_VELOCITY else MAX_FALL_VELOCITY

	velocity.x = MAX_VELOCITY

	velocity = move_and_slide(velocity, Vector2.UP)

func attacking(delta):
	pass

func death(delta):
	pass