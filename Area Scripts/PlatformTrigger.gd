extends Area2D
class_name PlatformTrigger

@export var ZHeight : float
var boddiesInScene : Array = ["Player"] # add all bodies in scene that need to stand on this array 
var isntBehindPlatform : bool 

var areaPosition
func _ready():
	connect("body_entered", Callable(self, "on_platform"))
	connect("body_exited", Callable(self, "off_platform"))
	areaPosition = global_position
func on_platform(body):
	if body.name in boddiesInScene:
		var child = body.get_child(0).get_child(0)
		if not child.ZFloors.has(ZHeight): 
			child.ZFloors.append(ZHeight) 
		
		var relativePosition = body.global_position - areaPosition
		if abs(relativePosition.x) < abs(relativePosition.y) && child.positionZ > ZHeight && child.hasJumped == true:
			body.velocity.x = -body.velocity.x/2
func off_platform(body):
	if body.name in boddiesInScene: 
		var child = body.get_child(0).get_child(0)
		child.ZFloors.erase(ZHeight)
