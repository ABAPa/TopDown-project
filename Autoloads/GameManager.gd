extends Node

var  Gravity : float = 1500.0
var specificGravity : float = 750


func applyGravity(entity : CharacterBody2D, delta : float) -> void:
	entity.velocity.y += Gravity * delta
