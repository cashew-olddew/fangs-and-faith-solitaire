extends Node2D

# TODO: DELETE BEFORE RELEASE OR SET A DEBUG MODE PROJECT VARIABLE (BETTER)
# This component is a debug overlay on top of everything
func _process(delta):
	#queue_redraw()
	pass

func _draw():
	#for card in owner.normal_cards:
		#if card.right_neighbor:
			#var right_neighbors_count = 0
			#var temp_right_n = card.right_neighbor
			#while(temp_right_n):
				#right_neighbors_count += 1
				#temp_right_n = temp_right_n.right_neighbor
			#var start = card.global_position - Vector2(card.back_texture.get_width() / 2., right_neighbors_count * 20)
			#var end = card.right_neighbor.global_position - Vector2(card.back_texture.get_width() / 2., right_neighbors_count * 20)
			#draw_line(to_local(start), to_local(end), Color.WEB_GREEN, 5.0)
#
			#var dir = (end - start).normalized()
			#var perp = Vector2(-dir.y, dir.x) * 10
			#var head_base = end - dir * 20
			#draw_line(to_local(end), to_local(head_base + perp), Color.WEB_GREEN, 5.0)
			#draw_line(to_local(end), to_local(head_base - perp), Color.WEB_GREEN, 5.0)
			#
		#if card.left_neighbor:
			#var left_neighbors_count = 0
			#var temp_left_n = card.left_neighbor
			#while(temp_left_n):
				#left_neighbors_count += 1
				#temp_left_n = temp_left_n.left_neighbor
			#var start = card.global_position - Vector2(card.back_texture.get_width() / 2.0, -left_neighbors_count * 20)
			#var end = card.left_neighbor.global_position - Vector2(card.back_texture.get_width() / 2.0, -left_neighbors_count * 20)
			#draw_line(to_local(start), to_local(end), Color.ORANGE_RED, 5.0)
#
			#var dir = (end - start).normalized()
			#var perp = Vector2(-dir.y, dir.x) * 10
			#var head_base = end - dir * 20
			#draw_line(to_local(end), to_local(head_base + perp), Color.ORANGE_RED, 5.0)
			#draw_line(to_local(end), to_local(head_base - perp), Color.ORANGE_RED, 5.0)
	pass
