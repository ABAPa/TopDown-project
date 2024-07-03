extends Button

var tooltipsOn : bool

func _ready():
	self.set_visible(false)

func _process(_delta):
	needTools()

func needTools():
	if tooltipsOn == false && Input.is_action_just_pressed("Tooltips"):
		self.set_visible(true)
		tooltipsOn = true
	elif tooltipsOn == true && Input.is_action_just_pressed("Tooltips"):
		self.set_visible(false)
		tooltipsOn = false



func _on_pressed():
	get_tree().reload_current_scene()
