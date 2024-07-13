extends CanvasLayer
var InvSize = 16
var itemsLoad = [
	"res://Items(Resourses)/Axe.tres",
	"res://Items(Resourses)/Sword.tres"
]
func _ready():
	self.visible = false
	for i in InvSize:
		var slot := InventorySlot.new() # Create a new inventory slot.
		slot.init(ItemData.Type.MAIN, Vector2(64, 64)) # Initialize the slot with the MAIN type and a size of 64x64.
		%Inv.add_child(slot) # Add the slot as a child of the inventory.
	for i in itemsLoad.size(): # For each item to load...
		var item := InventoryItem.new() # Create a new inventory item.
		item.init(load(itemsLoad[i])) # Initialize the item with the loaded data.
		%Inv.get_child(i).add_child(item)  # Add the item as a child of the corresponding slot in the inventory.
func _process(delta):
	if Input.is_action_just_pressed("Inventory"): 
		self.visible = !self.visible

