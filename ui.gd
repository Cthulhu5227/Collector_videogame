extends CanvasLayer
@onready var pause_menu = $pause_menu
@onready var teeth_counter = $teeth_counter/Label


func _ready() -> void:
	hide()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu.show(pause_menu)

func update_teeth_counter():
	teeth_counter.text = str(Inventory.teeth)

func game_over_screen():
	var n = $game_over_menu
	Engine.time_scale = 0
	n.visible = true
	
# Reset the level and reset the level teeth counter to 0
func retry_level():
	var n = $game_over_menu
	Inventory.lose_teeth()
	update_teeth_counter()
	Engine.time_scale = 1
	n.visible = false
	Ui.visible = false

func end_level():
	var n = $end_menu
	Engine.time_scale = 0
	n.visible = true
	
func end_level_end():
	var n = $end_menu
	Engine.time_scale = 1
	n.visible = false
	Ui.visible = false
