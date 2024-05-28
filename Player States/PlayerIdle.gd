extends State
class_name PlayerIdle

@onready var player_state_machine = $".."
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
@onready var player_run = $"../PlayerRun"
@export var player : CharacterBody2D
@onready var player_dodge_roll = $"../PlayerDodgeRoll"

var movementVector = Vector2()

func Enter():
	animatedSprite2D.play("idle")

func PhysicsUpdate(delta : float):
	handleIdle(delta)

func handleIdle(delta : float):
	#print("I am idle")
	movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0 && player_state_machine.checkIfCanMove():
		Transitioned.emit(self, "PlayerRun")
	elif movementVector.length() == 0:
		player.velocity.x = lerp(player.velocity.x, 0.0, player_run.deaccelerationSpeed * delta)
		player.velocity.y = lerp(player.velocity.y, 0.0, player_run.deaccelerationSpeed * delta)
	if input_handler.getPlayerRoll() && player_state_machine.checkIfCanDodge():
		Transitioned.emit(self, "PlayerDodgeRoll")
