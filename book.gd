extends Node2D

var showing = false

@onready var anim = $AnimationPlayer
@onready var show_button = $"../book_button"
@onready var close_button = $close_button

@onready var clues_label = $clues/clues_label
@onready var other_label = $other_label

@onready var colors = get_node("/root/main/game").colors
		
var clues_text = """yiklonna + ggouti

yiklonna + kjkero
yiklonna + pallra

yiklonna + zxzv

lekharrats + ggouti
lekharrats + yiklonna
lekharrats + kjkero

kjkero + pallra

lekharrats + pallra

pallra + ggouti

zxzv + any except yiklonna
"""



var chosen_ing = {
	1: "",
	2: "",
	3: "",
	4: "",
	5: "",
	6: ""
}

var colors_list = {
	"ggouti": "red",
	"yiklonna": "orange",
	"zxzv": "yellow",
	"lekharrats": "green",
	"kjkero": "blue",
	"pallra": "purple"
}

var colors_listy = ["red", "orange", "yellow", "green", "blue", "purple"]

# Called when the node enters the scene tree for the first time.
func _ready():
	print(colors)
	for key in colors:
		print(key)
		clues_text = clues_text.replacen(key, "[color=" + colors[key] + "]" + key + "[/color]")
		
	print(clues_text)
	# clues_label.text = clues_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color(number, itemname):
	chosen_ing[number] = itemname 
	var current_text = clues_text 
	
	for key in chosen_ing:
		if chosen_ing[key] == "":
			continue
		else:
			var ing_to_set = chosen_ing[key]
			var color_to_set = colors[colors_listy[key-1]]
			current_text = current_text.replacen(ing_to_set, "[color=" + color_to_set + "]" + ing_to_set + "[/color]")
	clues_label.text = current_text
	pass
	
	
func show_book():
	if showing == false:
		show_button.hide()
		close_button.show()
		showing = true
		anim.play("show_book")
	
func hide_book():
	if showing == true:
		show_button.show()
		close_button.hide()
		showing = false
		anim.play("hide_book")
		
func _input(event):
	if Input.is_action_just_pressed("toggle_book"):
		if showing == false:
			show_book()
		else:
			hide_book()

func _on_texture_button_pressed():
	show_book()

func _on_close_button_pressed():
	hide_book()
		
		
		
