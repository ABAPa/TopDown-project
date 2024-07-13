extends EnemyState

@export var enemy : CharacterBody2D
@onready var enemy_follow = $"../EnemyFollow"
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"
var isAttacking
var enemyLungeSpeed : float = 10
var backingAway : bool = false
func Enter():
	pass

func PhysicsUpdate(delta : float):
	handleEnemyAttack()


func handleEnemyAttack():
	var direction = enemy.playerEnemyDifference()
	if direction.length() < 50 && enemy_follow.lineOfSight == true && backingAway == false:
		print("ahhhhhhhhh")
		isAttacking = true
		enemy.velocity = Vector2.ZERO
		#enemy.velocity = direction.normalized() * enemyLungeSpeed
		animated_sprite_2d.play("attack")
		await get_tree().create_timer(.7).timeout
		backingAway = true
		isAttacking = false
	if (direction.length() < 10 && isAttacking == false) or backingAway == true:
		backingAway = true
		enemy.velocity = direction.normalized() * enemyLungeSpeed * -7.5
		await get_tree().create_timer(.3).timeout
		backingAway = false
		
	
	if direction.length() < 200 && direction.length() > 60 && enemy_follow.lineOfSight == true && (isAttacking == false and backingAway == false):
		EnemyTransitioned.emit(self, "EnemyFollow")
	elif direction.length() < 200 && direction.length() > 60 && enemy_follow.lineOfSight == false && (isAttacking == false and backingAway == false):
		EnemyTransitioned.emit(self, "EnemyIdle")
	else: return
	
