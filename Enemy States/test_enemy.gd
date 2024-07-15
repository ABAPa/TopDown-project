extends CharacterBody2D
class_name TestEnemy

var player : Player
@onready var enemy_follow = $"Enemy State Machine/EnemyFollow"
@onready var ray_cast_2d = $RayCast2D


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	ray_cast_2d.enabled = true
	ray_cast_2d.collide_with_areas = true

func _physics_process(_delta):
	velocity.normalized()
	move_and_slide()
	handleLineOfSight()

func playerEnemyDifference() -> Vector2:
	var playerdifferenceVector = player.position - self.position
	return playerdifferenceVector

func handleLineOfSight():
	ray_cast_2d.target_position = playerEnemyDifference()
	if ray_cast_2d.is_colliding() && ray_cast_2d.get_collider().name == "HurtboxHandler":
		enemy_follow.lineOfSight = true
	else:
		enemy_follow.lineOfSight = false


