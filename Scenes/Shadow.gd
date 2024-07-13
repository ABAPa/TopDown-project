extends Sprite2D
var physicsNode
var ShadowZ
var parent
var originPosition
var parentDistance : float
# Called when the node enters the scene tree for the first time.
func _ready():
	originPosition = self.position.y
	parent = self.get_parent()
	physicsNode = parent.get_child(0).get_child(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not physicsNode.ZFloors.is_empty():
		ShadowZ = physicsNode.positionZ - physicsNode.current_platform_z()
		self.position.y = originPosition - ShadowZ
		"""parentDistance = (self.position.y - parent.position.y)
		var a = 1.0 - (parentDistance / 100.0)
		self.modulate.a = clamp(a, 0.0, 1.0)"""
