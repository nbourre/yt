extends State

class_name PlayerIdleState

func enter(object):
    object.set_animation("parameters/movement/current", 0)

func handleInput(object, event):
    var ev = event as InputEvent
    var p = object as Player
    
    if (ev.is_action_just_pressed("jump")):
        p.velocity.y = -p.JUMP_FORCE
        p.set_animation("parameters/in_air/current", 1)