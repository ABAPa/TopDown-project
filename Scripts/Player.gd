class_name Player
extends CharacterBody2D

@onready var sprite_2d = $Sprite2D as Sprite2D
#@onready var animation_player = $AnimationPlayer as AnimationPlayer

@onready var input_handler = $Input_Handler as InputHandler
@onready var movement_handler = $Movement_Handler as MovementHandler
@onready var jump_handler = $Jump_Handler as JumpHandler

#func _ready():
	#SignalBus.emitOnPlayerReady(self)
func _physics_process(delta):
	#GameManager.applyGravity(self, delta)
	movement_handler.handleMovement(self, input_handler.getPlayerMove(), delta)
	movement_handler.handleMovementFB(self, input_handler.getPlayerMoveFB(), delta)
	#jump_handler.handleJump(self, input_handler.getPlayerJump(), delta)
	
	velocity.normalized()
	move_and_slide()
	
