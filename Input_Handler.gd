class_name InputHandler
extends Node


func getPlayerMove() -> float:
	return Input.get_axis("Move Left", "Move Right")

func getPlayerJump() -> bool:
	return Input.is_action_just_pressed("Jump")


