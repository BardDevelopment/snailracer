extends Node2D

export var max_players = 4
export var num_of_bots = 3

var num_of_players = max_players - num_of_bots

var player 
var bot 
var all_players = []

var start_pos := Vector2(80, 259)

# Index is player ID
var previous_rolls = []

func _ready():
	# Seeding
	randomize()

	# Load initial snail scene
	var snail = preload("../player/Player.tscn")

	# Loop for all 4 players/bots
	for i in range(0, max_players):
		var snail_racer = snail.instance()
		all_players.append(snail_racer)
		snail_racer.id = i
		
		previous_rolls.append(-1)
		snail_racer.position = start_pos

		# Next start position is 64 pixels down
		# Probably should get this from tilemap or something
		start_pos.y += 64

	# set bots
	for i in range(0, num_of_bots):
		all_players[i].is_bot = true

	for p in all_players:
		add_child(p)

		var anim = p.get_node("AnimationPlayer")
		anim.play("DiceRoll")
	
	$Timer.start()


func _physics_process(_delta):

	# Keep track of countdown timer
	$CanvasLayer/TurnTime.text = str($Timer.time_left)

	for p in all_players:

		# make sure we only run initial button press each turn
		if p.velocity != Vector2.ZERO:
			# Get current and previous roll for player ID
			var previous_roll = previous_rolls[p.id]		
			var roll = dice_roll()
		
			# Save past roll
			previous_rolls[p.id] = roll		
		
			set_dice_anim(p, roll)
					
			if previous_roll == roll:
				roll *= 2

			p.velocity = p.move_and_slide(p.velocity * (p.speed * roll))


# TODO: Probably need to renamed
func _on_Timer_timeout():
	""" timeout for each turn
	"""

	for p in all_players:
		p.pressed = false
		var anim = p.get_node("Dice")
		anim.animation = "Roll"
		
		
# Dice Roll returns the value of the roll and whether it was doubled or not
func dice_roll(size: int=6) -> int:
	""" Generate a random number between 1 and dice size
	Args:

	  size: largest value on the die. It should be 6 considering the art in
	  place

	"""
	
	return randi()%size+1


func set_dice_anim(p, roll):
	""" set_dice_anim sets the animation to play when selecting 
	face value of the die.

	Args:

	  p: player or bot to set dice animation of
	  roll: what value to stop on the die

	"""

	var anim = p.get_node("Dice")


	# TODO: Start partical selection thing

	match roll:
		1:
			anim.animation = "One"
		2:
			anim.animation = "Two"
		3:
			anim.animation = "Three"
		4:
			anim.animation = "Four"
		5:
			anim.animation = "Five"
		6:
			anim.animation = "Six"
