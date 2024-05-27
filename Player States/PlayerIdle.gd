extends State
class_name PlayerIdle

@onready var animatedSprite2D = $"../../AnimatedSprite2D"
@onready var input_handler = $"../../Input_Handler"
var movementVector = Vector2()



func Enter():
	animatedSprite2D.play("idle")

func PhysicsUpdate(delta : float):
	movementVector = Vector2(input_handler.getPlayerMove(), input_handler.getPlayerMoveFB())
	if movementVector.length() > 0:
		Transitioned.emit(self, "PlayerRun")
