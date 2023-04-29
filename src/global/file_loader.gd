extends Node
class_name FileLoader

static func load_json(path : String, is_user_file = false):
	var filepath = ("res://" if !is_user_file else "user://") + path + ".json"
	
	if not FileAccess.file_exists(filepath):
		print_debug("FILE DOESN'T EXIST")
		return null
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var json = test_json_conv.get_data()
	file.close()
	
	return json["DATA"]


static func write_json(path : String, data, is_user_file = false):
	var filepath = ("res://" if !is_user_file else "user://") + path + ".json"
	
	var json_text = JSON.stringify(data)
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_line(json_text)
	file.close()
