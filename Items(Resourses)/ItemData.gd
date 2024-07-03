class_name ItemData
extends Resource

enum Type {HEAD, CHEST, LEGS, ARMS, WEAPON, ACCESSORY, CONSUMABLE, MAIN}

@export var type: Type
@export var item: String
@export_multiline var description: String
@export var texture: Texture2D
