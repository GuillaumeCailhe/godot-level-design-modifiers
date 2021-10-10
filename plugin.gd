tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"ArrayModifier",
		"Spatial",
		preload("src/ArrayModifier.gd"), 
		preload("icon.png")
	)
	
	add_custom_type(
		"CircleModifier",
		"Spatial",
		preload("src/CircleModifier.gd"), 
		preload("icon.png")
	)
	
	add_custom_type(
		"MirrorModifier",
		"Spatial",
		preload("src/MirrorModifier.gd"), 
		preload("icon.png")
	)
	
	add_custom_type(
		"RandomizeModifier",
		"Spatial",
		preload("src/RandomizeModifier.gd"), 
		preload("icon.png")
	)

func _exit_tree():
	remove_custom_type("ArrayModifier")
	remove_custom_type("CircleModifier")
	remove_custom_type("MirrorModifier")
	remove_custom_type("RandomizeModifier")
