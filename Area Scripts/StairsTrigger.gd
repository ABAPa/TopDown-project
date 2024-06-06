extends Area2D
class_name StairsTrigger

@export var ZTop : float
@export var ZBottom : float
var boddiesInScene : Array = ["Player"] # add all bodies in scene that need to stand on this array 
@onready var collisionShape = get_child(0)
@onready var totalHeight = collisionShape.shape.size.y
@onready var globalPosition = collisionShape.position.y
func _ready():
	connect("body_entered", Callable(self, "on_Stairs"))
	connect("body_exited", Callable(self, "off_Stairs"))
func on_Stairs(body):
	if body.name in boddiesInScene:
		
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		var bodyZ = child.body_Position_On_Strairs(body, totalHeight, globalPosition, ZTop, ZBottom)
		if child.playerZ <= bodyZ:
			child.ZFloor = bodyZ
			child.totalHeight = totalHeight
			child.globalPosition = globalPosition
			child.ZTop = ZTop
			child.ZBottom = ZBottom
			child.ZFloors.append(bodyZ)
			child.isOnPlatform += 1
			child.isOnStairs = true
			
func off_Stairs(body):
	if body.name in boddiesInScene: 
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		var bodyZ = child.body_Position_On_Strairs(body, totalHeight, globalPosition, ZTop, ZBottom)
		child.ZFloors.erase(bodyZ)
		child.isOnStairs = false
		child.isOnPlatform -= 1
		

