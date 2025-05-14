extends OptionButton

const RESOLUTION_DICTIANORY: Dictionary={
	"1152 x 648": Vector2i(1152,648),
	"1280 x 720": Vector2i(1280,720),
	"1920 x 1080": Vector2i(1920,1080)
}

func _ready() -> void:
	for resolution_size_text in RESOLUTION_DICTIANORY:
		add_item(resolution_size_text)

func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIANORY.values()[index])
