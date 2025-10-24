@tool
@icon("res://addons/codeburger_scene_tree_folder/folder.svg")
class_name Folder
extends Node
## A Folder is a [Node] that can be used to organize the scene tree by 
## instantiating a Folder in a scene and making other nodes children of the Folder.
## All of the built-in properties have been disabled.


func _validate_property(property: Dictionary) -> void:
	property.usage = PROPERTY_USAGE_NONE
