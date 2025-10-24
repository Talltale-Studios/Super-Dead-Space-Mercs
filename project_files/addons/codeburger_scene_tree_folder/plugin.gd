@tool
extends EditorPlugin


var inspector_plugin: EditorInspectorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("Folder", "Resource", preload("folder.gd"), preload("folder.svg"))
	
	inspector_plugin = preload("inspector_plugin.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("Folder")
	remove_inspector_plugin(inspector_plugin)
