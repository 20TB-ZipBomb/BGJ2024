extends Object
class_name FileHelper

## Fetches the name for all files in the provided directory.
static func get_files_in_directory(path) -> Array[String]:
	var dir = DirAccess.open(path)
	
	# Bail out early if we fail to open the provided directory
	if not dir:
		Log.error("An error occurred when trying to access the path.")
		return []

	var files: Array[String] = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Add the file name to the list if we don't encounter a directory
		if not dir.current_is_dir():
			files.append(file_name)
			
		# Iterate to the next file name
		file_name = dir.get_next()
	
	return files
