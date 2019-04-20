extends Node2D
class_name Spawner

var ships: Array = []
var seeds: Array = []
var flowers: Array = []

export(int) var nb_ships: int = 4
export(int) var nb_seeds: int = 60
export(int) var nb_flowers = 30

# Called when the node enters the scene tree for the first time.
func _ready():
  var ship_scene: PackedScene = preload("res://Prefabs/Ship.tscn")
  for i in range(nb_ships):
    var ship: Ship = ship_scene.instance()
    ship.name = 'Ship' + str(i)
    ships.append(ship)
  
  var seed_scene: PackedScene = preload("res://Prefabs/Seed.tscn")
  for i in range(nb_seeds):
    var seed_scn: Seed = seed_scene.instance()
    seed_scn.name = 'Seed' + str(i)
    seeds.append(seed_scn)
    
  load_flowers()

func load_flowers():
  var flower_scene: PackedScene = preload("res://Prefabs/Flower.tscn")
  for i in range(nb_flowers):
    var flower: Flower = flower_scene.instance()
    flower.name = 'Flower' + str(i)
    flowers.append(flower)  

func create_ship(parent: Node) -> Ship:
  var ship: Ship
  for s in ships:
    if !s.is_inside_tree():
      ship = s
      break
  parent.add_child(ship)
  return ship

func create_seed(parent: Node) -> Seed:
  var seed_inst: Seed
  for s in seeds:
    if !s.is_inside_tree():
      seed_inst = s
      break
  parent.add_child(seed_inst)
  return seed_inst
  
func create_flower(parent: Node) -> Flower:
  var flower: Flower = flowers.pop_front()
  parent.add_child(flower)
  
  if (flowers.size() < 2):
    load_flowers()
  return flower

func delete_all():
  for s in ships:
    s.queue_free()
  for s in seeds:
    s.queue_free()
  for f in flowers:
    f.queue_free()