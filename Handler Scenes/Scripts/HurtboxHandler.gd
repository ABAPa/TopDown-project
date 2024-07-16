class_name HurtboxHandler
extends Area2D

@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var invuln_timer = $InvulnTimer as Timer

@export var invuln_time : float = 1.0
@export var health_handler : HealthHandler = null

func handle_damage(damage_value : int) -> void:
	health_handler.apply_damage(damage_value)
	collision_shape_2d.set_deferred("disabled", true)
	invuln_timer.start(invuln_time)

func roll_invuln(roll_invuln_time : float)-> void:
	collision_shape_2d.set_deferred("disabled", true)
	invuln_timer.start(roll_invuln_time)
func jump_invuln(jump_invuln_time : float)-> void:
	collision_shape_2d.set_deferred("disabled", true)
	invuln_timer.start(jump_invuln_time)
func knocked_down_invuln(knocked_invuln_time : float)-> void:
	collision_shape_2d.set_deferred("disabled", true)
	invuln_timer.start(knocked_invuln_time)

func _on_invuln_timer_timeout():
	collision_shape_2d.set_deferred("disabled", false)
