extends KinematicBody2D

onready var top_raycast : RayCast2D = $RayCast2D2
onready var rigth_raycast : RayCast2D = $RayCast2D3
onready var bottom_raycast : RayCast2D = $RayCast2D
onready var left_raycast : RayCast2D = $RayCast2D4

onready var item = load("res://Mineral.tscn")

func _process(delta: float) -> void:
	
	var direction = get_direction()
	
	if !is_mining(direction,delta):
		move_and_collide(direction * delta * 100)
	
func get_direction() -> Vector2:
	var direction_x : float = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	var direction_y : float = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	return Vector2(direction_x,direction_y).normalized()
	
func is_mining(direction : Vector2, delta : float) -> bool:
	var tilemap : TileMap
	var pos_cell : Vector2
	var real_position : Vector2	
	
	active_only_necesary_raycast(direction)	
	
	if direction.y > 0 && bottom_raycast.is_colliding():
		print("bottom_raycast %s" % bottom_raycast.get_collider())
		tilemap = bottom_raycast.get_collider() as TileMap
		real_position = bottom_raycast.get_collision_point()
		pos_cell = tilemap.world_to_map(real_position)		
		position = position.move_toward(Vector2(position.x,position.y-20),delta * 500)
	elif direction.y < 0 && top_raycast.is_colliding():
		print("top_raycast %s" % top_raycast.get_collider())
		tilemap = top_raycast.get_collider() as TileMap
		real_position = top_raycast.get_collision_point()  + Vector2.UP
		pos_cell = tilemap.world_to_map(top_raycast.get_collision_point() + Vector2.UP)
		position = position.move_toward(Vector2(position.x,position.y+20),delta * 500)
	elif direction.x > 0 && rigth_raycast.is_colliding():
		print("rigth_raycast %s" % rigth_raycast.get_collider())
		tilemap = rigth_raycast.get_collider() as TileMap
		real_position = rigth_raycast.get_collision_point()
		pos_cell = tilemap.world_to_map(rigth_raycast.get_collision_point())
		position = position.move_toward(Vector2(position.x-10,position.y),delta * 500)	
	elif direction.x < 0 && left_raycast.is_colliding():
		print("left_raycast %s" % left_raycast.get_collider())
		tilemap = left_raycast.get_collider() as TileMap
		real_position = left_raycast.get_collision_point() + Vector2.LEFT
		pos_cell = tilemap.world_to_map(left_raycast.get_collision_point() + Vector2.LEFT)
		position = position.move_toward(Vector2(position.x+10,position.y),delta * 500)
			
	if tilemap:
#		creamos los minerales si es la zona de tile de minerales
		if tilemap.get_cellv(pos_cell) == 2 || tilemap.get_cellv(pos_cell) == 3:
			for i in range(3):
				var new_item = item.instance()
				new_item.position = real_position
				get_parent().add_child(new_item)		
#		borramos la celda
		tilemap.set_cellv(pos_cell,-1)
#		Actualizamos el tilemap
		tilemap.update_bitmask_region(pos_cell,pos_cell + Vector2.DOWN)	
		
	return  true if tilemap else false

func active_only_necesary_raycast(direction : Vector2) -> void:
	if direction.y > 0:
		bottom_raycast.enabled = true
		top_raycast.enabled = false
		rigth_raycast.enabled = false
		left_raycast.enabled = false
	elif direction.y < 0:
		bottom_raycast.enabled = false
		top_raycast.enabled = true
		rigth_raycast.enabled = false
		left_raycast.enabled = false
	elif direction.x > 0:
		bottom_raycast.enabled = false
		top_raycast.enabled = false
		rigth_raycast.enabled = true
		left_raycast.enabled = false
	elif direction.x < 0:
		bottom_raycast.enabled = false
		top_raycast.enabled = false
		rigth_raycast.enabled = false
		left_raycast.enabled = true
	
