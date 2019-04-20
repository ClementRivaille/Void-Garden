extends Button
class_name DirectionButton

var container: CenterContainer

var style_normal: StyleBox = preload("res://Assets/GUI/btn_texture.tres")
var style_focus: StyleBox = preload("res://Assets/GUI/btn_focus_texture.tres")
var style_active: StyleBox = preload("res://Assets/GUI/btn_active_texture.tres")
var style_focus_active: StyleBox = preload("res://Assets/GUI/btn_active_focus_texture.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
  container = $CenterContainer

func set_rotation(angle: float):
  container.set_rotation(angle)

func set_active(active: bool):
  if active:
    set("custom_styles/normal", style_active)
    set("custom_styles/hover", style_focus_active)
    set("custom_styles/focus", style_focus_active)
    set("custom_styles/pressed", style_focus_active)
  else:
    set("custom_styles/normal", style_normal)
    set("custom_styles/hover", style_focus)
    set("custom_styles/focus", style_focus)
    set("custom_styles/pressed", style_focus)

func drop_seed(value: bool):
  $Seed.visible = value
