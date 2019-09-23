extends Area2D
class_name FollowOnClickable

signal started(followOnClickable)
signal ended(followOnClickable)
signal updated(position)

var polygon: Array setget _set_polygon, _get_polygon
var enabled: bool = false setget _set_enabled, _get_enabled

var _mouse_in: bool = false
var _following: bool = false

func _set_polygon(value: Array) -> void:
	if not has_node("CollisionPolygon2D"):
		var col_area = CollisionPolygon2D.new()
		col_area.name = "CollisionPolygon2D"
		col_area.z_index = 1
		add_child(col_area)
		col_area.polygon = PoolVector2Array(value)
	else:
		get_node("CollisionPolygon2D").polygon = PoolVector2Array(value)

func _get_polygon() -> Array:
	if not has_node("CollisionPolygon2D"):
		return []
	else:
		return Array(get_node("CollisionPolygon2D").polygon)

func _set_enabled(value: bool)-> void:
	if value == enabled:
		return

	set_process_unhandled_input(value)
	enabled = value
	if _following:
		_following = false
		emit_signal("ended", self)

func _get_enabled() -> bool:
	return enabled

func _ready() -> void:
	set_process_unhandled_input(false)
	var _c
	_c = connect("mouse_entered",self, "_on_mouse_entered")
	_c = connect("mouse_exited",self, "_on_mouse_exited")
	monitoring = false
	monitorable = false

func _on_mouse_entered() -> void:
	_mouse_in = true

func _on_mouse_exited() -> void:
	_mouse_in = false

func _unhandled_input(event) -> void:
	if not enabled:
		return;

	if event is InputEventMouseMotion:
		if _following:
			emit_signal("updated", get_global_mouse_position())
		else:
			pass
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		# Start following
		if not _following and _mouse_in and event.pressed:
			if not _following:
				emit_signal("started", self)
			_following = true
		# Stop everything
		elif _following and event.pressed:
			_following = false
			emit_signal("ended", self)
	else:
		pass
