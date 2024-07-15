class_name Player
extends CharacterBody2D

var collectable_manager : CollectableManager = null



func _physics_process(_delta):
	velocity.normalized()
	move_and_slide()

func playerMouseDifference() -> Vector2:
	var mouseVector = get_global_mouse_position() - self.position
	return mouseVector
