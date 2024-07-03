extends Label


@onready var enemy_state_machine = $"../Enemy State Machine"



func _process(delta):
	self.text = "State: " + enemy_state_machine.currentState.name
