extends Node2D

@onready var game = get_node("/root/main/game")
@onready var moveable = $moveable
#@onready var particle = $moveable/CPUParticles2D
@onready var sprite1 = $moveable/Sprite2D
@onready var sprite2 = $moveable/Sprite2D2
@onready var sprite3 = $moveable/Sprite2D3

@export var ingredient_name = "ing1"
@export var sprites_count = 1
@export var is_liquid = true
@export var particle_color: Color = Color("#ffffff")

@onready var particle = $moveable/particle
@onready var liquid = $moveable/liquid

@onready var ing_tween = create_tween()


var TARGET_YDIST = 200

var cauldron_amt = 0
var flask_amt = 0

var on_item = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	liquid.modulate = particle_color
	particle.modulate = particle_color


func emit_particles():
	if is_liquid:
		liquid.emitting = true
	else:
		particle.emitting = true
		
func stop_particles():
	liquid.emitting = false
	particle.emitting = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_deg = 0
	
	if game.holding == self.ingredient_name:
		on_item = "none"
		moveable.global_position = get_global_mouse_position()
		
		var y_dist = game.cauldron_pos.y - moveable.global_position.y
		var x_dist = game.cauldron_pos.x - moveable.global_position.x

		
		target_deg = 0
		if y_dist < TARGET_YDIST and abs(x_dist) < 500:
			
			if moveable.global_position.x < game.cauldron_pos.x:
				target_deg = (TARGET_YDIST-y_dist) / 1.5
			else:
				target_deg = -(TARGET_YDIST-y_dist) / 1.5
				
			on_item = "cauldron"
		
		
		
		y_dist = game.flask_pos.y - moveable.global_position.y
		x_dist = game.flask_pos.x - moveable.global_position.x

		if y_dist < TARGET_YDIST and abs(x_dist) < 200:
			
			if moveable.global_position.x < game.flask_pos.x:
				target_deg = (TARGET_YDIST-y_dist) / 1.5
			else:
				target_deg = -(TARGET_YDIST-y_dist) / 1.5
				
			on_item = "flask"
	
		if target_deg > 180:
			target_deg = 180
		moveable.rotation = lerp_angle(moveable.rotation, deg_to_rad(target_deg), 0.1)
		#if ing_tween:
			#ing_tween.kill()
		#ing_tween = create_tween()
		#ing_tween.tween_property(moveable, "rotation_degrees", target_deg, 0.1)
		#
		if abs(target_deg) > 91:
			emit_particles()
			if on_item == "cauldron":
				cauldron_amt += delta
			elif on_item == "flask":
				flask_amt += delta
				
			
			if sprites_count == 2:
				sprite1.hide()
				sprite2.show()
				if int(moveable.rotation_degrees) % 360 < 180:
					sprite2.flip_h = true
				else:
					sprite2.flip_h = false
					
					
			elif sprites_count == 3:
				sprite1.hide()
				sprite2.hide()
				sprite3.show()
				
				if int(moveable.rotation_degrees) % 360 < 180:
					sprite3.flip_h = true
				else:
					sprite3.flip_h = false
					
				
		else:
			stop_particles()
			
			if sprites_count == 2:
				sprite2.hide()
				sprite1.show()
				
			elif sprites_count == 3:
				if abs(target_deg) > 70:
					sprite1.hide()
					sprite2.show()
					sprite3.hide()
					if int(moveable.rotation_degrees) % 360 < 180:
						sprite2.flip_h = true
					else:
						sprite2.flip_h = false
				else:
					sprite1.show()
					sprite2.hide()
					if int(moveable.rotation_degrees) % 360 < 180:
						sprite2.flip_h = true
					else:
						sprite2.flip_h = false
			
			
		if cauldron_amt > 0.5:
			game.add_ingredient(ingredient_name)
			cauldron_amt = 0
		if flask_amt > 0.5:
			game.add_ingredient_flask(ingredient_name)
			flask_amt = 0
	
	elif moveable.rotation != 0:

		moveable.rotation = lerp_angle(moveable.rotation, 0, 0.2)
			


func _on_ingredient_down():
	if game.holding == "":
		game.holding = self.ingredient_name
		moveable.z_index = 10


func _on_ingredient_up():
	if game.holding == self.ingredient_name:
		game.holding = ""
		moveable.z_index = 0
		
		var tween = get_tree().create_tween()
		tween.tween_property(moveable, "global_position", self.global_position, 0.3).set_ease(Tween.EASE_IN_OUT)
		stop_particles()
		sprite1.show()
		sprite2.hide()
		sprite3.hide()
		
		# move back to location
		
