extends Node2D
class_name Flower

var tween: Tween
var petals: Sprite
var base: Sprite

var MIN_SIZE: float = 0.6
var MAX_SIZE: float = 1.6

func _ready():
  tween = $Tween
  petals = $Petals
  base = $Base
  
  var rand_dir: int =  randi() % 2
  if rand_dir > 0:
    rand_dir = 1
  else:
    rand_dir = -1
  tween.interpolate_property(self, "rotation_degrees",
    0, rand_dir * 360,
    10 + randi() % 7,
    Tween.TRANS_LINEAR, Tween.EASE_IN)
  tween.start()
  
  var size: float = MIN_SIZE + randf() * (MAX_SIZE - MIN_SIZE)
  $Tween_enter.interpolate_property(self, "scale",
    Vector2(), Vector2(size,size),
    2,
    Tween.TRANS_SINE, Tween.EASE_OUT)
  $Tween_enter.start()
  
func set_colors(base_c: Color, petals_c: Color):
  base.modulate = base_c
  petals.modulate = petals_c
