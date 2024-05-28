extends State
class_name PlayerRun

@export_category("Player Variables")
@export var maxSpeed : float = 200
@export var accelerationSpeed : float = 4.75
@export var deaccelerationSpeed : float = 5.75

@onready var player_state_machine = $".."
@onready var input_handler = $"../../Input_Handler"
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
var movementVector = Vector2()
@export var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func PhysicsUpdate(delta : float):
	if input_handler.getPlayerRoll() && player_state_machine.checkIfCanDodge():
		Transitioned.emit(self, "PlayerDodgeRoll")
	handleMovement(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB(), delta)

func handleMovement(movementDirection : float, movementDirectionFB : float, delta : float) -> void:
	#print("running")
	movementVector = Vector2(movementDirection, movementDirectionFB)
	if movementVector.length() > 1:
		movementVector = movementVector.normalized()
	player.velocity.x = lerp(player.velocity.x, movementVector.x * maxSpeed, accelerationSpeed * delta)
	player.velocity.y = lerp(player.velocity.y, movementVector.y * maxSpeed, accelerationSpeed * delta)
	
	if movementVector.x != 0:
		animatedSprite2D.flip_h = movementVector.x < 0
		animatedSprite2D.play("run")
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, deaccelerationSpeed * delta) # Stop horizontal movement
	
	# add another if condition here when you get more animations for the 8 directions (same goes for above)
	if movementVector.y != 0:
		animatedSprite2D.play("run")
	else:
		player.velocity.y = lerp(player.velocity.y, 0.0, deaccelerationSpeed * delta) # Stop vertical movement
	
	if movementVector == Vector2.ZERO: #if player input !right/left
		Transitioned.emit(self, "PlayerIdle")
