extends KinematicBody2D

const MAX_FALL_VELOCITY = 200
const GRAVITY = 10
const MAX_VELOCITY = 50 

enum {WALKING, ATTACKING, DEATH}

var current_state = WALKING

var velocity = Vector2.ZERO

var direction = 1
var direction_flip = false

var state_machine

var is_player_nearby = false
var player : KinematicBody2D

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.travel("Walk")

func _physics_process(delta):
	match (current_state):
		WALKING:
			detect_direction_change()
			walk(delta)
		ATTACKING:
			attack(delta)
		DEATH:
			death(delta)
			return		

func walk_enter():
	state_machine.travel("Walk")
	current_state = WALKING

func walk(delta):
	if (direction_flip):
		scale.x *= -1
		direction_flip = false

	velocity.y += GRAVITY if velocity.y < MAX_FALL_VELOCITY else 0

	velocity.x = MAX_VELOCITY * direction

	velocity = move_and_slide(velocity, Vector2.UP)

func attack_enter():
	state_machine.travel("Attack")
	current_state = ATTACKING

func attack(delta):
	if (is_player_nearby):
		state_machine.travel("Attack")

func attack_done():
	if (not is_player_nearby):
		flip_direction()
		walk_enter()

func death(delta):
	pass

func detect_direction_change():
	if (is_on_floor()):
		if not $FloorDetector.is_colliding() or $WallDetector.is_colliding() :
			flip_direction()

func flip_direction():
	direction *= -1
	direction_flip = true

func _on_PlayerDetector_body_exited(body:Node):
	if (body.name == "Player"):
		is_player_nearby = false
		player = null
		#flip_direction()
		#walk_enter()

func _on_PlayerDetector_body_entered(body:Node):
	if (body.name == "Player"):
		player = body as Player

		if (player.is_alive()) :
			is_player_nearby = true			
			attack_enter()
		else:
			is_player_nearby = false
			flip_direction()
