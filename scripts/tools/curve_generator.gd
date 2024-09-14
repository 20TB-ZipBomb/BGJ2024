@tool
extends EditorScript

## Number of curves for the script to generate.
const NUMBER_OF_CURVES_TO_GENERATE: int = 1

## Minimum and maximum number of points on each curve.
const MIN_NUMBER_OF_POINTS_PER_CURVE = 5
const MAX_NUMBER_OF_POINTS_PER_CURVE = 10

## Position parameters for each point generated on each curve.
const X_MIN: int = -10
const X_MAX: int =  10
const Y_POS: int =  1
const Z_MIN: int = -10
const Z_MAX: int =  10

## Bake interval parameters for each curve.
const MIN_BAKE_INTERVAL: int = 2
const MAX_BAKE_INTERVAL: int = 100

## Output directory for generated curve resources.
const OUTPUT_DIR = "res://resources/generated/"


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	Log.info("--- jake's wicked curve generator © 2024 all rights reserved (⌐■_■) ---")
	Log.debug("Creating [b]%d[/b] curves with the following params:" % NUMBER_OF_CURVES_TO_GENERATE)
	Log.debug("\t[b]Minimum Number of Points per Curve:[/b] %d" % MIN_NUMBER_OF_POINTS_PER_CURVE)
	Log.debug("\t[b]Maximum Number of Points per Curve:[/b] %d" % MAX_NUMBER_OF_POINTS_PER_CURVE)
	Log.debug("\t[b]Positon:[/b]")
	Log.debug("\t\tX_MIN: %d\tX_MAX: %d" % [X_MIN, X_MAX])
	Log.debug("\t\tY_POS: %d" % Y_POS)
	Log.debug("\t\tZ_MIN: %d\tZ_MAX: %d" % [Z_MIN, Z_MAX])
	Log.debug("\t[b]Bake Interval:[/b]")
	Log.debug("\t\tMinimum: %d" % MIN_BAKE_INTERVAL)
	Log.debug("\t\tMaximmum: %d" % MAX_BAKE_INTERVAL)
	
	# Generate curves
	var curves: Array[Curve3D] = []
	for curve_index in NUMBER_OF_CURVES_TO_GENERATE:
		var new_curve = Curve3D.new()
		new_curve.bake_interval = randi_range(10, 100)
		var point_count = randi_range(MIN_NUMBER_OF_POINTS_PER_CURVE, MAX_NUMBER_OF_POINTS_PER_CURVE)
		for i in point_count:
			var position: Vector3 = random_vector3_xz_in_range(X_MIN, X_MAX, Z_MIN, Z_MAX)
			# @TEST: We can change the 'in'/'out' params of the curve here if we want
			new_curve.add_point(position)
		curves.append(new_curve)

	# Export resources
	var succeded = true
	for i in curves.size():
		var curve_resource_path = "%s%s_%d.tres" % [OUTPUT_DIR, "tornado_curve", i]		
		var save_result = ResourceSaver.save(curves[i], curve_resource_path)
		if save_result != OK:
			Log.error("ResourceSaver.save encountered an error: %s" % error_string(save_result), false)
			succeded = false
			return
		
	if succeded:	
		Log.warn("Curves have been regenerated in %s, please restart the editor to ensure the curve assets are reloaded from disk." % OUTPUT_DIR)


## Spins a random Vector3 with the x and z components randomized in a set range.
## For this script, the y component is currently left constant since tornadoes won't move on the y-axis.
func random_vector3_xz_in_range(x_min: int, x_max: int, z_min: int, z_max: int) -> Vector3:
	return Vector3(randi_range(x_min, x_max), Y_POS, randi_range(z_min, z_max))
