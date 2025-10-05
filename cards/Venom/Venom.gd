extends Attack

class_name Venom

func execute(user, target):
	print("Used Venom Attack")
	super.execute(user, target)
	
	if target.has_method("apply_status"):
		target.apply_status("poison", {"amount": 5, "duration": 99})
	
	
