extends Node2D

var holding = ""

@onready var cauldron_pos = $cauldron/CauldronPos.global_position
@onready var flask_pos = $flask/FlaskPos.global_position

@onready var cauldron = $cauldron

@onready var cauldron_inside = $cauldron/Sprite2D2

@onready var flask_half = $flask/flask_half
@onready var flask_full = $flask/flask_full

@onready var flask_bubble_half = $flask/bubble_1
@onready var flask_bubble_full = $flask/bubble_2

@onready var cauldron_bubble = $cauldron/bubble

@onready var rainbow = $cauldron/Sprite2D2/rainbow

@onready var main = get_node("/root/main")


@onready var flask_tween = create_tween()
@onready var cauldron_tween = create_tween()
var in_cauldron = [] 
var in_flask = []

var combinations = {
	["ggouti", "pallra"]: "pink",
	["ggouti", "yiklonna"]: "red",
	["kjkero", "yiklonna"]: "orange",
	["pallra", "yiklonna"]: "orange",
	["yiklonna", "zxzv"]: "yellow",
	["ggouti", "lekharrats"]: "green",
	["lekharrats", "yiklonna"]: "green",
	["kjkero", "lekharrats"]: "green",
	["kjkero", "pallra"]: "blue",
	["lekharrats", "pallra"]: "purple",
	["ggouti", "zxzv"]: "black",
	["kjkero", "zxzv"]: "black",
	["pallra", "zxzv"]: "black",
	["lekharrats", "zxzv"]: "black",
	
	["ggouti"]: "red",
	["yiklonna"]: "orange",
	["zxzv"]: "yellow",
	["lekharrats"]: "green",
	["kjkero"]: "blue",
	["pallra"]: "purple"
}

var success_direction = {
	["ggouti", "pallra", "yiklonna"]: "blue",
	["ggouti", "pallra", "yiklonna", "kjkero"]: "rainbow"
}


var colors = {
	"pink": "#ff88bc",
	"red": "#ff0000",
	"orange": "#ff8000",
	"yellow": "#e0ad00",
	"green": "#52ad58",
	"blue": "#008deb",
	"purple": "#8a55c2",
	"black": "#000000"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func end_game():
	await get_tree().create_timer(0.5).timeout 
	main.close_cutscene()
	
func add_ingredient(ing):
	if ing in in_cauldron:
		return
	else:
		in_cauldron.append(ing)
		
	update_cauldron_color()


func add_ingredient_flask(ing):
	if ing in in_flask:
		return
	elif len(in_flask) >= 2:
		return
	else:
		in_flask.append(ing)
		in_flask.sort()
		
	print(in_flask)

	update_flask_color()
		
func update_cauldron_color():
	if in_cauldron == []:
		cauldron_inside.hide()
		return

	print(in_cauldron)
	print(in_cauldron in success_direction.keys())
	var color = "#fff"
	
	if in_cauldron in success_direction.keys():
		color = success_direction[in_cauldron]
		print(color)
		if color != "rainbow":
			color = colors[color]
	else:
		var cal2 = in_cauldron
		cal2.sort()
		if cal2 in combinations.keys():
			color = combinations[in_cauldron]
			color = colors[color]

	
	cauldron_inside.show()
	
	if color == "rainbow":
		if cauldron_tween:
			cauldron_tween.kill()
		cauldron_tween = create_tween()
		
		
		rainbow.modulate = Color("#ffffff00")
		rainbow.show()
		cauldron_tween.tween_property(rainbow, "modulate", Color("#ffffff"), 0.5)
		
		cauldron_tween.tween_callback(end_game)
	elif len(in_cauldron) >= 2:
		if cauldron_tween:
			cauldron_tween.kill()
		cauldron_tween = create_tween()
		
		cauldron_tween.tween_property(cauldron_inside, "self_modulate", Color(color), 0.4)

	else:
		cauldron_inside.self_modulate = Color(color)
	cauldron_bubble.emitting = true


func update_flask_color():
	var color = "#fff"
	if in_flask in combinations.keys():
		color = combinations[in_flask]
		color = colors[color]
	
	if len(in_flask) == 1:
		flask_half.show() 
		flask_full.hide() 

		flask_half.modulate = Color(color)
		flask_full.modulate = Color(color)
		# flask_tween.tween_property(flask_half, "modulate", Color(color), 0.2)
		flask_bubble_half.emitting = true
	elif len(in_flask) >= 2:
		flask_half.hide() 
		flask_full.show()
		#flask_full.modulate = Color(color)
		if flask_tween:
			flask_tween.kill()
		flask_tween = create_tween()
		flask_tween.tween_property(flask_full, "modulate", Color(color), 0.4)
		
		flask_bubble_full.emitting = true
	else:
		flask_half.hide() 
		flask_full.hide()


func _on_clear_cauldron_pressed():
	in_cauldron = []
	update_cauldron_color()
	


func _on_clear_flask_pressed():
	in_flask = []
	update_flask_color()
