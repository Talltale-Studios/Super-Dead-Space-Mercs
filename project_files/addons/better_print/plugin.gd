@tool
extends EditorPlugin

###################################################################################################
# Variable declaration
###################################################################################################

var editor_panel = null

###################################################################################################
# Game loop
###################################################################################################

func _enter_tree():
	add_autoload_singleton("BetterPrint", "res://addons/better_print/better_print.gd")
	
	
func _exit_tree():
	remove_autoload_singleton("BetterPrint")
