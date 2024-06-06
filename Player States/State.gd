extends Node
class_name State

signal Transitioned
@export var canMove : bool
@export var canDodge : bool
@export var canAttack : bool
@export var canJump : bool

func Enter():
	pass

func Exit():
	pass

func Update(_delta : float):
	pass

func PhysicsUpdate(_delta : float):
	pass
