extends State
class_name PlayerJump

@export var player : CharacterBody2D

@onready var input_handler = $"../../Input_Handler"
@onready var player_run = $"../PlayerRun"

var playerZ : float = 0
var ZFloor : float = 0
var newMaxJumpHiegt : float = -100

@export var ZSpeed : float = -3
@export var ZGravity : float = 3
@export var maxJumpHiegt : float = -100

var ZFall : bool = false # gravity is on/off
var isOnPlatform : bool = true #tracks the number of platforms (PlatformTrigger area2ds) the player is on
var hasJumped : bool = false #has jumped, has not reached jump apex yet
var isOnStairs : bool = false #is on stairs trigger area2d
var areaZHieght : float # the Zhieght of the whole area (building or platform) a player is in the area2d of

var isInArea : bool

var colliderBody : RID 
var isInColliderArea : bool
var colliderZ : float

var totalHeight : float #total hieght of the stairs
var globalPosition : float #position of stairs area2D
var ZTop : float # top of stairs
var ZBottom : float #bottom of stairs

var ZFloors : Array = [0] #array for the ZHieght of each platform area2d the player is in


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(0.1).timeout
	ZFloors.erase(0)
func _process(delta):
	Z_sort()
	#print(playerZ, " playerZ", ZFloors.min(), " ZFloors", isOnPlatform)
	#print(ZFloor)
	if isOnStairs: 
		body_Position_On_Strairs(player, totalHeight, globalPosition, ZTop, ZBottom)
	if isInArea == true:
		_area_sides()
	if isInColliderArea == true:
		colliderException()
	
func PhysicsUpdate(delta : float):
	handleJump(delta) 
	player_run.handleMovement(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB(), delta) #need to be able to control movement while jumping
	platform_Check()
	#print(playerZ," Z, max ",newMaxJumpHiegt)
	
	
func handleJump(delta : float) -> void:
	if hasJumped: 
		playerZ += ZSpeed #add zspeed which is negative to make player go up
		player.position.y += ZSpeed #apply equally to the player.y
		
func platform_Check(): 
	if not ZFloors.is_empty() and playerZ == ZFloors.min():
		ZFloor= playerZ
		isOnPlatform = true
	else:
		isOnPlatform = false

	if isOnPlatform == true and hasJumped == false: #hasJumped == false and playerZ >= ZFloor and 
		ZFall = false
		playerZ = ZFloors.min()
		newMaxJumpHiegt = ZFloors.min() + maxJumpHiegt
		change_States()
	elif playerZ <= newMaxJumpHiegt or ZFall == true or isOnPlatform == false && hasJumped == false: 
		#print("fdssdf")
		hasJumped = false
		ZFall = true
		playerZ += ZGravity
		player.position.y += ZGravity
		
func change_States():
	var movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0:
		Transitioned.emit(self, "PlayerRun")
	else: Transitioned.emit(self, "PlayerIdle")
	
func body_Position_On_Strairs (body, totalHeight, globalPosition, ZTop, ZBottom):
		var distanceToBody = body.position.y - globalPosition
		var proportion = distanceToBody / totalHeight
		var bodyZ = lerp(ZBottom, ZTop, proportion)
		return bodyZ

func _area_sides():
	#print(playerZ )
	if playerZ > areaZHieght && not player.velocity.x == 0 && not isOnStairs && playerZ < ZFloor:
		player.velocity.x = -player.velocity.x /1.3

func colliderException():
	if playerZ <= colliderZ or hasJumped == true or ZFall == true && ZFloors.is_empty():
		PhysicsServer2D.body_add_collision_exception(colliderBody, player.get_rid())
	else: PhysicsServer2D.body_remove_collision_exception(colliderBody, player.get_rid())

func Z_sort():
	if playerZ <= areaZHieght or ZFloors.is_empty() && not ZFloors.min() == areaZHieght:
		player.z_index = 6
	else: player.z_index = 5
