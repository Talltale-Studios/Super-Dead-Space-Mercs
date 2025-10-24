@tool
extends EditorInspectorPlugin


var _properties: Array[String] = []


func _can_handle(object: Object) -> bool:
	return object is Folder


func _parse_begin(object: Object) -> void:
	var label = Label.new()
	label.text = "This node is a Folder for organizing the scene tree.\n All properties are disabled."
	add_custom_control(label)


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	return true
