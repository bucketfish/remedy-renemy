extends Label

@export var color_name = ""


@onready var label = $RichTextLabel
@onready var colors = get_node("/root/main/game").colors
@onready var book = get_node("/root/main/game/book")

var selected = false

var attached_to_loc = false
var chosen_area = ""

var default_loc = Vector2()
var chosen_loc = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	default_loc = self.position
	print(default_loc)
	
	self.modulate = Color("#7f6048")
	#label.text = "[center][color=" + colors[color_name] + "]" + color_name + "[/color][/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		self.global_position = get_global_mouse_position() - Vector2(50, 20)


func _on_button_down():
	if not selected:
		selected = true


func _on_button_up():
	if selected:
		selected = false
		var locs = $Area2D.get_overlapping_areas()
		var is_attached_to_loc = false 
		for loc in locs:
			if loc.is_in_group("ingredient_color_area"):
				if book.chosen_ing[int(loc.item_num)] == color_name:
					is_attached_to_loc = true 
				
		if not is_attached_to_loc:
			self.position = default_loc
			self.modulate = Color("#7f6048")

		else:
			self.global_position = chosen_loc
			self.modulate = Color("#ffffff")



func _on_area_2d_area_entered(area):
	if area.is_in_group("ingredient_color_area"):
		
		var area_ing = int(area.item_num)
		
		#if attached_to_loc:
			#if book.chosen_ing[area_ing] != color_name:
				#book.set_color(chosen_area, "")
				#book.set_color(area_ing, color_name)
				#chosen_area = area_ing 
				#chosen_loc = area.global_position
#
			#return
			
		if book.chosen_ing[area_ing] == "" or book.chosen_ing[area_ing] == color_name:
			attached_to_loc = true
		
			prints("set color", area_ing, color_name)
			chosen_area = area_ing
			book.set_color(area_ing, color_name)
			chosen_loc = area.global_position
			

	
func _on_area_2d_area_exited(area):
	if area.is_in_group("ingredient_color_area"):
		var area_ing = int(area.item_num)
		if book.chosen_ing[area_ing] == color_name:
			book.set_color(area_ing, "")
			
		
