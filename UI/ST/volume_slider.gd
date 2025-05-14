extends HSlider

@export
var master_bus:String
var master_index:int=0

func _on_value_changed(master_volume:float)->void:
	AudioServer.set_bus_volume_db(master_index,linear_to_db(master_volume))
