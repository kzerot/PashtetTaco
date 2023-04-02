extends CharacterBody3D
class_name Skelic
signal died
const MAX_SPEED = 20.0
const JUMP_VELOCITY = 4.0*10
var speed = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 10.0
var additional_gravity = {}
var last_dir = -1
@onready var animtree : AnimationTree = $AnimationTree
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var mesh : Node3D = $Manny_Armature
var tween: Tween
var with_hat = false
var with_pan = false
var flying_with_hat = false
# cheat, instead of raycast to legs
var frames_in_fly = 0
func _ready():
	animtree.set("parameters/Start/current_state", "start")
	animtree.active = false
	set_physics_process(false)
	self.hide()
	
func pause():
	animtree.active = false
	set_physics_process(false)
	
func unpause():
	animtree.active = true
	set_physics_process(true)
	
	
func uncover():
	animtree.active = true
	animtree.set("parameters/Start/transition_request", "start")
	self.show()

func start_uncovered():
	animtree.active = true
	animtree.set("parameters/Start/transition_request", "game")
	self.show()
	set_physics_process(true)
	
func use_hat(b: bool=true):
	$Manny_Armature/Skeleton3D/HAT.visible = b
	with_hat = true
		
func use_pan(b: bool=true):
	%pan.visible = b
	with_pan = true
	
func _input(event: InputEvent):
	if with_hat:
		if event.is_action_pressed("hat"):
			flying_with_hat = true
		elif event.is_action_released("hat"):
			flying_with_hat = false
	
func _physics_process(delta):
	
	if is_on_floor():
		frames_in_fly = 0
	else:
		frames_in_fly += 1
	
	var current_state = animtree.get("parameters/movement/current_state")
	var current_fly_state = animtree.get("parameters/jump/current_state")
	# Add the gravity.
	if not is_on_floor():
		if not current_state == "jump" and frames_in_fly >= 10:
			animtree.set("parameters/movement/transition_request", "jump")
			animtree.set("parameters/jump/transition_request", "in_air_hat" if flying_with_hat else "in_air")
		if flying_with_hat:
			if velocity.y < 0.0:
				velocity.y -= gravity * delta * 0.25
			else:
				velocity.y -= gravity * delta
			for g in additional_gravity.values():
				velocity.y = g
		else:
			velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animtree.set("parameters/movement/transition_request", "jump")
		animtree.set("parameters/jump/transition_request", "begin_jump")


	if with_hat and current_state == "jump":
		if current_fly_state == "in_air" and flying_with_hat:
			animtree.set("parameters/jump/transition_request", "in_air_hat")
		elif current_fly_state == "in_air_hat" and not flying_with_hat:
			animtree.set("parameters/jump/transition_request", "in_air")
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_axis("left", "right")
	var direction = (transform.basis * Vector3(0, 0, input_dir)).normalized()
	if direction:
		speed = max(MAX_SPEED/3.0, move_toward(speed, MAX_SPEED, delta*7))
	else:
		speed = move_toward(speed, 0, delta*10)
	
	if sign(direction.x) != last_dir and not is_zero_approx(direction.x):
		speed = MAX_SPEED/3.0*sign(velocity.x)
		if last_dir == 1:
			tween = create_tween()
			tween.tween_property(mesh, "rotation:y", 0, 0.3)
		else:
			tween = create_tween()
			tween.tween_property(mesh, "rotation:y", PI, 0.3)
		last_dir = sign(direction.x)
	
	velocity.x = direction.x * speed

	var is_jumping = false
	if current_state == "jump":
		if is_on_floor():
#			if animplayer.is_playing():
			animtree.set("parameters/jump/transition_request", "end_jump")
		else:
			is_jumping = true
			
	if is_jumping:
		pass
	elif is_zero_approx(velocity.x) and current_state == "move":
		animtree.set("parameters/movement/transition_request", "idle")
	elif not is_zero_approx(velocity.x):
		if current_state != "move":
			animtree.set("parameters/movement/transition_request", "move")
			print('-move')
		animtree.set("parameters/moving/blend_amount", speed/MAX_SPEED)
		animtree.set("parameters/move_speed/scale", 1.0 + 0.5*speed/MAX_SPEED)
#		animplayer.speed_scale = 1.0 + speed/MAX_SPEED

	if position.y <= 0:
		# DEATH
		# for now just restart level
		died.emit()
	move_and_slide()
	
	$Fly.text = current_fly_state
	$State.text = current_state

func _on_animation_tree_animation_finished(anim_name):
	print("Finished ", anim_name)
	if anim_name == "JumpFinish" and is_on_floor():
		animtree.set("parameters/movement/transition_request", "idle")
	if anim_name == "StartAnim":
		set_physics_process(true)
		
	
