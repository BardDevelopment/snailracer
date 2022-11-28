extends Node2D


func _ready():

	for c in self.get_children():
		var collision = c.get_node("CollisionShape2D")
		collision.disabled = false

		c.connect("finished_race", get_parent(), "_on_finished_race")
