extends Node2D
class_name TwoPointFiveDShape

var platform
var heightZ
var fullArea
var base
var baseZ
var baseCollider
var baseColliderPosition
var baseColliderRect2
var baseColliderShape
var sortZ
var isMovingPlatform #for moving platforms

var shapeDictionary
var baseTopY
func _ready():
	platform = get_child(0)
	heightZ = platform.ZHeight
	fullArea = get_child(1)
	sortZ= fullArea.areaZSort
	base = get_child(2)
	baseZ = base.colliderZBase 
	baseCollider = base.get_child(0)
	baseColliderRect2 = baseCollider.get_shape().get_rect()
	baseColliderRect2.position = baseCollider.global_position - baseColliderRect2.size / 2
	baseTopY = baseCollider.global_position.y - (baseCollider.get_shape().size.y / 2)
	shapeDictionary = shape_dictionary()
func shape_dictionary() -> Dictionary:
	var shapeDictionary = {
	"platform" : heightZ,
	"areaSortZ" : fullArea,
	"base" : baseZ,
	"baseTop" : baseTopY,
	"shape" : self,
	"sortZ" : sortZ
	}
	return shapeDictionary

func object_in_area(objectPosition : Vector2, objectPositionZ : float):
	var pointZ = objectPosition.y - (objectPositionZ - baseZ)
	return baseColliderRect2.has_point(Vector2(objectPosition.x, pointZ))
