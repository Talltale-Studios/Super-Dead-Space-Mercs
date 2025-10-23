@tool
extends Node
## BetterPrint provides a few functions to make print outputs to the console
## look a little bit better and provide more information (like timestamps and
## script names), while keeping the syntax simple.


#region Public Variables

var _output_colors:Dictionary = {
	"NORMAL":"white",
	"NOTE":"silver",
	"WARNING":"yellow",
	"ERROR":"red",
	"QUESTION":"green",
	"TODO":"orange",
	"MEASURE":"cyan"}
	
var _measure_ids:Dictionary ={}

var _TYPE_PADDING:int = 8

#endregion


#region Plugin Setup

func _enter_tree():
	custom("Thank you for trying out BetterPrint. Look at the help file to see how it is used: res://addons/better_print/BetterPrint.html", self, "THANK YOU")

#endregion


#region Print Functions

func variable(variable_name:String, caller:Object, message_type:String = "NORMAL"):
	if not OS.is_debug_build():
		return
		
	var concat_print:String = (
		_set_message_start(caller, _get_message_Type(message_type)) + 
		"[b]" + variable_name + "[/b] has a value of: " + 
		_get_variable_value_from_name(variable_name, caller) + "[/color]" + 
		_set_message_end())
		
	print_rich(concat_print)


func multi_variable(variable_names:Array[String], caller:Object, message_type:String = "NORMAL"):
	if not OS.is_debug_build():
		return
		
	var concat_variable:String
	
	for variable_name in variable_names:
		concat_variable += variable_name + " = " + _get_variable_value_from_name(variable_name, caller) + ", "
		
	concat_variable = concat_variable.substr(0, concat_variable.length() - 2)
		
	var concat_print:String = (
		_set_message_start(caller, _get_message_Type(message_type)) + 
		concat_variable + "[/color]" + 
		_set_message_end())
		
	print_rich(concat_print)


func message(message:String, caller:Object, message_type:String = "NORMAL"):
	if not OS.is_debug_build():
		return
		
	var concat_print:String = (
		_set_message_start(caller, _get_message_Type(message_type)) + 
		message + "[/color]" +
		_set_message_end())
		
	print_rich(concat_print)


func url(url:String, caller:Object, message_type:String = "NORMAL"):
	if not OS.is_debug_build():
		return
		
	var concat_print:String = (
		_set_message_start(caller, _get_message_Type(message_type)) + 
		"[url]" + url + "[/url][/color]" +
		_set_message_end())
		
	print_rich(concat_print)


func custom(message:String, caller:Object, message_type:String = "CUSTOM"):
	if not OS.is_debug_build():
		return
		
	var concat_print:String = (
		_set_message_start_custom(caller, message_type) + 
		message + "[/color]" +
		_set_message_end())
		
	print_rich(concat_print)

#endregion


#region Time Measure Functions

func start_measure(measure_name:String):
	_measure_ids["measure_name"] = Time.get_ticks_msec()
	
	
func end_measure(measure_name:String, caller:Object):
	if not _measure_ids.has("measure_name"):
		message("No starting point for measure found.", caller, "ERROR")
		return
		
	var concat_print:String = (
		_set_message_start(caller, "MEASURE") + 
		"Time needed to execute [b]" + measure_name + "[/b]:[b] " +
		_get_delta_time() + "[/b] milliseconds[/color]" + 
		_set_message_end())
	
	_measure_ids.erase("measure_name")
	
	print_rich(concat_print)


func _get_delta_time() -> String:
	return str(Time.get_ticks_msec() - _measure_ids["measure_name"])

#endregion


#region Formatting Functions

func _get_formatted_timestamp() -> String:
	var time:Dictionary = Time.get_datetime_dict_from_system()
	
	return "[%02d.%02d.%04d - %02d:%02d:%02d]" % [
		time.day, time.month, time.year,
		time.hour, time.minute, time.second
	]
	
	
func _get_script_name(caller:Object) -> String:
	if caller == null:
		return ""
		
	var script = caller.get_script()
	var script_name:String = script.resource_path.get_file()
	
	return script_name
	
	
func _get_variable_value_from_name(variable_name:String, caller:Object) -> String:
	if caller == null:
		return "'set self as second argument'"
	
	if caller.get(variable_name) != null:
		return str("[b]" + str(caller.get(variable_name)) + "[/b]")
			
	return "doesn't exist"
	
	
func _set_message_start(caller:Object, type:String) -> String:
	return ("[color=silver]" + _get_formatted_timestamp() + "[/color] " +
	"[color=white]" + _get_script_name(caller) + "[/color] - " +
	"[color=" + _output_colors[type] + "][b]" + type + "[/b]\n")
	
	
func _set_message_start_custom(caller:Object, type:String) -> String:
	return ("[color=silver]" + _get_formatted_timestamp() + "[/color] " +
	"[color=white]" + _get_script_name(caller) + "[/color] - " +
	"[color=purple][b]" + type + "[/b]\n")
	
	
func _set_message_end() -> String:
	return ("\n" + "-".repeat(64))

#endregion


#region Other Functions

func _get_message_Type(message_type:String) -> String:
	var type:String = message_type.to_upper()
	
	if _output_colors.has(type) == null:
		type = "NORMAL"
		
	return type

#endregion
