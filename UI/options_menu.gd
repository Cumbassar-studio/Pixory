extends Node

const SETTINGS_FILE = "user://settings.cfg"

var settings = {
	"volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"brightness": 1.0,
	"window_mode": "windowed",
	"resolution": Vector2(1280, 720)
}

func _ready():
	load_settings() 

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("Settings", "volume", settings["volume"])
	config.set_value("Settings", "music_volume", settings["music_volume"])
	config.set_value("Settings", "sfx_volume", settings["sfx_volume"])
	config.set_value("Settings", "brightness", settings["brightness"])
	config.set_value("Settings", "window_mode", settings["window_mode"])
	
	config.set_value("Settings", "resolution_width", settings["resolution"].x)
	config.set_value("Settings", "resolution_height", settings["resolution"].y)

	var error = config.save(SETTINGS_FILE)
	if error != OK:
		print("Ошибка при сохранении настроек: ", error)

func load_settings():
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE)
	
	if error == OK:
		settings["volume"] = config.get_value("Settings", "volume", 1.0)
		settings["music_volume"] = config.get_value("Settings", "music_volume", 1.0)
		settings["sfx_volume"] = config.get_value("Settings", "sfx_volume", 1.0)
		settings["brightness"] = config.get_value("Settings", "brightness", 1.0)
		settings["window_mode"] = config.get_value("Settings", "window_mode", "windowed")
		
		var width = config.get_value("Settings", "resolution_width", 1280)
		var height = config.get_value("Settings", "resolution_height", 720)
		settings["resolution"] = Vector2(width, height)
	else:
		print("Ошибка при загрузке настроек: ", error)

func set_volume(new_volume: float):
	settings["volume"] = new_volume
	save_settings()

func set_music_volume(new_music_volume: float):
	settings["music_volume"] = new_music_volume
	save_settings()

func set_sfx_volume(new_sfx_volume: float):
	settings["sfx_volume"] = new_sfx_volume
	save_settings()

func set_brightness(new_brightness: float):
	settings["brightness"] = new_brightness
	save_settings()

func set_window_mode(new_mode: String):
	settings["window_mode"] = new_mode
	save_settings()

func set_resolution(new_resolution: Vector2):
	settings["resolution"] = new_resolution
	save_settings()
