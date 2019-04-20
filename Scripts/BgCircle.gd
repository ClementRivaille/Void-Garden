tool
extends RigidBody2D

export(float, 400, 700) var radius: float = 50
export(Color) var color: Color = Color(0,0,0,0.1)

var MIN_VELOCITY: float = 30

func _ready():
  var direction := Vector2(randf()*2 -1, randf()*2 -1)
  set_axis_velocity(direction.normalized() * (MIN_VELOCITY + randf() * 20))

func _draw():
  draw_circle(Vector2(), radius, color)
