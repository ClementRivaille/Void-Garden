extends Control

func quit():
  get_tree().quit()

func toggle_fullscreen():
  OS.window_fullscreen = !OS.window_fullscreen
