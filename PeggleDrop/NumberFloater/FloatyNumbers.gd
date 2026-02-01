extends Node

func displayNumber(value: int, position: Vector2) -> void:
	var number: Label = Label.new()
	number.text = str(value)
	number.position = position
	number.z_index = 100
	number.label_settings = LabelSettings.new()

	var color = "#FFF"
	if value > 2:
		color = "#ECA013"
	if value > 5:
		color = "#C88422"
	if value > 10:
		color = "#A41414"
	if value > 50:
		color = "#E90000"
	if value > 100:
		color = "#09FC00"
	if value > 200:
		color = "#FF00F3"

	number.label_settings.font_color = color
	number.label_settings.font_size = int(lerp(30, 60, clampf(value / 200.0, 0, 1)))
	number.label_settings.outline_size = 1
	number.label_settings.outline_color = "#000000"

	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size.x / 2, number.size.y / 2)

	var tween = get_tree().create_tween()
	tween.tween_property(number, "position", position + Vector2(0, -150), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(number, "scale", Vector2(2, 2), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_delay(0.5)
	await tween.finished
	number.queue_free()
