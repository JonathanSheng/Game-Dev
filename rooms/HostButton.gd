extends Button
signal set_connect_type

func ready():
	$IP.text = "IP :" + str(IP.get_local_addresses()[7]) #Gets local ip address
	

func _on_Host_pressed():
	Net.initialize_server()
	emit_signal("set_connect_type", true)
