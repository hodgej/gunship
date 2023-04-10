extends Spatial


var rotSpeed = 0.002
var mouse_sensitivity = 1
var canShoot = true
var alt = translation.y

onready var bullet = load("res://bullet.tscn")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	var newTrans = Vector3(translation.x, alt, translation.z)
	translation = (newTrans - Vector3(0,0,0)).rotated(Vector3(0,1,0), rotSpeed)
	$gun.look_at(Vector3(0,0,0), Vector3(0,1,0))


func _input(event):	
	if Input.is_action_pressed("ui_down"):
		alt-= 2
	elif Input.is_action_pressed("ui_up"):
		alt += 2
	
	if event is InputEventMouseMotion:
		$gun/Camera.rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
		$gun/Camera.rotation_degrees.x = clamp($gun/Camera.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	if event is InputEventMouseButton:
		if canShoot:
			shoot()


func shoot():
	canShoot = false 
	$shootCooldown.start()
	var b = bullet.instance()
	b.rotation = $gun/Camera.global_transform.basis.get_euler()
	b.translation = self.translation - Vector3(0,2,0)
	get_parent().add_child(b)


func _on_shootCooldown_timeout():
	canShoot = true
