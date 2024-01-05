extends Node2D

@onready var map : MapProcGen = $Map
@onready var player : CharacterBody2D = $Player

func _ready():
	map.set_gen_pos(player.position)

func _process(delta):
	map.update_position(player.position)
