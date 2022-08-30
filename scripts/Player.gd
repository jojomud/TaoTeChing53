extends KinematicBody

 
export var MOVE_SPEED = 10
const JUMP_FORCE = 20
const GRAVITY = -30
const MAX_FALL_SPEED = 50
export var MAX_SPEED = 20
export var ACCELERATION = 2
export var DECELERATION = 10
export var IN_AIR_ACCELERATION = 1
export var IN_AIR_DECELERATION = 0.1
var Is_Sprinting = false

const H_LOOK_SENS = 0.3
const V_LOOK_SENS = 0.3
 
onready var cam = $Camera
 
var y_velo = 0

var velocity : Vector3
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 
func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS #im not sure why this works but it allows for camera movement
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90) 
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS
 
func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("Move_Forward"):#these are the basic inputs
		move_vec.z -= 1
	if Input.is_action_pressed("Move_Backward"):
		move_vec.z += 1
	if Input.is_action_pressed("Move_Right"):
		move_vec.x += 1
	if Input.is_action_pressed("Move_Left"):
		move_vec.x -= 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	
	if move_vec.length_squared() > 1:
		move_vec /= move_vec.length()

	velocity.y += delta * GRAVITY
	
	var hvel = velocity
	hvel.y = 0

	var target = move_vec * MAX_SPEED #this is handles caracter acceleration and decceleration
	var acceleration
	if is_on_floor():
		if move_vec.dot(hvel) > 0:
			acceleration = ACCELERATION
		else:
			acceleration = DECELERATION
	elif not is_on_floor():
		if move_vec.dot(hvel) > 0:
			acceleration = IN_AIR_ACCELERATION
		else:
			acceleration = IN_AIR_DECELERATION

	hvel = hvel.linear_interpolate(target, acceleration * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	velocity = move_and_slide(velocity, Vector3.UP)

	
	if Input.is_action_pressed("escape"):
		get_tree().quit()
		
