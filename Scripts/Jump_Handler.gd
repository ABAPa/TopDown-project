class_name JumpHandler
extends Node

@export_category("Player Jump Variables")
@export var jumpVelocity : float = -425
@export var maxJumps : int = 2
@export var baseJumps : int = 1
@export var itemCollected : bool = false

@onready var movement_handler = $"../Movement_Handler" as MovementHandler
@onready var input_handler = $"../Input_Handler" as InputHandler
@onready var jump_handler = $"." as JumpHandler

var currentJumpsRemaining : int
var hasJumped : bool = false
var isJumping : bool = false
var antiGravity : float = 10000
var wallJumpVelocity : float = 425
var wallNormal
var isWallJumping : bool = false

var coyoteTimeCounter : float

var isPreparingJump : bool 
var jumpBuff : float = .15
var jumpBufferCounter : float

func handleJump(player : Player, jumpPressed : bool, delta : float) -> void:
	if player.is_on_floor() == true: #not Jumping
		if itemCollected:
			currentJumpsRemaining = maxJumps #turns on double jump
		else:
			currentJumpsRemaining = baseJumps #turns off double jump
		hasJumped = false #player has landed after jump
		isWallJumping = true # used to prevent wall jumping while on floor
		player.movement_handler.accelerationSpeed = 10
		player.movement_handler.maxSpeed = 325
	
	gravityScale(player)
	wallNormal = player.get_wall_normal() 
	coyoteTimeJump(player, jumpPressed, delta)
	jumpBuffer(player, delta)
	wallJump(player, jumpPressed)
	variableJump(player, delta)
	
func doJump(player : Player, jumpPressed : bool):
	if jumpPressed == true && currentJumpsRemaining > 0: #what happens when Jumping
		player.velocity.y = jumpVelocity
		hasJumped = true
		currentJumpsRemaining -= 1

func wallJump(player : Player, jumpPressed : bool) -> void:
	if player.is_on_wall():
		isWallJumping = false
	if input_handler.getPlayerJump() && wallNormal.x != 0 && !player.is_on_floor() && !isWallJumping:
		player.jump_handler.currentJumpsRemaining += 1
		doJump(player, jumpPressed)
		isWallJumping = true
		if wallNormal.x > 0:
			player.velocity.x = wallJumpVelocity
		if wallNormal.x < 0:
			player.velocity.x = wallJumpVelocity * -1

func variableJump(player : Player, delta : float) -> void:
	if player.velocity.y < 0 && hasJumped:
		isJumping = true
	else:
		isJumping = false
	
	if isJumping == true && player.velocity.y < 0 && Input.is_action_just_released("Jump"):
		player.velocity.y += antiGravity * delta

func gravityScale(player : Player) -> void:
	if hasJumped == true && player.velocity.y > 0:
		player.movement_handler.jumpHangTime()
		player.velocity.y += 15

func coyoteTimeJump(player : Player, jumpPressed : bool, delta : float) -> void:
	if !isJumping && !player.is_on_floor() && !player.is_on_wall():
		coyoteTimeCounter += delta
	else: coyoteTimeCounter = 0 
	if player.is_on_floor() || coyoteTimeCounter < .15 :
		doJump(player, jumpPressed)

func jumpBuffer(player : Player, delta : float) -> void:
	if player.input_handler.getPlayerJump() && !player.is_on_floor() && !player.is_on_wall():
		isPreparingJump = true
	if isPreparingJump:
		jumpBufferCounter += delta
		if player.is_on_floor() && jumpBufferCounter < jumpBuff:
			player.velocity.y = jumpVelocity
		if jumpBufferCounter > jumpBuff:
			isPreparingJump = false
			jumpBufferCounter = 0
