extends RigidBody2D
class_name Seed

signal collected
signal destroyed

export(float) var grow_time: float = 5
export(float) var gravity: float = 20
export(float) var attraction: float = 120

var sampler: Sampler
var tween: Tween

var grown: bool
var destroyed: bool
var note: int
var waiting_sampler: bool = false

func _enter_tree():
  sampler = $Sampler

  $Collision.monitorable = true
  $Collision.monitoring = true
  $CollisionShape2D.disabled = false
  visible = true

  sampler = $Sampler
  tween = $Tween
  
  tween.interpolate_property($GrownSprite, "scale",
    Vector2(), Vector2($GrowingSprite.scale.x, $GrowingSprite.scale.y),
    grow_time,
    Tween.TRANS_LINEAR, Tween.EASE_IN)
  $GrownSprite.modulate = Color(1,1,1,0.5)

  linear_velocity = Vector2()
  tween.connect("tween_completed", self, 'on_tween_completed')
  connect('body_entered', self, 'get_collected')
  grown = false
  destroyed = false
  set_collision_mask_bit(2, false)
  $GrowingSprite.visible = true
  tween.start()

func on_tween_completed(object: Object, key: NodePath):
  var grown_sprite: Sprite = object as Sprite
  
  if destroyed:
    safe_removal()
  elif grown_sprite && !grown:
    set_grown()

func set_grown():
  grown = true
  $GrowingSprite.visible = false
  $GrownSprite.modulate = Color(1,1,1,1)
  sampler.play_note(note)
  set_collision_mask_bit(2, true)

func _physics_process(delta):
  if (grown):
    var velocity :Vector2 = (Vector2(0,0) - position).normalized() * gravity
    linear_velocity = velocity

    var nearby_bodies: Array = $Collision.get_overlapping_bodies()
    if nearby_bodies && nearby_bodies.size() > 0:
      var attractor := nearby_bodies[0] as KinematicBody2D
      var distance: Vector2 = attractor.position - position
      add_central_force(distance.normalized() * attraction)
    else:
      if applied_force.length() > 0:
        applied_force = applied_force * 0.95

func destroy():
  if (!destroyed):
    destroyed = true
    
    tween.interpolate_property(self, "scale",
      Vector2(1,1), Vector2(),
      0.4, Tween.TRANS_SINE, Tween.EASE_IN)
    tween.start()

func safe_removal():
  if is_inside_tree():
    
    if (sampler.playing && !waiting_sampler):
      sampler.connect("finished", self, "safe_removal")
      waiting_sampler = true
      visible = false
      return
    
    if(waiting_sampler):
      sampler.disconnect("finished", self, "safe_removal")
      waiting_sampler = false
 
    tween.stop_all()
    set_collision_mask_bit(2, false)
    call_deferred('remove_from_tree')

func remove_from_tree():
    $Collision.monitorable = false
    $Collision.monitoring = false
    $CollisionShape2D.disabled = true
    get_parent().remove_child(self)

func _exit_tree():
  applied_force = Vector2()
  tween.disconnect("tween_completed", self, 'on_tween_completed')
  disconnect('body_entered', self, 'get_collected')
  emit_signal('destroyed', self)

func get_collected(ship: Ship):
  if (ship && !destroyed):
    destroyed = true
    ship.collect_seed()
    emit_signal("collected")
    
    tween.interpolate_property($GrownSprite, "modulate",
      Color(1,1,1,1), Color(1,1,1,0),
      0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
    tween.start()
