class_name MovementHandler
extends Node

@export_category("Player Variables")
@export var maxSpeed : float = 325.0
@export var accelerationSpeed : float = 10
@export var deaccelerationSpeed : float = 15

@export var turnRate: float =20
@export var turnSpeed: float =100

@export var jumpApexAccel : float = .75
@export var jumpMaxAccel : float = 1

@onready var input_handler = $"../Input_Handler" as InputHandler
@onready var jump_handler = $"../Jump_Handler" as JumpHandler

var timePassed : float
var slideMinimum

var slideSpeed : float = 500

func handleMovement(player : Player, movementDirection : float, delta : float) -> void:#if player input right
	if movementDirection < 0:
		player.velocity.x = lerp(player.velocity.x, -maxSpeed, accelerationSpeed * delta)#accelerate right
	
	if movementDirection > 0:#if player input left
		player.velocity.x = lerp(player.velocity.x, maxSpeed, accelerationSpeed * delta)#accelerate left
	
	if movementDirection == 0:#if player input !right/left
		player.velocity.x = lerp(player.velocity.x, 0.0, deaccelerationSpeed * delta)#deaccelorate
	#now foy y
	handleTurnSpeed(player, delta)#when player moves in opposite direction of velocity.x, increase velocity
	wallSliding(player, delta)#when moving into wall, moving down, and not on floor, slide down

func handleMovementFB(player : Player, movementDirection : float, delta : float) -> void:#if player input right
	#now foy y
	if movementDirection < 0:
		player.velocity.y = lerp(player.velocity.y, -maxSpeed, accelerationSpeed * delta)#accelerate right
	
	if movementDirection > 0:#if player input left
		player.velocity.y = lerp(player.velocity.y, maxSpeed, accelerationSpeed * delta)#accelerate left
	
	if movementDirection == 0:#if player input !right/left
		player.velocity.y = lerp(player.velocity.y, 0.0, deaccelerationSpeed * delta)#deaccelorate
	handleTurnSpeedFB(player, delta)#when player moves in opposite direction of velocity.x, increase velocity
	wallSliding(player, delta)#when moving into wall, moving down, and not on floor, slide down


func jumpHangTime() -> void:#when apex reached decrease x speed
	self.accelerationSpeed = jumpApexAccel * accelerationSpeed
	self.maxSpeed = maxSpeed * jumpMaxAccel

func wallSliding(player : Player, delta : float)-> void:
	if (!player.is_on_floor() && player.velocity.y > 0 && input_handler.getPlayerMove()) && player.is_on_wall():
		timePassed += delta#increase weight over time on above conditions
		slideMinimum = min(timePassed/ 2, 1 )
		player.velocity.y = lerp(75, 700, slideMinimum)#accelerate slide speed
			
	else: timePassed = 0#reset timer

func handleTurnSpeed(player : Player, delta : float) -> void:
	if player.velocity.x > 0 && input_handler.getPlayerMove() == -1 && !jump_handler.isWallJumping: #righttoleft
		player.velocity.x = lerp(player.velocity.x, -turnSpeed, turnRate * delta)
	if player.velocity.x < 0 && input_handler.getPlayerMove() == 1 && !jump_handler.isWallJumping: #lefttoright
		player.velocity.x = lerp(player.velocity.x, turnSpeed, turnRate * delta)
		#now y
	
func handleTurnSpeedFB(player : Player, delta : float) -> void:
		#now y
	if player.velocity.y > 0 && input_handler.getPlayerMove() == -1 && !jump_handler.isWallJumping: #righttoleft
		player.velocity.y = lerp(player.velocity.x, -turnSpeed, turnRate * delta)
	if player.velocity.y < 0 && input_handler.getPlayerMove() == 1 && !jump_handler.isWallJumping: #lefttoright
		player.velocity.y = lerp(player.velocity.x, turnSpeed, turnRate * delta)
