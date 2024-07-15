class_name HealthHandler
extends Node

@export var max_health : int = 10

var current_health : int = 0

func _ready():
	set_current_health(max_health)

func get_current() -> int:
	return current_health

func set_current_health(new_health : int) -> void:
	current_health = new_health

func set_max_health(value : int) -> void:
	if value != 0:
		max_health = value
		current_health = max_health
		return
	current_health = max_health

func apply_damage(damage_value : int) -> void:
	current_health -= damage_value
	handle_health()

func apply_healing(healing_value : int) -> void:
	current_health += healing_value
	handle_health()

func handle_health()-> void: #prevents health larger than max, and health lower than min aka 0
	if current_health > max_health:
		current_health = max_health
	
	if current_health < 0:
		current_health =0
		
		#TODO test destruction
		owner.queue_free()#deletes the scene it is in from world
	print("Health " + str(current_health))
