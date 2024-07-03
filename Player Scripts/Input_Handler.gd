class_name InputHandler
extends Node

@export var moveEnabled : bool = true

func getPlayerMove() -> float:
	if !moveEnabled:
		return 0
	return Input.get_action_strength("Move Right") - Input.get_action_strength("Move Left")

func getPlayerMoveFB() -> float:
	if !moveEnabled:
		return 0
	return Input.get_action_strength("Move Back") - Input.get_action_strength("Move Forward")

func getPlayerJump() -> bool:
	return Input.is_action_just_pressed("Jump")

func getPlayerRoll() -> bool:
	return Input.is_action_just_pressed("Dodge Roll")

func getPlayerAttack() -> bool:
	return Input.is_action_just_pressed("Attack")
