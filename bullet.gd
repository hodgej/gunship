extends KinematicBody


var speed = -100
var explodes = true
var timeToExplode = 2
var explosionForce = 30

func _process(delta):
	move_and_slide(global_transform.basis.z*speed)


func _on_Area_body_entered(body):
	if body.is_in_group("static"):
		set_process(false)
		$trail.emitting = false
		print("Enter")
		$impact.emitting = true
		$impact/impactTimer.start()
		
		if explodes:
			$explosion/timeToExplode.start()


func explode():
	for i in $impactArea.get_overlapping_bodies():
		if i.is_in_group("explodable"):
			var dirTo = (i.translation - translation).normalized()
			i.apply_central_impulse(dirTo*explosionForce)


func _on_timeToExplode_timeout():
	$explosion.emitting = true
	explode()
	$explosion/explosionTime.start()


func _on_explosionTime_timeout():
	$explosion.emitting = false


func _on_impactTimer_timeout():
	$impact.emitting = false

