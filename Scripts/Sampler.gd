extends AudioStreamPlayer
class_name Sampler

# 0 4 7 10 9
export(Array, AudioStream) var samples: Array
export(Array, int) var indexes: Array
export(String, "SFX", "Ships", "Seeds") var bus_target: String = "SFX"

var bus_index: int
var pitch : AudioEffectPitchShift
var lowpass: AudioEffectLowPassFilter

func _init():
  # create an audio bus
  bus_index = AudioServer.get_bus_count()
  AudioServer.add_bus(bus_index)
  AudioServer.set_bus_name(bus_index, 'sampler' + str(bus_index))
  pitch = AudioEffectPitchShift.new()
  lowpass = AudioEffectLowPassFilter.new()
  lowpass.cutoff_hz = 5000
  lowpass.resonance = 1
  lowpass.db = AudioEffectFilter.FILTER_6DB
  AudioServer.add_bus_effect(bus_index, pitch)
  AudioServer.add_bus_effect(bus_index, lowpass)
  bus = AudioServer.get_bus_name(bus_index)

func _ready():
  # bus_target is only initialized once entered in scene_tree
  AudioServer.set_bus_send(bus_index, bus_target)

func play_note(note: int):
  # look for the closest note in the samples
  var idx := 0
  var diff := abs(note - indexes[0])
  while (idx <  indexes.size() - 1):
    var next_diff := abs(note - indexes[idx+1])
    if (diff < next_diff):
      break
    diff = next_diff
    idx += 1
  
  # Set sample
  stream = samples[idx]
  
  # Set pitch relatively to sample
  pitch.set_pitch_scale(pow(2, (note - indexes[idx]) / 12.0))
  
  play(0.0)

func set_lowpass_cutoff(cutoff: int):
  lowpass.cutoff_hz = cutoff