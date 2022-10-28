extends Node

const KEYS_FILE = "user://keys_found.json"

onready var keys = load_from_disk()

func got_key(key):
	keys[key] = true
	save_to_disk()

func load_from_disk():
	var file = File.new()
	if not file.file_exists(KEYS_FILE):
		return {}
	file.open(KEYS_FILE, File.READ)
	return parse_json(file.get_as_text())

func save_to_disk():
	var file  = File.new()
	file.open(KEYS_FILE, File.WRITE)
	print("Writing to" + KEYS_FILE + "... ")
	file.store_string(to_json(keys))
	file.close()
	print("Done!\n")
