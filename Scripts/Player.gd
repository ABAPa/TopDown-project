class_name Player
extends CharacterBody2D


func _physics_process(delta):
	velocity.normalized()
	move_and_slide()
	
