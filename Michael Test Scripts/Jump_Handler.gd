class_name JumpHandler
extends Node

var playerZ : float = 0
var ZFloor : float = 0
var newMaxJumpHiegt = -75

@export var ZSpeed : float = -3
@export var ZGravity : float = 5
@export var maxJumpHiegt = -50

var ZJump : bool = false
var ZFall : bool = false
var isOnPlatform : bool = true
func _process(delta):
	print (ZFall, ZJump)
func handleJump(player : Player, jumpPressed : bool, delta : float) -> void:
	if jumpPressed || ZJump == true:
		newMaxJumpHiegt = ZFloor - maxJumpHiegt
		ZJump=true
		ZFall = false
		playerZ += ZSpeed
		player.position.y += ZSpeed

	if playerZ <= newMaxJumpHiegt || ZFall == true: 
		ZJump = false
		ZFall = true
		playerZ += ZGravity
		player.position.y += ZGravity
	
	if isOnPlatform == true && ZJump == false:
		ZFall = false
		playerZ = ZFloor
	else: 
		ZFall = true
	
	
