extends EnemyState
class_name EnemyFollow

@export var enemy : CharacterBody2D
@export var moveSpeed : float = 80
@export var lineOfSight : bool = false

var player : Player

func Enter(): # Maybe!?
	player = get_tree().get_first_node_in_group("Player")

func PhysicsUpdate(delta : float):
	handleEnemyFollow()
	print(lineOfSight)
	
func handleEnemyFollow():
	var direction = enemy.playerEnemyDifference()
	
	if direction.length() < 100 && lineOfSight == true:
		enemy.velocity = direction.normalized() * moveSpeed
	else: Vector2()
	
	if direction.length() > 110 || lineOfSight == false:
		EnemyTransitioned.emit(self, "EnemyIdle")
