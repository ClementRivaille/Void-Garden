extends Control
class_name Title

signal start

var started: bool = false
var menu: bool = false

func _input(event):
  if event.is_pressed() && !event.is_action_pressed("ui_cancel") && !started && !menu:
    emit_signal("start")
    visible = false
    started = true

func open_menu(display: bool):
  visible = !display
  menu = display
