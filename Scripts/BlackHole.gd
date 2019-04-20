extends Node2D
class_name BlackHole

signal star_destroyed

var face_anim: AnimationPlayer

func _ready():
  $Area2D.connect("body_entered", self, "on_star_enter")
  $AnimationPlayer.play("anim")
  face_anim = $Face/AnimationPlayer

func on_star_enter(body: Seed):
  body.destroy()
  emit_signal('star_destroyed')

func wake_up():
  face_anim.play("Wake Up")

func smile():
  if (!face_anim.is_playing()):
    face_anim.play("Smile")