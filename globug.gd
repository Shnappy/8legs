extends CharacterBody3D

func snap_to_floor():
	var rays = [$fp0, $fp1, $fp2]
	if all(rays, func(r): return r.is_colliding() ):
		var ray_roots = rays.map(func(r): return r.global_position)
		var collisions = rays.map(func(r): return r.get_collision_point())
		var rn = normal(ray_roots)
		var cn = normal(collisions)
		print("{0} - {1} = {2}\nDistance: {3}, Angle: {4}".format([rn, cn, rn-cn, rn.distance_to(cn), rn.angle_to(cn)]))

		#look_at(global_position - cn.rotated(Vector3(1, 0, 0), PI/2), transform.basis.y)
		move_and_collide(vec3_average(collisions) - vec3_average(ray_roots))
		return align_normal(rn, cn)
	print("rays are all aligned")
	return false

var attempts = 0
func align_normal(current, target):
	var axis = current.cross(target).normalized()
	var angle = current.angle_to(target)
	if not axis.is_normalized():
		print ("axis ({0}) is not normalized. Giving up after {0}")
		return false
	transform.basis = transform.basis.rotated(axis, angle)
	attempts += 1
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

func look_at_with_y(trans,new_y,v_up):
	#Y vector
	trans.basis.y=new_y.normalized()
	trans.basis.z=v_up*-1
	trans.basis.x = trans.basis.z.cross(trans.basis.y).normalized();
	#Recompute z = y cross X
	trans.basis.z = trans.basis.y.cross(trans.basis.x).normalized();
	trans.basis.x = trans.basis.x * -1   # <======= ADDED THIS LINE
	trans.basis = trans.basis.orthonormalized() # make sure it is valid 
	return trans
	
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var i = 100
func _physics_process(delta):
	i -= 1
	if i < 0 and not snap_to_floor():
		set_physics_process(false)
		print("Giving up after {0} attempts".format([attempts]))
		



