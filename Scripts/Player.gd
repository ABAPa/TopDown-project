class_name Player
extends CharacterBody2D

@onready var input_handler = $Input_Handler as InputHandler
@onready var movement_handler = $Movement_Handler as MovementHandler


func _physics_process(delta):
	#GameManager.applyGravity(self, delta)
	#movement_handler.handleMovement(self, input_handler.getPlayerMove(), input_handler.getPlayerMoveFB(), delta)
	#movement_handler.handleRoll(self, input_handler.getPlayerMove(), input_handler.getPlayerMoveFB(), input_handler.getPlayerRoll(), delta)
	#jump_handler.handleJump(self, input_handler.getPlayerJump(), delta)
	
	velocity.normalized()
	move_and_slide()
	
