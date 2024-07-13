extends Area2D
class_name PlatformBodyDetector

@export var playerJump : State

var platformBodyHeights : Array
var BodyRIDs : Array
var colliderBoxExtents : Array
var platformBodyBases : Array
var platformBodys : Array

var parent
var physicsNode
var isInColliderArea : bool

func _ready():
	parent = self.get_parent()
	physicsNode = parent.get_child(0).get_child(0)
	connect("body_entered", Callable(self, "body_detected"))
	connect("body_exited", Callable(self, "body_left"))
func _process(delta): #handle weather or not player can move through collider here
	for i in range(platformBodyHeights.size()):
		var platformHeight = platformBodyHeights[i]
		var bodyRID = BodyRIDs[i]
		var colliderBoxExtent = colliderBoxExtents[i]
		var platformBodyBase = platformBodyBases[i]
		var platformBody = platformBodys[i]
		
		var rect2 = platformBody.get_child(0).shape.get_rect()
		rect2.position = platformBody.global_position
		var objectPosition = parent.position
		#objectPosition.y += (platformBodyBase - physicsNode.positionZ)
		
		collision_exception(physicsNode, platformHeight, bodyRID)
		
		#is_touching_wall(objectPosition, rect2, platformBody)
		
func body_detected(body):
	if body is PlatformBody && body.colliderZHieght not in platformBodyHeights:
		platformBodyHeights.append(body.colliderZHieght)
		BodyRIDs.append(body.get_rid())
		colliderBoxExtents.append(body.get_child(0).shape.extents)
		platformBodyBases.append(body.colliderZBase)
		platformBodys.append(body)
func body_left(body):
	if body is PlatformBody:
		platformBodyHeights.erase(body.colliderZHieght)
		BodyRIDs.erase(body.get_rid())
		colliderBoxExtents.erase(body.get_child(0).shape.extents)
		platformBodyBases.erase(body.colliderZBase)
		platformBodys.erase(body)
	
func collision_exception(physicsNode : Node, platformHeight : float, bodyRID : RID) -> void:#physicsNode.is_in_wall()
		if  physicsNode.hasJumped == true or physicsNode.positionZ <= platformHeight or not physicsNode.is_in_wall() && physicsNode.ZFall == true:
			PhysicsServer2D.body_add_collision_exception(bodyRID, parent.get_rid()) 
		else: 
			PhysicsServer2D.body_remove_collision_exception(bodyRID, parent.get_rid())
func in_wall_area(platformHeight : float) -> bool:
	return physicsNode.determine_closest_below(physicsNode.positionZ, physicsNode.ZFloors) > platformHeight
"""func is_touching_wall(objectPosition, rect2, platformBody):
	var absolute = rect2.abs()
	if absolute.has_point(objectPosition):
		print("on")
	else: print(objectPosition, absolute.position, platformBody.position)"""
	#return colliderBoxPosition.has_point(objectPosition)
