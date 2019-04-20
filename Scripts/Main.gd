extends Node2D

var MAX_SHIPS := 3

export(Array, AudioStream) var flower_sfx: Array
export(Array, Color) var ships_colors: Array = []

var spawner: Spawner
var ui: UI
var ships: Node
var pause: Control
var title: Title
var hole: BlackHole

var flower_sfx_player: AudioStreamPlayer
var seed_sfx_player: AudioStreamPlayer

var index_ship_selected: int = -1
var nb_ships := 0
var f_before_new_ship := 2

# Called when the node enters the scene tree for the first time.
func _ready():
  spawner = $Spawner
  ui = $UI
  ships = $Ships
  flower_sfx_player = $FlowerSFX
  seed_sfx_player = $SeedSFX
  pause = $Pause
  title = $Start
  hole = $BlackHole
  
  pause.connect("quit", self, "quit")
  randomize()
  
func start():
  add_ship()
  $Music.play(0.0)
  $SelectNextShip.visible = true
  hole.wake_up()


func create_seed(position: Vector2, note: int):
  var seed_inst: Seed = spawner.create_seed($Seeds)
  seed_inst.position = position
  seed_inst.note = note
  seed_inst.connect('collected', self, 'on_seed_collect')
  seed_inst.connect('destroyed', self, 'disconnect_seed')
  
func add_ship():
  var ship :Ship = spawner.create_ship(ships)
  ship.position = Vector2()
  ship.connect('clicked', self, "select_ship")
  ship.connect("create_seed", self, "create_seed")
  ship.connect("plant_flower", self, "create_flower")
  if (nb_ships < ships_colors.size()):
    ship.set_color(ships_colors[nb_ships])
  nb_ships += 1

func select_ship(ship: Ship):
  if (ship == ui.selected_ship):
    ui.unselect_ship()
    index_ship_selected = -1
  else:
    ui.select_ship(ship)
    index_ship_selected = ships.get_children().find(ship)

func select_next_ship():
  index_ship_selected = (index_ship_selected + 1)
  if index_ship_selected < ships.get_child_count():
    var ship := ships.get_child(index_ship_selected) as Ship
    select_ship(ship)
  else:
    unselect_ship()
  
func unselect_ship():
  ui.unselect_ship()
  index_ship_selected = -1
  
func on_seed_collect():
  if !seed_sfx_player.playing:
    seed_sfx_player.pitch_scale = 1.6 + randf() * 0.9
    seed_sfx_player.play(0.0)

func disconnect_seed(seed_inst: Seed):
  seed_inst.disconnect('collected', self, 'on_seed_collect')
  seed_inst.disconnect('destroyed', self, 'disconnect_seed')

func create_flower(position: Vector2):
  var flower := spawner.create_flower($Flowers)
  flower.position = position
  flower.set_colors(Color(randf(), randf(), randf()), Color(randf(), randf(), randf()))
  hole.smile()
  
  if !flower_sfx_player.playing:
    var sound = flower_sfx[randi()%flower_sfx.size()]
    flower_sfx_player.stream = sound
    flower_sfx_player.play(0.0)
    
  if nb_ships < MAX_SHIPS:
    f_before_new_ship -= 1
    if f_before_new_ship == 0:
      add_ship()
      f_before_new_ship = (nb_ships) * 2
    
func _input(event: InputEvent):
  if event.is_action_pressed("ui_cancel"):
    pause.visible = !pause.visible
    if nb_ships == 0:
      title.open_menu(pause.visible)

func quit():
  spawner.delete_all()
  get_tree().quit()
