extends State
class_name PlayerDodgeRoll

@onready var player_state_machine = $".."
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
@onready var player_attack = $"../PlayerAttack"

@export var player : CharacterBody2D

var movementVector = Vector2()
var dodgeRoll : bool

@export_category("Dodge Roll Rates")
@export var dodgeSpeed : float = 60
@export var dodgeDeAccel : float = 5

@export_category("Dodge Roll Speeds")
@export var maxDeAccel : float = 70
@export var maxDodgeSpeed : float = 250
var mouseDirectionVector : Vector2
@export var dodgeReady : bool = true

var rollTimeout = true

func Enter():
	dodgeRoll = input_handler.getPlayerRoll()


func PhysicsUpdate(delta : float):
	handleDodgeRoll(delta)


func handleDodgeRoll(delta : float):
	if dodgeRoll && rollTimeout && dodgeReady == true:
		$RollCooldown.start()
		dodgeReady = false
		rollTimeout = false
		player.velocity = Vector2.ZERO
		animatedSprite2D.play("roll")
		player.velocity = lerp(player.velocity, player.playerMouseDifference().normalized() * maxDodgeSpeed, dodgeSpeed * delta)
		await get_tree().create_timer(0.5).timeout
		rollTimeout = true
		player.velocity = lerp(player.velocity, player.playerMouseDifference().normalized() * maxDeAccel, dodgeDeAccel * delta)
		handleDodgeSwitch()

func handleDodgeSwitch():
	movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0 && player_state_machine.checkIfCanMove():
		Transitioned.emit(self, "PlayerRun")
	else: 
		Transitioned.emit(self, "PlayerIdle")
	if input_handler.getPlayerAttack() && player_state_machine.checkIfCanAttack():
		Transitioned.emit(self, "PlayerAttack")


func _on_roll_cooldown_timeout():
	dodgeReady = true
