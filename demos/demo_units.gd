extends Node2D

onready var troop = get_node("Troop")
onready var regiment = get_node("Regiment")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		troop.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - troop.global_position)))
		regiment.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - regiment.global_position)))
		update()

func _draw():
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * troop.global_position, Color(1,0,0), 1)
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * regiment.global_position, Color(1,0,0), 1)

