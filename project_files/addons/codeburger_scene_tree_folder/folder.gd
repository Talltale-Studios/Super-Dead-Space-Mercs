@tool
@icon("res://addons/codeburger_scene_tree_folder/folder.svg")
class_name Folder
extends Node
## Folders can be used to organize the scene tree by making instantiating a Folder
## in a scene and making other nodes children of the Folder.


func _validate_property(property: Dictionary) -> void:
	property.usage = PROPERTY_USAGE_NONE
