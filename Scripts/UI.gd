extends Control
class_name UI

var selected_ship: Ship
var directions_panel: Container

var direction_btns: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
  directions_panel = $Directions
  
  direction_btns = $Directions/HBoxContainer.get_children()
  for i in range(direction_btns.size()):
    var dir_btn: DirectionButton = direction_btns[i]
    dir_btn.connect('pressed', self, 'edit_direction', [i])
    dir_btn.drop_seed(i == direction_btns.size() - 1)

func select_ship(ship: Ship):
  if selected_ship:
    unselect_ship()

  selected_ship = ship
  selected_ship.set_selected(true)
  directions_panel.visible = true
  
  for i in range(ship.commands.size()):
    var btn := direction_btns[i] as DirectionButton
    btn.set_rotation(ship.commands[i] * PI / 4)
  
  var curr_index: int = (ship.index + ship.commands.size() - 1) % ship.commands.size()
  set_active_button(curr_index)
  ship.connect('turn', self, 'set_active_button')

func unselect_ship():
  if (selected_ship):
    selected_ship.disconnect('turn', self, 'set_active_button')
    selected_ship.set_selected(false)
    directions_panel.visible = false
    selected_ship = null

func set_active_button(index: int):
  for i in range(direction_btns.size()):
    var btn: DirectionButton = direction_btns[i]
    btn.set_active(i == index)

func edit_direction(index: int):
  if selected_ship:
    selected_ship.edit_command(index)
    var btn: DirectionButton = direction_btns[index]
    btn.set_rotation(selected_ship.commands[index] * PI / 4)
