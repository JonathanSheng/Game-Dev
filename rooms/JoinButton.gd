extends Button

signal set_connect_type


func _on_Join_pressed():
	if $IP.text.is_valid_ip_address():
		join()
	else:
		$Invalid_IP.show()
func join():
	Net.initialize_client($IP.text)
	emit_signal("set_connect_type", false)
