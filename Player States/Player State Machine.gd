extends Node

@export var initialState : State
@onready var player_jump = $PlayerJump

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
	#print(currentState)

func _physics_process(delta):
	if currentState:
		currentState.PhysicsUpdate(delta)
	player_jump.platform_Check()

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

func checkIfCanMove():
	return currentState.canMove

func checkIfCanDodge():
	return currentState.canDodge

func checkIfCanAttack():
	return currentState.canAttack

func checkIfCanJump():
	return currentState.canJump
