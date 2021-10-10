tool
extends Modifier

var p_randomize_seed:int = 0
var p_randomize_use_time_based_seed:bool = false

var p_randomize_X_position:float = 0.0
var p_randomize_Y_position:float = 0.0
var p_randomize_Z_position:float = 0.0

var p_randomize_X_rotation:float = 0.0
var p_randomize_Y_rotation:float = 0.0
var p_randomize_Z_rotation:float = 0.0

var p_randomize_scale_even:bool = false
var p_randomize_X_scale:float = 1.0
var p_randomize_Y_scale:float = 1.0
var p_randomize_Z_scale:float = 1.0

func _get(property):
	if property == "modifier/randomize/seed":
		return p_randomize_seed
	
	if property == "modifier/randomize/use_time_based_seed":
		return p_randomize_use_time_based_seed
	
	if property == "modifier/randomize/position/X_position":
		return p_randomize_X_position
	
	if property == "modifier/randomize/position/Y_position":
		return p_randomize_Y_position
	
	if property == "modifier/randomize/position/Z_position":
		return p_randomize_Z_position
	
	if property == "modifier/randomize/rotation/X_rotation":
		return p_randomize_X_rotation
		
	if property == "modifier/randomize/rotation/Y_rotation":
		return p_randomize_Y_rotation
		
	if property == "modifier/randomize/rotation/Z_rotation":
		return p_randomize_Z_rotation
	
	if property == "modifier/randomize/scale/scale_even":
		return p_randomize_scale_even
		
	if property == "modifier/randomize/scale/X_scale":
		return p_randomize_X_scale
	
	if property == "modifier/randomize/scale/Y_scale":
		return p_randomize_Y_scale
	
	if property == "modifier/randomize/scale/Z_scale":
		return p_randomize_Z_scale

func _set(property, value):
	if property == "modifier/randomize/seed":
		p_randomize_seed = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/use_time_based_seed":
		p_randomize_use_time_based_seed = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/position/X_position":
		p_randomize_X_position = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/position/Y_position":
		p_randomize_Y_position = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/position/Z_position":
		p_randomize_Z_position = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/rotation/X_rotation":
		p_randomize_X_rotation = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/rotation/Y_rotation":
		p_randomize_Y_rotation = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/rotation/Z_rotation":
		p_randomize_Z_rotation = value
		prepare_modify()
		return true
		
	if property == "modifier/randomize/scale/scale_even":
		p_randomize_scale_even = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/scale/X_scale":
		p_randomize_X_scale = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/scale/Y_scale":
		p_randomize_Y_scale = value
		prepare_modify()
		return true
	
	if property == "modifier/randomize/scale/Z_scale":
		p_randomize_Z_scale = value
		prepare_modify()
		return true

func rename_node() -> void:
	name = "Modifier_Randomize"

func _get_property_list():
	var property_list:Array = []
	
	property_list.append(generate_property("modifier/randomize/seed", TYPE_INT))
	property_list.append(generate_property("modifier/randomize/use_time_based_seed", 
		TYPE_BOOL))
	property_list.append(generate_property("modifier/randomize/position/X_position",
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/position/Y_position", 
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/position/Z_position", 
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/rotation/X_rotation",
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/rotation/Y_rotation", 
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/rotation/Z_rotation", 
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/scale/scale_even",
		TYPE_BOOL))
	property_list.append(generate_property("modifier/randomize/scale/X_scale",
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/scale/Y_scale", 
		TYPE_REAL))
	property_list.append(generate_property("modifier/randomize/scale/Z_scale", 
		TYPE_REAL))
	
	return property_list

func modify() -> void:
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	
	if(p_randomize_use_time_based_seed):
		rng.randomize()
	else:
		rng.seed = p_randomize_seed
	
	# Random transform
	if(get_child_count() > default_children_number):
		reset_transform()
		for node in get_children():
			if(is_valid_node(node)):
				# Translation
				var x_location:float = rng.randf_range(-p_randomize_X_position,
					p_randomize_X_position)
				var y_location:float = rng.randf_range(-p_randomize_Y_position,
					p_randomize_Y_position)
				var z_location:float = rng.randf_range(-p_randomize_Z_position,
					p_randomize_Z_position)
				

				node.translate(Vector3(x_location, y_location, z_location))
				
				# Rotation
				var x_rotation:float = rng.randf_range(-p_randomize_X_rotation,
					p_randomize_X_rotation)
				var y_rotation:float = rng.randf_range(-p_randomize_Y_rotation,
					p_randomize_Y_rotation)
				var z_rotation:float = rng.randf_range(-p_randomize_Z_rotation,
					p_randomize_Z_rotation)
				
				node.rotate_x(deg2rad(x_rotation))
				node.rotate_y(deg2rad(y_rotation))
				node.rotate_z(deg2rad(z_rotation))
				
				# Scale
				var x_scale:float  = get_random_scale_factor(rng, 
					p_randomize_X_scale)
				
				if (!p_randomize_scale_even):
					var y_scale:float  = get_random_scale_factor(rng, 
						p_randomize_Y_scale)
					var z_scale:float  = get_random_scale_factor(rng, 
						p_randomize_Z_scale)
					
					node.scale  *= Vector3(x_scale, y_scale, z_scale)
				else:
					node.scale  *= Vector3(x_scale, x_scale, x_scale)

func get_random_scale_factor(rng:RandomNumberGenerator, scale_range:float) -> float:
	if(scale_range == 1.0):
		return 1.0
	if(scale_range > 1.00001 ):
		return rng.randf_range(0, scale_range)
	else:
		var new_range:float = 1 - scale_range
		return rng.randf_range(1 - new_range, 1 + new_range)
