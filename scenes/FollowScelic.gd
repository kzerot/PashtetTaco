extends Camera3D

@export_node_path("Node3D") var skelic_node
var skelic : Skelic
var target_position: Vector3
var dh = 12.0
func _ready():
	skelic = get_node(skelic_node)
	target_position.z = position.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target_position.x = skelic.position.x
	target_position.y = skelic.position.y + dh
	var target_transform = Transform3D(transform.looking_at(skelic.position + Vector3(0, dh-4.5, 0)).basis, target_position)
	transform = transform.interpolate_with(target_transform, delta*5.5)
#	transform.origin = lerp(self.transform.origin, target_position, delta*5.0)
#	transform.basis = transform.looking_at(skelic.position + Vector3(0, dh-1.5, 0)).basis
