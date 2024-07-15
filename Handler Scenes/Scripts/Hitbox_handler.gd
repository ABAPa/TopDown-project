class_name HitboxHandler
extends Area2D

var damage_amount : int = 1

signal attack_hit

func _ready():
	pass

func set_damage(new_damage : int)-> void:
	damage_amount = new_damage


func _on_area_entered(area):
	if area is HurtboxHandler:
		area.handle_damage(damage_amount)
		attack_hit.emit()
