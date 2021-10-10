tool
extends Modifier

var p_array_count:int = 3 
var p_array_X_offset:float = 10.0
var p_array_Y_offset:float = 0 
var p_array_Z_offset:float = 0

func _get(property):
	if property == "modifier/array/count":
		return p_array_count
	if property == "modifier/array/X_offset":
		return p_array_X_offset
	if property == "modifier/array/Y_offset":
		return p_array_Y_offset
	if property == "modifier/array/Z_offset":
		return p_array_Z_offset

func _set(property, value):
	if property == "modifier/array/count":
		p_array_count = value
		prepare_modify()
		return true
	if property == "modifier/array/X_offset":
		p_array_X_offset = value
		prepare_modify()
		return true
	if property == "modifier/array/Y_offset":
		p_array_Y_offset = value
		prepare_modify()
		return true
	if property == "modifier/array/Z_offset":
		p_array_Z_offset = value
		prepare_modify()
		return true

func _get_property_list():
	var property_list:Array = []
	
	property_list.append(generate_property("modifier/array/count", TYPE_INT))
	property_list.append(generate_property("modifier/array/X_offset", TYPE_REAL))
	property_list.append(generate_property("modifier/array/Y_offset", TYPE_REAL))
	property_list.append(generate_property("modifier/array/Z_offset", TYPE_REAL))
	
	return property_list

func rename_node() -> void:
	name = "Modifier_Array"

func modify() -> void:
	# Build the array
	if(get_child_count() > default_children_number):
		var origin:Vector3 = transform.origin
		for i in range(1, p_array_count):
			for node in get_children():
				if is_valid_node(node):
					var duplicated_node:Spatial = node.duplicate()
					
					if(duplicated_node is Modifier):
						duplicated_node.p_renamable = true
					duplicated_node.name = (duplicated_node.name + "_ARRAY_ROW" + 
						str(i + 1))
					create_temporary_node(self, duplicated_node)
					
					var saved_rotation = duplicated_node.rotation
					duplicated_node.rotation = Vector3()
					
					var saved_scale = duplicated_node.scale
					duplicated_node.scale = Vector3(1, 1, 1)
					
					duplicated_node.translate(Vector3(p_array_X_offset * i, 
						p_array_Y_offset * i,
						p_array_Z_offset * i))
					
					duplicated_node.rotation = saved_rotation
					duplicated_node.scale = saved_scale
