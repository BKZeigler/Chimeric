extends Attack

class_name SpecialStrike

func execute(user, target):
	print("This strike is special!!!")
	super.execute(user, target)
	
	if target.has_method("apply_status"):
		target.apply_status("bleed", {"damage": 1, "duration": 3})
