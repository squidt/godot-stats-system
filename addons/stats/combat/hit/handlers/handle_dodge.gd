class_name HitHandlerDodge extends HitHandler


func handle(out: HitHandler.Result) -> void:
	out.is_aborted = false  #bool(randi_range(0, 1))
