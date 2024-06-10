extends EnemyState

@export var enemy : CharacterBody2D
@onready var enemy_follow = $"../EnemyFollow"
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"

var enemyLungeSpeed : float = 10

func Enter():
	pass

func PhysicsUpdate(delta : float):
	handleEnemyAttack()


func handleEnemyAttack():
	var direction = enemy.playerEnemyDifference()
	if direction.length() < 40 && enemy_follow.lineOfSight == true:
		enemy.velocity = Vector2.ZERO
		enemy.velocity = direction.normalized() * enemyLungeSpeed
		animated_sprite_2d.play("attack")
		await get_tree().create_timer(0.5).timeout
	if direction.length() < 100 && enemy_follow.lineOfSight == true:
		EnemyTransitioned.emit(self, "EnemyFollow")
	else: return
	
