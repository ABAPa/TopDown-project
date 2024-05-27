class_name MovementHandler
extends Node

@export_category("Player Variables")
@export var maxSpeed : float = 200
@export var accelerationSpeed : float = 4.75
@export var deaccelerationSpeed : float = 5.75

@export_category("Player Roll")
@export var rollSpeed : float = 100
@export var rollaccel : float = 3
@export var isRolling : bool = false
var rollDuration : float = 20


@onready var animatedSprite2D = $"../AnimatedSprite2D"
@onready var input_handler = $"../Input_Handler"


var movementVector = Vector2()

func handleMovement(player : Player, movementDirection : float, movementDirectionFB : float, delta : float) -> void:
	movementVector = Vector2(movementDirection, movementDirectionFB)
	if movementVector.length() > 1:
		movementVector = movementVector.normalized()

	player.velocity.x = lerp(player.velocity.x, movementVector.x * maxSpeed, accelerationSpeed * delta)
	player.velocity.y = lerp(player.velocity.y, movementVector.y * maxSpeed, accelerationSpeed * delta)

	if movementVector.x != 0 && !isRolling:
		isRolling = false
		animatedSprite2D.flip_h = movementVector.x < 0
		animatedSprite2D.play("run")
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, deaccelerationSpeed * delta) # Stop horizontal movement

	if movementVector.y != 0 && !isRolling:
		isRolling = false
		animatedSprite2D.play("run")
	else:
		player.velocity.y = lerp(player.velocity.y, 0.0, deaccelerationSpeed * delta) # Stop vertical movement

	if movementVector == Vector2.ZERO && !isRolling: #if player input !right/left
		isRolling = false
		animatedSprite2D.play("idle")
	#print(player.velocity)

func handleRoll(player : Player, movementDirection : float, movementDirectionFB : float, dodgeRoll : bool, delta : float) -> void:
	movementVector = Vector2(movementDirection, movementDirectionFB).normalized()
	
	if dodgeRoll && !isRolling:
		isRolling = true
		animatedSprite2D.play("roll")
		player.velocity = movementVector * rollSpeed
		await get_tree().create_timer(rollDuration) # Assuming roll_duration is defined
		isRolling = false
	elif not isRolling:
		handleMovement(player, movementDirection, movementDirectionFB, delta)
	
	
	
