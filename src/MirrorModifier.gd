tool
extends Modifier

var p_mirror_axis:int = Axis.X 

func _get(property):
	if property == "modifier/mirror/axis":
		return p_mirror_axis

func _set(property, value):
	if property == "modifier/mirror/axis":
		p_mirror_axis = value
		prepare_modify()
		return true

func _get_property_list():
	var property_list:Array = []
	
	property_list.append(generate_property_enum("modifier/mirror/axis", Axis))
	return property_list
func rename_node() -> void:
	name = "Modifier_Mirror" 
	
func modify() -> void:
	if(get_child_count() > default_children_number):
		var children:Array = get_children()
		for node in children:
			if(is_valid_node(node)):
				var duplicated_node:Spatial = node.duplicate()
				if(duplicated_node is Modifier):
					duplicated_node.p_renamable = true
				duplicated_node.name = node.name + "_MIRRORED"
				
				create_temporary_node(self, duplicated_node)
				
				match(p_mirror_axis):
					Axis.X:
						duplicated_node.translation.x *= -1
						duplicated_node.rotation.y *= -1
						duplicated_node.rotation.z *= -1
						duplicated_node.scale.x *= -1
					Axis.Y:
						duplicated_node.scale *= Vector3(-1, -1, -1)
						duplicated_node.rotation.y -= deg2rad(180)
					Axis.Z:
						duplicated_node.translation.z *= -1
						duplicated_node.rotation.x *= -1
						duplicated_node.rotation.y *= -1
						duplicated_node.scale.z *= -1
