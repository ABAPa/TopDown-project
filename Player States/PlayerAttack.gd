extends State
class_name PlayerAttack

@onready var player_state_machine = $".."
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
@export var player : CharacterBody2D

var movementVector = Vector2()

@export_category("Light Attack Variables")
@export var lightAttack : bool
@export var maxAttackLunge : float = 200
@export var lungeRate : float = 30

var attackTimeout = true

func Enter():
	lightAttack = input_handler.getPlayerAttack()

func PhysicsUpdate(delta : float):
	handlePlayerAttack(delta)

func handlePlayerAttack(delta : float):
	if lightAttack && attackTimeout:
		input_handler.moveEnabled = false
		attackTimeout = false
		player.velocity = Vector2.ZERO
		animatedSprite2D.play("attack-right")
		player.velocity = lerp(player.velocity, player.playerMouseDifference().normalized() * maxAttackLunge, lungeRate * delta)
		await get_tree().create_timer(0.3).timeout
		player.velocity = lerp(player.velocity, player.playerMouseDifference().normalized() * 0, 20 * delta)
		input_handler.moveEnabled = true
		lightAttack = false
		attackTimeout = true
		handleAttackSwitch()

func handleAttackSwitch():
	movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0 && player_state_machine.checkIfCanMove():
		Transitioned.emit(self, "PlayerRun")
	else: 
		Transitioned.emit(self, "PlayerIdle")


