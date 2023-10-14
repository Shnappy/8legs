extends CharacterBody3D

func snap_to_floor():
	var rays = [$fp0, $fp1, $fp2]
	if all(rays, func(r): return r.is_colliding() ):
		var collisions = rays.map(func(r): return r.get_collision_point())
		var n = normal(collisions[2], collisions[1], collisions[0]).rotated(Vector3(1, 0, 0), PI/2)
		look_at(global_position - n, transform.basis.y)
		move_and_collide(vec3_average(collisions) - vec3_average(rays.map(func(r): return r.global_position)))
		print("snapped to floor")

func all(a, f: Callable):
	for e in a:
		if not f.call(e):
			print ("nuh uh")
			return false
	return true

func vec3_average(a):
	return a.reduce(func(p1, p2): return p1 + p2, Vector3.ZERO) / a.size()
	
func normal(a, b, c):
	var side1 = b - a
	var side2 = c - a
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

var i = -20
func _physics_process(delta):
	i += 1
	if i > 10:
		snap_to_floor()
		i = 0

