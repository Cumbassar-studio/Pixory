extends HSlider



func _ready() -> void:
	self.value = GlobalWorldEnviroment.environment.adjustment_brightness

func _on_value_changed(brightness: float) -> void:
	GlobalWorldEnviroment.environment.adjustment_brightness = brightness
