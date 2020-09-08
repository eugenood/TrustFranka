extends KinematicBody

const MOUSE_SENSITIVITY = 0.12
const MOVEMENT_SPEED = 10

onready var help_text = get_parent().get_node("HelpText")
onready var franka = get_parent().get_node("Franka")
onready var camera = $Camera
onready var raycast = $Camera/RayCast

func _input(event):
	if event.is_action("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			update_view(event.relative)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			capture_mouse()
			interact()

func _physics_process(delta):
	walk(delta)
	update_help()

func update_help():
	help_text.visible = false
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if raycast.get_collider() == franka.get_node("FrankaBody"):
			help_text.visible = true
			
func capture_mouse():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func interact():
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if raycast.get_collider() == franka.get_node("FrankaBody"):
			franka.get_node("AnimationPlayer").play("default")

func walk(delta):
	var direction = Vector3()
	if Input.is_action_pressed("move_front"):
		direction -= camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += camera.global_transform.basis.x
	direction.y = 0
	direction = direction.normalized()	
	move_and_slide(direction * MOVEMENT_SPEED)

func update_view(mouse_axis):
	var horizontal = -mouse_axis.x * MOUSE_SENSITIVITY
	var vertical = -mouse_axis.y * MOUSE_SENSITIVITY
	rotate_y(deg2rad(horizontal))
	camera.rotate_x(deg2rad(vertical))
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
