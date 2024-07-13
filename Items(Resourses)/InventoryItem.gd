class_name InventoryItem # This class represents an inventory item in the game.
extends TextureRect

@export var data: ItemData

func init(d: ItemData) -> void: # This function initializes the inventory item with a specific data.
	data = d

func _ready(): 
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE # Set the expand mode of the texture rect.
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED # Set the stretch mode of the texture rect.
	texture = data.texture # Set the texture of the texture rect.
	tooltip_text = "%s\n%s" % [data.item, data.description] # Set the tooltip text of the texture rect.

# This function gets the drag data of this item.
func _get_drag_data(at_position: Vector2):
	set_drag_preview(make_drag_preview(at_position))
	return self

# This function makes a drag preview for this item.
func make_drag_preview(at_position: Vector2):
	var t := TextureRect.new()  # Create a new texture rect.
	t.texture = texture  # Set the texture of the texture rect.
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE # Set the expand mode of the texture rect.
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED # Set the stretch mode of the texture rect.
	t.custom_minimum_size = size # Set the minimum size of the texture rect.
	t.position = Vector2(-at_position) # Set the position of the texture rect.
	
	var c:= Control.new()
	c.add_child(t) # Add the texture rect as a child of the control.
	
	return c # Return the control.

