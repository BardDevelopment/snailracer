extends Area2D

signal finished_race(id)

func _ready():
	pass


func emit_particals() -> void:
	$NearParticals.emitting = true
	$FarParticals.emitting = true


func _on_Post_body_entered(body):
	emit_particals()
	emit_signal("finished_race", body.id)
