extends Attack

class_name Bruising

func execute(user, target):
	super.execute(user, target)
	
	if target.has_method("apply_status"):
		target.apply_status("marked", {"level": 1, "duration": 1})
