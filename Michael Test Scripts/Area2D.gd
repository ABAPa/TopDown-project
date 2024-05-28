extends Area2D
class_name PlatformTrigger

@export var ZHeight : float
@export var ZBasePosition : float
var boddiesInScene : Array = ["Player"] # add all bodies in scene that need to stand on this array 


# Called when the node enters the scene tree for the first time.

func _ready():
	connect("body_entered", Callable(self, "on_platform"))
	connect("body_exited", Callable(self, "off_platform"))
	
func on_platform(body):
	if body.name in boddiesInScene:
		#get the child with the jump script
		var child = body.get_node("Jump_Handler")
		
		# Send the constant to the child's script
		child.isOnPlatform = true
		
		# Send the constant to the body's script
		child.ZFloor = ZHeight      
func off_platform(body):
	if body.name in boddiesInScene: 
		#get the child with the jump script
		var child = body.get_node("Jump_Handler")
		
		child.isOnPlatform = false


