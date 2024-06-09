extends Area2D
class_name TileMapZSort
var boddiesInScene : Array = ["Player"]
@export var areaZHieght : float
func _ready():
	connect("body_entered", Callable(self, "on_Structure_Area"))
	connect("body_exited", Callable(self, "off_Structure_Area"))
func on_Structure_Area(body):
	if body.name in boddiesInScene:
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		child.areaZHieght = areaZHieght
		child.isInArea = true
		if child.playerZ <= areaZHieght:
			child.isBehindPlatform = false
		else: child.isBehindPlatform = true

func off_Structure_Area(body):
	if body.name in boddiesInScene:
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		child.isInArea = false
		if child.playerZ >= areaZHieght:
			child.isBehindPlatform = true
