extends Node2D

func _ready():
  $ColorRect.visible = true
  var hole = $BlackHole as BlackHole
  hole.wake_up()
  
  for child in $Flowers.get_children():
    var flower := child as Flower
    flower.set_colors(Color(randf(), randf(), randf()), Color(randf(), randf(), randf()))
