class_name InventorySlot # This class represents an inventory slot in the game.
extends PanelContainer
@export var type : ItemData.Type # This is the type of item that this slot can hold.

# This function initializes the inventory slot with a specific type and minimum size.
func init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms

	# This function checks if a specific item can be dropped into this slot.
func _can_drop_data(at_position: Vector2, data: Variant):
	if !(data is InventoryItem): # If the data is not an inventory item, return false.
		return false

	if type != ItemData.Type.MAIN: # If the type of the slot is not MAIN, return false.
		return false

	if get_child_count() == 0: # If the slot is empty, return true.
		return true

	if type == data.get_parent().type: # If the type of the slot matches the parent type of the data, return true.
		return true
		
# If none of the above conditions are met, check if the type of the first child's data matches the data's type.
	return get_child(0).data.type == data.data.type 
	
# This function handles dropping an item into this slot.
func _drop_data(at_position: Vector2, data: Variant):
	if get_child_count() > 0: # If the slot is not empty...
		var item := get_child(0) # Get the first child.
		if item == data:  # If the item is the same as the data, return.
			return
		item.reparent(data.get_parent()) # Otherwise, reparent the item to the parent of the data.
	data.reparent(self) # Reparent the data to this slot.

