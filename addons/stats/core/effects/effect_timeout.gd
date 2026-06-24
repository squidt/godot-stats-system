class_name EffectTimeout extends Effect

@export var timer := ManualTimer.new():
	set(v):
		if is_instance_valid(v):
			timer = v


static func make_timed(_duration: float = -1.0) -> EffectTimeout:
	var v = EffectTimeout.new()
	v.timer = ManualTimer.make_timer(_duration)
	return v


func apply_to(card: StatCard) -> void:
	timer.start()
	timer.timeout.connect(remove_from.bind(card))
	card.update.connect(timer.update)
	super(card)
