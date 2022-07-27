extends Node

const METHOD_GET_SAVE_DATA = "get_save_data"
const METHOD_LOAD_SAVE_DATA = "load_save_data"
const SAVE_FILEPATH = "user://grapplesquare.dat"

var saveable_objects: Dictionary = {}

# Register a node as a saveable object.
# Must implement METHOD_GET_SAVE_DATA, METHOD_LOAD_SAVE_DATA
func register(namespace: String, object: Node) -> int:
	# Node doesn't have the correct save methods set up
	if (not object.has_method(METHOD_GET_SAVE_DATA) or
		not object.has_method(METHOD_LOAD_SAVE_DATA)
	):
		return ERR_INVALID_DECLARATION

	# Node is trying to overwrite a namespace already in use
	if saveable_objects.has(namespace):
		return ERR_DUPLICATE_SYMBOL

	saveable_objects[namespace] = object
	return OK

func save_game() -> void:
	# Collect our save data into a Dictionary
	var save_data: Dictionary = {}
	for key in saveable_objects:
		save_data[key] = saveable_objects.get(key).call(METHOD_GET_SAVE_DATA)

	# Do the saving
	var save_file: File = File.new()
	if save_file.open(SAVE_FILEPATH, File.WRITE) != OK:
		print(self.filename, ": Error opening save file for writing")
		return
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_game() -> int:
	var save_file = File.new()

	# Make sure the file exists
	if not save_file.file_exists(SAVE_FILEPATH):
		return ERR_FILE_NOT_FOUND

	# Make sure the file is readable
	if save_file.open(SAVE_FILEPATH, File.READ) != OK:
		print(self.filename, ": Error opening save file for reading")
		return ERR_FILE_CANT_READ

	# Get the saved dictionary from the next line in the save file
	var save_data: Dictionary = parse_json(save_file.get_as_text())

	for key in saveable_objects:
		if save_data.has(key):
			saveable_objects.get(key).call(
				METHOD_LOAD_SAVE_DATA,
				save_data.get(key)
			)

	save_file.close()
	return OK
