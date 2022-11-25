extends KinematicBody2D

export (int) var id
export (bool) var is_bot = false
export (int) var speed = 100
export (bool) var pressed = true

var velocity := Vector2()

func _ready() -> void:
	# TODO: kinda a problem for more than one player 
	# consider a split screen?
	if not is_bot:
		$Camera2D.current = true

# bot input
func bot_input():

	velocity = Vector2()

	if not pressed:
		pressed = true
		velocity.x += 1
		$TrailParticals.emitting = true

	velocity = velocity.normalized()
	# velocity = velocity.normalized() * speed


# Player
func get_input():

	velocity = Vector2()
	if Input.is_action_just_pressed("move") and not pressed:
		pressed = true
		velocity.x += 1
		$TrailParticals.emitting = true

	velocity = velocity.normalized()
	# velocity = velocity.normalized() * speed

func _physics_process(_delta):

	if is_bot:
		bot_input()
	else:
		get_input()
