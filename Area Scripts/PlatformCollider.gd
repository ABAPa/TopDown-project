extends Area2D
class_name  PlatformCollider

var boddiesInScene : Array = ["Player"]
@export var colliderZ : float
var collider
func _ready():
	connect("body_entered", Callable(self, "on_collider"))
	connect("body_exited", Callable(self, "off_collider"))
	collider = self.get_child(0)
func on_collider(body):
	if body.name in boddiesInScene:
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		# Send the constant to the body's script
		child.colliderZ = colliderZ
		child.colliderBody = collider.get_rid()
		child.isInColliderArea = true
func off_collider(body):
	if body.name in boddiesInScene:
		var child = body.get_node("PlayerStateMachine/PlayerJump")
		# Send the constant to the body's script
		PhysicsServer2D.body_remove_collision_exception(collider.get_rid(), body.get_rid())
		child.isInColliderArea = false
