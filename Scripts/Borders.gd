extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var limit_x: float
var limit_y: float
var margin:int = 12


# Called when the node enters the scene tree for the first time.
func _ready():
  limit_x = get_viewport_rect().size.x / 2
  limit_y = get_viewport_rect().size.y / 2
  connect('body_exited', self, 'teleport')

func teleport(body: KinematicBody2D):
  if !body:
    return
  if abs(body.position.x) > limit_x:
    body.position.x = (-abs(body.position.x) / body.position.x) * (limit_x + margin)
  if abs(body.position.y) > limit_y:
    body.position.y = (-abs(body.position.y) / body.position.y) * (limit_y + margin)