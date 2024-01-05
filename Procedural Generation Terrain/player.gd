extends CharacterBody2D

var speed = 500
		
func _process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	
	position += dir * speed * delta	
	
