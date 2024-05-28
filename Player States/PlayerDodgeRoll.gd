extends State
class_name PlayerDodgeRoll

@onready var player_state_machine = $".."
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
@export var player : CharacterBody2D
var dodgeRoll : bool
var movementVector = Vector2()

func Enter():
	dodgeRoll = input_handler.getPlayerRoll()

func PhysicsUpdate(delta : float):
	handleDodgeRoll(delta)


func handleDodgeRoll(delta : float):
	if dodgeRoll:
		movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
		player.velocity = movementVector * 1000 * delta
		
		
		animatedSprite2D.play("roll")
		await get_tree().create_timer(1).timeout
		dodgeRoll = false
	elif player_state_machine.checkIfCanMove():
		pass
