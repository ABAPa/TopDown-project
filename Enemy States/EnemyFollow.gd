extends EnemyState
class_name EnemyFollow

@export var enemy : CharacterBody2D
@export var moveSpeed : float = 80
@export var lineOfSight : bool = false
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"

var player : Player

func Enter(): # Maybe!?
	player = get_tree().get_first_node_in_group("Player")

func PhysicsUpdate(delta : float):
	handleEnemyFollow()
	
func handleEnemyFollow():
	var direction = enemy.playerEnemyDifference()
	
	if direction.length() < 200 && lineOfSight == true:
		enemy.velocity = direction.normalized() * moveSpeed
		animated_sprite_2d.play("walk")
	else: Vector2()
	
	if direction.length() < 30 && lineOfSight == true:
		EnemyTransitioned.emit(self, "EnemyAttack")
	
		
	if direction.length() >= 200 || lineOfSight == false:
		EnemyTransitioned.emit(self, "EnemyIdle")
	
