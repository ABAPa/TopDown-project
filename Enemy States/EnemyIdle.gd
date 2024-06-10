extends EnemyState
class_name EnemyIdle

@export var enemy : CharacterBody2D
@export var moveSpeed : float = 30
@onready var enemy_follow = $"../EnemyFollow"
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"

var moveDirection : Vector2
var wanderTime : float


func randomizeWander():
	moveDirection = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wanderTime = randf_range(1,3)

func Enter():
	randomizeWander()

func Update(delta : float):
	if wanderTime > 0:
		wanderTime -= delta
	else:
		randomizeWander()

func PhysicsUpdate(delta : float):
	if enemy:
		enemy.velocity = moveDirection * moveSpeed
	
	if moveSpeed == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
	
	
	var direction = enemy.playerEnemyDifference()
	
	if direction.length() < 100 && enemy_follow.lineOfSight == true:
		EnemyTransitioned.emit(self, "EnemyFollow")
	else: return
