extends PanelContainer
@onready var weapon_panel = $"."

var type : ItemData.Type = ItemData.Type.WEAPON # Add this line

func _ready(): 
	weapon_panel.size = Vector2(64, 64) # Set the minimum size of the weapon panel.
	weapon_panel.position = Vector2(400, 250) # Set the position of the weapon panel.
	
# This function checks if a specific item can be dropped into this panel.
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if !(data is InventoryItem): # If the data is not an inventory item, return false.
		return false

	if data.data.type != ItemData.Type.WEAPON: # If the item is not a weapon, return false.
		return false

	return true # If none of the above conditions are met, return true.

# This function handles dropping an item into this panel.
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0: # If the panel is not empty...
		var item := get_child(0) # Get the first child.
		if item == data:  # If the item is the same as the data, return.
			return
		item.reparent(data.get_parent()) # Otherwise, reparent the item to the parent of the data.
	data.reparent(self) # Reparent the data to this panel.

func get_item_data() -> ItemData:
	if get_child_count() > 0: # If the panel is not empty...
		var item := get_child(0) # Get the first child.
		return item.data # Return the data of the item.
	return null # If the panel is empty, return null.
