extends HSlider

@export
var music_bus:String
var music_index:int=1

func _on_value_changed(music_volume:float)->void:
	AudioServer.set_bus_volume_db(music_index,linear_to_db(music_volume))
