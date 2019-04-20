extends HBoxContainer

export(String) var label: String
export(String, "Ships", "Seeds", "Music", "SFX") var bus: String

var bus_index: int
var default_volume: float

func _ready():
  $Label.text = label
  bus_index = AudioServer.get_bus_index(bus)
  default_volume = db2linear(AudioServer.get_bus_volume_db(bus_index))

func set_volume(value: float):
  var volume = linear2db(default_volume * value)
  AudioServer.set_bus_volume_db(bus_index, volume)
