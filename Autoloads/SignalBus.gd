extends Node

signal onPlayerReady(player : Player)

func emitOnPlayerReady(player : Player) -> void:
	onPlayerReady.emit(player)
