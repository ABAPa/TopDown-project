extends State
class_name PlayerDodgeRoll

@onready var player_state_machine = $".."
@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
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

var rollTimeout = true

func Enter():
	dodgeRoll = input_handler.getPlayerRoll()

func PhysicsUpdate(delta : float):
	handleDodgeRoll(delta)


func handleDodgeRoll(delta : float):
	if dodgeRoll && rollTimeout:
		player.velocity = Vector2.ZERO
		rollTimeout = false
		var viewportCenter = Vector2(get_viewport().size) / 2
		mouseDirectionVector = get_viewport().get_mouse_position() - viewportCenter
		movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
		player.velocity = lerp(player.velocity, mouseDirectionVector.normalized() * maxDodgeSpeed, dodgeSpeed * delta)
		animatedSprite2D.play("roll")
		await get_tree().create_timer(0.5).timeout
		rollTimeout = true
		player.velocity = lerp(player.velocity, mouseDirectionVector.normalized() * maxDeAccel, dodgeDeAccel * delta)
		dodgeRoll = false
		
		if movementVector.length() > 0:
			Transitioned.emit(self, "PlayerRun")
		else: Transitioned.emit(self, "PlayerIdle")
