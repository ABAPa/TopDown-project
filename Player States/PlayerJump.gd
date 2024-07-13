extends State
class_name PlayerJump

@export var player : CharacterBody2D

@onready var input_handler = $"../../Input_Handler"
@onready var player_run = $"../PlayerRun"

var positionZ : float = 0
var priorPositionZ : float
var ZFloor : float = 0
var newMaxJumpHiegt : float = -147.5

@export var ZSpeed : float = -3
@export var ZGravity : float = 3
@export var jumpVelocity : float = 0
@export var jumpAcceleration : float = 55

var ZFall : bool = false # gravity is on/off
var isOnPlatform : bool = true #tracks the number of platforms (PlatformTrigger area2ds) the player is on
var hasJumped : bool = false #has jumped, has not reached jump apex yet
var isOnStairs : bool = false #is on stairs trigger area2d
var areaZHieght : Array # the Zhieght of the whole area (building or platform) a player is in the area2d of
var areaZSort : Array
var globalPositionBaseYs : Array
var shapeDictionaries : Array

var colliderBody : RID 
var isInColliderArea : bool

var colliderZ : float

var totalHeight : float #total hieght of the stairs
var globalPosition : float #position of stairs area2D
var ZTop : float # top of stairs
var ZBottom : float #bottom of stairs

var ZFloors : Array = [0] #array for the ZHieght of each platform area2d the player is in. on ready should set to current scene Zhieght

var ZVector : Vector2 #will use the y axis as a z axis that will allow the jump to be calculated independet of wasd movement

var jumpStartVelocity = -400.0
var fallStartVelocity = 0
var maxFallVelocity = 500
var jumpDuration = .75
var fallAccelDuration = 2
var jumpTimer = 0.0
var t = 0
var fallVelocity = 0.0
var fallTimer = 0.0

var canCoyoteJump

var onReadyMaxSpeed  

var sceneMinimumZ : float = 100 # set on ready to be the lowest point in the scene which the player can fall, in the deathbox


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	#await get_tree().create_timer(0.1).timeout
	#ZFloors.erase(0)
	positionZ = current_platform_z()
	priorPositionZ = positionZ
	onReadyMaxSpeed = player_run.maxSpeed
	await get_tree().create_timer(0.1).timeout
	ZFloors.erase(0)
func _process(delta):
	#print(is_in_wall())
	#print(current_platform_z(), " ", ZFloors, " ", around_platform_Z(), " ", ZFloors.is_empty(), " ", positionZ)
	#print(isOnPlatform)
	#print(ZFall,hasJumped)
	#print(ZFloors.min(), " " , current_platform_z(), " ",positionZ, " ", player.velocity.y)
	#print(around_platform_Z(), " ", current_platform_z(), " ", positionZ)
	#if isOnStairs: 
		#body_Position_On_Strairs(player, totalHeight, globalPosition, ZTop, ZBottom)
	player.z_index = Z_sort()

	
func PhysicsUpdate(delta : float):
	handleJump(delta) 
	player_run.handleMovement(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB(), delta) #need to be able to control movement while jumping
	platform_Check(delta)
	#print(playerZ," Z, max ",newMaxJumpHiegt)
	
	
func handleJump(delta : float) -> void:
	coyote_time(delta)
	if hasJumped && (ZFall == false or canCoyoteJump == true): 
		jumpTimer += delta 
		t = jumpTimer / jumpDuration 
		# Use an easing function for accel
		jumpVelocity = jumpStartVelocity * pow((1 - t), 2)
		#add jump velocity to playery and posz so the posz can be destinguished from forward/back (W/S) movement
		player.position.y += jumpVelocity * delta
		positionZ += jumpVelocity * delta
		if t >= jumpDuration: #reset jump vars when apex of the jump is reached
			hasJumped = false
			jumpTimer = 0.0
			t = 0.0
			jumpVelocity = 0.0
		
func platform_Check(delta): 
	if ZFloors.is_empty() or not around_platform_Z(): #if not on any platformtrigger area2d or if posZ is not the platforms Z
		isOnPlatform = false
	else:
		isOnPlatform = true

	if isOnPlatform == true and hasJumped == false: #hasJumped == false and is on platform
		ZFall = false
		positionZ = current_platform_z()
		change_States()
	elif (ZFall == true or isOnPlatform == false) && hasJumped == false: # if falling or not on a platform, fall. hasjumped = false prevents then bieng on on jump
		hasJumped = false
		ZFall = true
		fallTimer += delta #fallTimer increases over time
		t = fallTimer / fallAccelDuration #as fallTimer increases it is devided by a const so it stops accelorating
		fallVelocity = 500 * t #apply velocity
		player.position.y += fallVelocity * delta
		priorPositionZ = positionZ
		positionZ += fallVelocity * delta #add equally to positionZ
		if around_platform_Z() == true: #resets jump for next
			t = 0.0
			fallVelocity = 0.0
			fallTimer = 0.0
			ZFall = false

func change_States():
	var movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0:
		Transitioned.emit(self, "PlayerRun")
	else: Transitioned.emit(self, "PlayerIdle")
	
"""func body_Position_On_Strairs (body, totalHeight, globalPosition, ZTop, ZBottom):
		var distanceToBody = body.position.y - globalPosition
		var proportion = distanceToBody / totalHeight
		var bodyZ = lerp(ZBottom, ZTop, proportion)
		return bodyZ"""


func Z_sort() -> int:
	var ZSort = 0
	if shapeDictionaries.is_empty():
		return ZSort 
	for i in range(shapeDictionaries.size()):
		var dictionary = shapeDictionaries[i]
		if (positionZ <= dictionary["platform"] or player.position.y > dictionary["baseTop"]) and ZSort < dictionary["sortZ"]:
			ZSort = dictionary["sortZ"]
	return ZSort
	
	
func around_platform_Z() -> bool:
	if ZFloors.is_empty():
		return false
	var threshold = 5
	if abs(positionZ - current_platform_z()) - (threshold/3) < threshold: # when player is about to land or is on platform
		if isOnPlatform == false: # only runs at the very end of jump when landing
			player.position.y +=  (current_platform_z() - positionZ)/2 #account for dist between pos and ground so player lands at same spot
			positionZ = current_platform_z()
			ZFall = false
		return true
	return false

func current_platform_z() -> float: 
	if ZFloors.is_empty(): 
		return sceneMinimumZ #if not on floor, return big number aka fall to death
	return determine_closest_below(positionZ, ZFloors)

func determine_closest_below(position : float, arr : Array) -> float:
	var closest_val = arr.max() #start with greatest number
	var smallest_diff = INF 
	for i in arr:
		if i >= position:
			var diff = abs(i - position)
			if diff < smallest_diff:
				smallest_diff = diff
				closest_val = i
	return closest_val

func is_in_wall() -> bool:
	var isInWall = false
	if shapeDictionaries.is_empty():
		return isInWall
	for i in range(shapeDictionaries.size()):
		var dict = shapeDictionaries[i]
		if dict["shape"].object_in_area(player.position, positionZ) == true && positionZ > dict["platform"]:
			isInWall = true
			for n in range(5):
				player.position += -player.velocity/100
			player.velocity = -player.velocity/2
	return isInWall

func coyote_time(delta : float) -> void:
	var coyoteTimer = 0
	if hasJumped == false && isOnPlatform == false:
		coyoteTimer += delta
	else: 
		coyoteTimer = 0
	if (coyoteTimer < 1 && not coyoteTimer == 0):
		canCoyoteJump = true
	else: canCoyoteJump = false
