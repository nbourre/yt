extends KinematicBody2D

const MAX_VELOCITY = 50
const MAX_FALL_VELOCITY = 200
const GRAVITY = 10

enum {WALKING, ATTACKING, DEATH}

var current_state = WALKING

var velocity = Vector2.ZERO

var direction = 1
var direction_flip = false

var state_machine

var is_player_near = false
var player : KinematicBody2D

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	walking_enter()


func _physics_process(delta):

	match(current_state):
		WALKING:
			walking(delta)
		ATTACKING:
			attacking(delta)
		DEATH:
			death(delta)
			return

func walking_enter():
	state_machine.travel("Walk")
	current_state = WALKING
	

func walking(delta):
	detect_direction_change()
	if direction_flip:
		direction_flip = false
		scale.x *= -1

	velocity.y += GRAVITY if velocity.y < MAX_FALL_VELOCITY else MAX_FALL_VELOCITY

	velocity.x = MAX_VELOCITY * direction

	velocity = move_and_slide(velocity, Vector2.UP)

func attacking_enter():
	state_machine.travel("Attack")
	current_state = ATTACKING

func attacking(delta):
	if (is_player_near):
		state_machine.travel("Attack")
	

func death(delta):
	pass

func detect_direction_change():
	if is_on_floor():
		if not $FloorDetector.is_colliding() or $WallDetector.is_colliding():
			flip_direction()

func flip_direction():
	direction *= -1
	direction_flip = true

func _on_PlayerDetector_body_entered(body:KinematicBody2D):
	if body.name == "Player":
		player = body
		is_player_near = true
		attacking_enter()
		print("Player entered")


func _on_PlayerDetector_body_exited(body:KinematicBody2D):
	if body.name == "Player":
		is_player_near = false
		player = null
		flip_direction()
		walking_enter()
		print("Player exited")
