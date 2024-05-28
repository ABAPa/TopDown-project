extends RigidBody2D
class_name  PlatformCollider

@export var colliderZ : float

func _ready():
	max_contacts_reported = 5 #of contact it can report at once
	contact_monitor = true
	lock_rotation = true
	gravity_scale = 0
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	freeze = true
	connect("body_entered", Callable(self, "on_collider"))
	connect("body_exited", Callable(self, "off_collider"))
func on_collider(body):
	var child = body.get_node("Jump_Handler")
	# Send the constant to the body's script
	if child.playerZ >= colliderZ:    
		PhysicsServer2D.body_add_collision_exception(get_rid(), body.get_rid())
func off_collider(body):
	var child = body.get_node("Jump_Handler")
	
	# Send the constant to the body's script
	if child.playerZ >= colliderZ:   
		PhysicsServer2D.body_remove_collision_exception(get_rid(), body.get_rid())



