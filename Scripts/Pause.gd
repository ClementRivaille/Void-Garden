extends Control

signal quit

func quit():
  emit_signal("quit")

func toggle_fullscreen():
  OS.window_fullscreen = !OS.window_fullscreen
