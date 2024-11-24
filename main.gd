extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var mainmenu = $mainmenu
const game = preload("res://game.tscn")


@onready var cutscene_start = [
	["show", $start/c1],
	"Once a upon a time, there was a little witch who lived in a little cottage...",
	"That witch is ME!",
	"But I'm not like other witches. I'm built different. I'm different because... uh...",
	"Right, because I'm really clumsy and forgetful! I forgot, sorry.",
	["show", $start/c2],
	"Today, I'm making a potion to stop it all! No more being clumsy or forgetful.",
	"My great-great-great-grandmother gave me this recipe a long time ago.",
	"But I was so clumsy that I completely forgot about it.",
	["show", $start/c3],
	"OH MY GOD, MY INK!!",
	"Oh no no no no, this can't be happening.",
	"Where did this ink come from? How did I knock it over?",
	"Why am I always making myself my own enemy?",
	["show", $start/c4],
	"Now the parchment with the recipe is stained and I can't read it...",
	"But no matter. I'll have to figure out what the blotched parts say.",
	"There are enough clues about how the ingredients react to figure out which is which.",
	"No more clumsiness once I make the MEMOREMEDY POTION!!"
]

@onready var cutscene_end = [
	["show", $end/c5],
	"I FINALLY DID IT!",
	"With the MEMOREMEDY potion, I'll finally be able to stop forgetting things!",
	"Now let me just take a sip—",
	["show", $end/c6],
	"WAIT, NO!!!",
	"MY POTION!!!!",
	["show", $end/c7],
	"I spilled it...",
	"I'm truly my worst enemy, aren't I?",
	"Guess I'll have to make it again.....",
	["show", $end/c8]
]
var starting = false



var cs_index = 0
var cs_scene: Sprite2D

var tween: Tween
var label_tween: Tween

@onready var label = $text

@onready var end = $end

var game_scene: Node2D
signal advance

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_pressed() and not starting:
		starting = true
		
		if tween:
			tween.kill
		tween = create_tween()
		tween.tween_property(mainmenu, "modulate", Color(1, 1, 1, 0), 0.5)
		await tween.finished
		open_cutscene()
		mainmenu.hide()
			
	elif event.is_pressed():
		emit_signal("advance")
		

		
func open_cutscene():
	mainmenu.queue_free()
	for step in cutscene_start:
		await run_cutscene_step(step)
		
	game_scene = game.instantiate()
	self.add_child(game_scene)
	
	label.hide()
	if tween:
		tween.kill
	tween = create_tween()
	tween.tween_property($start, "modulate", Color(1, 1, 1, 0), 0.2)
	await tween.finished
	$start.hide()
	
func close_cutscene():
	if tween:
		tween.kill
	tween = create_tween()
	end.show()
	label.show()
	label.text = ""
	
	tween.tween_property(game_scene, "modulate", Color(1, 1, 1, 0), 0.5)
	await tween.finished
	
	game_scene.queue_free()
	
	for step in cutscene_end:
		await run_cutscene_step(step)
		
func run_cutscene_step(step):
	if len(step) == 2:
		if step[0] == "show":
			var next_scene = step[1]
			
			next_scene.show()
			label.text = ""
			label.global_position = next_scene.dialogue_location
			
			if cs_scene:
				if tween:
					tween.kill
				tween = create_tween()
				tween.tween_property(cs_scene, "modulate", Color(1, 1, 1, 0), 0.2)
				await tween.finished
				cs_scene.hide()
				
			
			cs_scene = next_scene
			
			if next_scene == $end/c6:
				$end/c6/AnimatedSprite2D.play()
			
	else:
		await show_text(step)
		await advance
		
		
func show_text(text):
	label.visible_characters = 0
	label.text = text
	
	if label_tween:
		label_tween.kill()
	label_tween = create_tween()
	label_tween.tween_property(label, "visible_characters", 500, 6.0).from(0.0)

	
	
	
func end_game():
	pass
