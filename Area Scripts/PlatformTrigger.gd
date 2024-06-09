extends Area2D
class_name PlatformTrigger

@export var ZHeight : float
var boddiesInScene : Array = ["Player"] # add all bodies in scene that need to stand on this array 
var isntBehindPlatform : bool 
func _ready():
	connect("body_entered", Callable(self, "on_platform"))
	connect("body_exited", Callable(self, "off_platform"))
func on_platform(body):
	if body.name in boddiesInScene:
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		if child.playerZ <= ZHeight:
			if !child.ZFloors.has(ZHeight): 
				child.ZFloors.append(ZHeight)
			child.ZFloor = ZHeight      
func off_platform(body):
	if body.name in boddiesInScene: 
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		if child.playerZ <= ZHeight:
			child.ZFloors.erase(ZHeight)

