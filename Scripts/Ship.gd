extends KinematicBody2D
class_name Ship

signal create_seed
signal turn
signal clicked
signal plant_flower

var NOTES := {
  0: 12,
  1: 11,
  2: 7,
  3: 5,
  4: 0,
  5: 2,
  6: 4,
  7: 9
}
var timer: Timer
var sampler: Sampler
var tween: Tween
var flower: Sprite
var sprite: Sprite

export(float) var min_speed: float = 20
export(float) var max_speed: float = 120
export(float) var min_timer: = 0.1
export(float) var max_timer: = 1.5
export(float) var min_lowpass := 300
export(float) var max_lowpass := 2000

export(Array, int) var commands: Array
var index := 0
var direction := 0

var seeds: int = 0

func _init():
  scale = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
  sprite = $Sprite
  timer = $Timer
  sampler = $Sampler
  tween = $Tween
  flower = $Flower
  commands = [0,0,0,0,0]
#warning-ignore:return_value_discarded
  timer.connect("timeout", self, "change_direction")
  
  tween.interpolate_property(self, "scale",
    Vector2(), Vector2(1,1),
    0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()

  for i in range(commands.size()):
    commands[i] = randi()%8
  direction = commands[0]
  index = 1
  
func calc_distance() -> float:
  var delta_x := min(1, abs(position.x) / (get_viewport_rect().size.x / 2))
  var delta_y := min(1, abs(position.y) / (get_viewport_rect().size.y / 2))
  var distance := Vector2(delta_x, delta_y).length() / Vector2(1,1).length()
  return distance

#warning-ignore:unused_argument
func _physics_process(delta):
  if (visible):
    var distance := calc_distance()
    
    var velocity := Vector2()
    if (direction == 0 || direction  == 1 || direction == 7):
      velocity.y = -1
    if (direction == 3 || direction == 4 || direction == 5):
      velocity.y = 1
    if (direction == 1 || direction == 2 || direction == 3):
      velocity.x = 1
    if (direction == 5 || direction == 6 || direction == 7):
      velocity.x = -1
      
    var speed: float = min_speed + (max_speed - min_speed) * distance
    velocity = velocity.normalized() * speed
  #warning-ignore:return_value_discarded
    move_and_slide(velocity)
    sprite.rotation = direction * PI / 4
    
    timer.wait_time = max_timer - (max_timer - min_timer) * distance
  
func set_color(color: Color):
  sprite.modulate = color

func change_direction():
  if visible:
    emit_signal('turn', index)
    
    direction = commands[index]
    index = (index + 1)%commands.size()
    
    var distance = calc_distance()
    sampler.set_lowpass_cutoff(min_lowpass + (distance * (max_lowpass - min_lowpass)))
    sampler.play_note(NOTES[direction])
    
    if index == 0:
      if (seeds > 0):
        emit_signal("plant_flower", position)
        seeds = seeds - 1
        if (seeds == 0):
          flower.visible = false
      else:
        emit_signal("create_seed", position, NOTES[randi()%8])

func edit_command(index: int):
  commands[index] = (commands[index] + 1) % 8


func _on_click(viewport, event: InputEvent, shape_idx):
  if event.is_pressed(): 
    emit_signal('clicked', self)

func set_selected(value: bool):
  $Selected.visible = value
  if value:
    $AnimationPlayer.play("selected_spin")
    tween.interpolate_property($Selected,
      "scale",
      Vector2(),
      Vector2($Selected.scale.x, $Selected.scale.y),
      0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
    tween.start()
  else:
    $AnimationPlayer.stop()

func collect_seed():
  seeds += 1
  flower.visible = true
