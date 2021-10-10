tool
extends Spatial
class_name Modifier


"""
Modifiers are non destructive operators on nodes.
"""
# General variables
var default_children_number:int = 0
var p_saved_transforms:Dictionary

var temporary_nodes:Array

enum Axis {X, Y, Z}


# General properties
var p_update_modifier:bool = false
var p_active:bool = false
var p_renamable:bool = false 
var p_apply:bool = false

"""
Properties
"""
# General
func _get(property):
	if property == "modifier/active":
		return p_active
	if property == "modifier/update_modifier":
		return p_update_modifier
	if property == "modifier/renamable":
		return p_renamable
	if property == "modifier/saved_transforms":
		return p_saved_transforms
	
	if property == "modifier/apply/apply_modifier":
		return p_apply

func _set(property, value):
	if property == "modifier/active":
		p_active = value
		if(p_active):
			save_transform()
		prepare_modify()
		return true
	if property == "modifier/update_modifier":
		p_update_modifier = false
		prepare_modify()
		return true
	if property == "modifier/renamable":
		p_renamable = value
		rename_node()
		return true
	if property == "modifier/saved_transforms":
		p_saved_transforms = value
		return true
	if property == "modifier/apply/apply_modifier":
		p_apply = value
		apply()
		return true

func generate_property(name:String, type) -> Dictionary :
	return {
		"name": name,
		"type": type,
		"usage": PROPERTY_USAGE_DEFAULT, 
		"hint": PROPERTY_HINT_NONE
	}

func generate_property_noeditor(name:String, type) -> Dictionary:
	return {
		"name": name,
		"type": type,
		"usage": PROPERTY_USAGE_NOEDITOR, 
		"hint": PROPERTY_HINT_NONE
	}

func generate_property_enum(name:String, enum_object) -> Dictionary:
	return {
		"name": name,
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT, 
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": PoolStringArray(enum_object.keys()).join(",")
	}

func _get_property_list():
	var property_list:Array = []
	property_list.append(generate_property("modifier/active", TYPE_BOOL))
	property_list.append(generate_property("modifier/update_modifier", TYPE_BOOL))
	property_list.append(generate_property("modifier/renamable", TYPE_BOOL))
	property_list.append(generate_property("modifier/apply/apply_modifier", TYPE_BOOL))
		
	property_list.append(generate_property_noeditor("modifier/saved_transforms",
		TYPE_DICTIONARY))
	
	return property_list

"""
Functions
"""
func _ready() -> void:
	if(p_apply):
		set_process(false)
		return
	
	# Deleting temporary nodes that might have been saved
	for child in get_children():
		if(child is Spatial and !p_saved_transforms.has(child.name)):
			remove_child(child)
			child.queue_free()
	
	# Updating
	if(p_active):
		prepare_modify()
	else:
		reset_transform()
	
	# Only run the script once in game
	if(!Engine.is_editor_hint()):
		set_process(false)

func rename_node() -> void:
	name = "Modifier"

func apply():
	if(p_apply == true):
		set_script(null)

func prepare_modify() -> void:
	if(!p_renamable):
		rename_node()
		
	# Reset duplicated nodes
	if(temporary_nodes.size() > 0):
		for duplicate in temporary_nodes:
			remove_child(duplicate)
			duplicate.queue_free()
	temporary_nodes = []

	reset_transform()
	
	if(p_active):
		modify()

# ABSTRACT
func modify():
	pass

func is_valid_node(node:Node) -> bool:
	return node is Spatial and !temporary_nodes.has(node)

func change_owner(node):
	if(node.get_owner() == null):
		node.set_owner(get_tree().edited_scene_root)
	for child in node.get_children():
		change_owner(child)

func create_temporary_node(parent_node:Node, node:Spatial) -> void:
	temporary_nodes.append(node)
	parent_node.add_child(node)

	if(Engine.is_editor_hint() and get_tree() != null):
		node.set_owner(get_tree().edited_scene_root)
		for child in node.get_children():
			if(child.get_owner() == null):
				child.set_owner(get_tree().edited_scene_root)

func save_transform():
	p_saved_transforms = {}
	for node in get_children():
		if(is_valid_node(node)):
			p_saved_transforms[node.name] = node.transform

func reset_transform():
	for node in get_children():
		if(is_valid_node(node) and p_saved_transforms.has(node.name)):
			node.transform = p_saved_transforms[node.name]
	
"""
Redrawing when a child is added/removed
"""
func add_child(node:Node, _legible_unique_name:bool = false) -> void:
	.add_child(node, _legible_unique_name)

	if is_valid_node(node):
		if(!p_saved_transforms.has(node.name)):
			p_saved_transforms[node.name] = node.global_transform
		call_deferred("prepare_modify")

func remove_child(node:Node) -> void:
	.remove_child(node)
	if is_valid_node(node):
		if(p_saved_transforms.has(node.name)):
			p_saved_transforms.erase(node.name)
			call_deferred("prepare_modify")
