extends Camera2D
class_name PlayerCamera

var offsetThreshold: float = 50.0
var maxOffsetDistance: float = 60.0
var smoothingSpeedOut: float = 3
var smoothingSpeedIn: float = 1
@export var player : CharacterBody2D

func _ready():
	self.offset = Vector2()

func _process(delta):
	cameraLookToMouse(delta)

func cameraLookToMouse(delta : float):
	var mouseDifference = player.playerMouseDifference()
	var distanceToMouse = mouseDifference.length()
	var targetOffset = Vector2()
	
	if distanceToMouse < offsetThreshold: # Camera moves toward player
		targetOffset = Vector2.ZERO
	else: # Camera moves away from player
		mouseDifference = mouseDifference.normalized() * maxOffsetDistance
		targetOffset = mouseDifference
	
	# Calculate smoothing speed based on the distance
	var awaySmoothingSpeed = distanceToMouse / maxOffsetDistance / 1.5
	awaySmoothingSpeed = clamp(awaySmoothingSpeed, smoothingSpeedIn, smoothingSpeedOut)
	
	self.offset = self.offset.lerp(targetOffset, awaySmoothingSpeed * delta)
