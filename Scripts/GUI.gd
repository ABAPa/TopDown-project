extends CanvasLayer
var InvSize = 16
var itemsLoad = [
	"res://Items(Resourses)/Axe.tres",
	"res://Items(Resourses)/Sword.tres"
]
func _ready():
	self.visible = false
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(64, 64))
		%Inv.add_child(slot)
	for i in itemsLoad.size():
		var item := InventoryItem.new()
		item.init(load(itemsLoad[i]))
		%Inv.get_child(i).add_child(item)
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		self.visible = !self.visible
