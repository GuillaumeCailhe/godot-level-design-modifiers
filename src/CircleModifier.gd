tool
extends Modifier

var p_radius:float = 10.0 
var p_rotate_towards_origin:bool = true 
var p_invert_rotation:bool = false 

func _get(property):
	if property == "modifier/circle/radius":
		return p_radius
	if property == "modifier/circle/rotate_towards_origin":
		return p_rotate_towards_origin
	if property == "modifier/circle/invert_rotation":
		return p_invert_rotation

func _set(property, value):
	if property == "modifier/circle/radius":
		p_radius = abs(value)
		prepare_modify()
		return true
	if property == "modifier/circle/rotate_towards_origin":
		p_rotate_towards_origin = value
		prepare_modify()
		return true
	if property == "modifier/circle/invert_rotation":
		p_invert_rotation = value
		prepare_modify()
		return true

func _get_property_list():
	var property_list:Array = []
	
	property_list.append(generate_property("modifier/circle/radius", TYPE_REAL))
	property_list.append(generate_property("modifier/circle/rotate_towards_origin", 
		TYPE_BOOL))
	property_list.append(generate_property("modifier/circle/invert_rotation", 
		TYPE_BOOL))
	
	return property_list

func rename_node() -> void:
	name = "Modifier_Circle"

func modify() -> void:
	# Get how much of an angle objects will be spaced around the circle.
	# Angles are in radians so 2.0*PI = 360 degrees
	if(get_child_count() > default_children_number + 1):
		var angle_step:float = 2.0 * PI / (get_child_count() - default_children_number)
		var angle:float = 0

		# For each node to spawn
		for node_to_move in get_children():
			if is_valid_node(node_to_move):
				# Translation
				var direction:Vector3 = Vector3(cos(angle), 0 ,sin(angle))
				var position:Vector3 = direction * p_radius
				position = Vector3(position.x, 0, position.z)
				
				node_to_move.translate(position)
				
				# Rotation
#				node_to_move.rotation_degrees = Vector3(rotation_degrees.x, 
#						0, rotation_degrees.z)

				if(p_rotate_towards_origin):
					# look_at() locally
					var new_rotation:float = (
						transform.basis.z.angle_to(node_to_move.translation))
					
					if(node_to_move.translation.x < 0):
						node_to_move.rotate_y(-new_rotation)
					else:
						node_to_move.rotate_y(new_rotation)

					if(p_invert_rotation):
						node_to_move.rotate_y(deg2rad(180))
			
				# Rotate one step
				angle += angle_step
