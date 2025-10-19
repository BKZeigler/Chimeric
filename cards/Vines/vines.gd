extends Attack

class_name Vines


func execute(user, target):
	super.execute(user, target)
	
	if target.has_method("apply_status"):
		target.apply_status("tangled", {"fill": null, "duration": 2})
