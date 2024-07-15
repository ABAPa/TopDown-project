class_name CollectableManager
extends Node

var temp_hp_value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.on_hit.connect(on_player_hit)
	
func on_player_hit(value : int) -> void:
	pass

