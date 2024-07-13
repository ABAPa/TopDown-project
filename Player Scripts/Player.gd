class_name Player
extends CharacterBody2D

@onready var gui = $GUI
var panel
func _ready():
	panel = gui.get_child(1)
func _physics_process(_delta):
	print(panel.get_item_data())
	velocity.normalized()
	move_and_slide()

func playerMouseDifference() -> Vector2:
	var mouseVector = get_global_mouse_position() - self.position
	return mouseVector
