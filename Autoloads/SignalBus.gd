extends Node

signal on_hit(value : int)

func emit_on_hit(value : int)-> void:
	on_hit.emit(value)
