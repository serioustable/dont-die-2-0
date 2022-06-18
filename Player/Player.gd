extends Area2D

const CHARGE_MIN : float = 0.0
export var CHARGE_MAX : float = 1.0
var charge_amount : float = CHARGE_MIN
export var charge_rate : float = 2.0
export var MAX_TRAVEL_DISTANCE : float = 750.0

var currently_moving := false
var screen_size := Vector2.ZERO

onready var tween : Tween = $Tween 

func _ready() -> void:
	screen_size = get_viewport_rect().size


func get_input(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("charge_dash"):
		charge_amount += charge_rate * delta
		if charge_amount > CHARGE_MAX:
			charge_amount = CHARGE_MAX
		print("Charge Amount is " + str(charge_amount))
	if Input.is_action_just_released("charge_dash"):
		print("Discharging!")
		get_dash_movement(get_global_mouse_position(), charge_amount)
		charge_amount = CHARGE_MIN

func _physics_process(delta: float) -> void:
	get_input(delta)

func get_dash_movement(target : Vector2, total_charge: float) -> void:
	if currently_moving:
		return
	var travel_vector : Vector2 = target - global_position
	travel_vector *= total_charge
	tween.interpolate_property(self, "global_position", global_position, global_position + travel_vector.clamped(MAX_TRAVEL_DISTANCE), 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	currently_moving = true
	print("Currently moving " + str(travel_vector.clamped(MAX_TRAVEL_DISTANCE).length()) + " pixels.")


func _on_Tween_tween_all_completed() -> void:
	currently_moving = false
