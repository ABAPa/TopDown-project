class_name InputHandler
extends Node

@onready var camera_2d = $"../Camera2D"


func getPlayerMove() -> float:
	return Input.get_action_strength("Move Right") - Input.get_action_strength("Move Left")
	
func getPlayerMoveFB() -> float:
	return Input.get_action_strength("Move Back") - Input.get_action_strength("Move Forward")
	
func getPlayerJump() -> bool:
	return Input.is_action_just_pressed("Jump")

func getPlayerRoll() -> bool:
	return Input.is_action_just_pressed("Dodge Roll")

#func getGlobalMouse() -> Vector2:
	#get_viewport().get_mouse_position() 
