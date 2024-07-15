extends Area2D
class_name TileMapZSort
var boddiesInScene : Array = ["Player"]
@export var areaZHieght : float
@export var areaZSort : int
var globalPositionBaseY
var parentShape
func _ready():
	if areaZSort == null: areaZSort = 0
	connect("area_entered", Callable(self, "on_Structure_Area"))
	connect("area_exited", Callable(self, "off_Structure_Area"))
	var globalPosition = self.get_child(0).global_position
	globalPositionBaseY = globalPosition.y - areaZHieght
	parentShape = self.get_parent()
func on_Structure_Area(area):
	var parent = area.get_parent()
	if parent.name in boddiesInScene && area.name == "HurtboxHandler":
		var child = parent.get_child(0).get_child(0)
		child.shapeDictionaries.append(parentShape.shapeDictionary)

func off_Structure_Area(area):
	var parent = area.get_parent()
	if parent.name in boddiesInScene && area.name == "HurtboxHandler":
		var child = parent.get_child(0).get_child(0)
		child.shapeDictionaries.erase(parentShape.shapeDictionary)

