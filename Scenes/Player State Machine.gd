extends Node

@export var initialState : State

var currentState : State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(onChildTransition)
	
	if initialState:
		initialState.Enter()
		currentState = initialState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState:
		currentState.Update(delta)

func _physics_process(delta):
	if currentState:
		currentState.PhysicsUpdate(delta)

func onChildTransition(state, newStateName):
	if state != currentState:
		return
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.Exit()
	
	newState.Enter()
	
	currentState = newState
