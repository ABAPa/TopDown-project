extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	self.position =Vector2(400,300)


