extends HSlider

@export_enum ("SFX") var SFX_bus:String
var SFX_index:int=3

func _on_value_changed(SFX_volume:float)->void:
	AudioServer.set_bus_volume_db(SFX_index,linear_to_db(SFX_volume))
