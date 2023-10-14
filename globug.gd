extends CharacterBody3D

func snap_to_floor():
	var rays = [$fp0, $fp1, $fp2]
	if all(rays, func(r): return r.is_colliding() ): #TODO try a few random (or cardinal) rays if this fails
		var ray_roots = rays.map(func(r): return r.global_position)
		var collisions = rays.map(func(r): return r.get_collision_point())

		move_and_collide(vec3_average(collisions) - vec3_average(ray_roots))
		return align_normal(normal(ray_roots), normal(collisions))
	return false

func align_normal(current, target):
	var axis = current.cross(target).normalized()
	var angle = current.angle_to(target)
	if not axis.is_normalized():
		return false
	if angle < 0.1:
		return false
	transform.basis = transform.basis.rotated(axis, angle)
	return true

func all(a, f: Callable):
	for e in a:
		if not f.call(e):
			return false
	return true

func vec3_average(a):
	return a.reduce(func(p1, p2): return p1 + p2, Vector3.ZERO) / a.size()
	
func normal(a):
	var side1 = a[1] - a[0]
	var side2 = a[2] - a[0]
	return side1.cross(side2)

func recursive_snap_to_floor():
	if snap_to_floor():
		recursive_snap_to_floor()

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	recursive_snap_to_floor()
	set_physics_process(false)
