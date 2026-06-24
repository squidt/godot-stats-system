class_name EffectTick extends Effect

## This class applies mods (temporary changes to stats) once at the start, and removes them once
## [member duration] is complete. It also applies deltas once when applied and again every time
## the [member interval] has passed until [member duration] is met. If [member duration] is < 0.0
## when applied the effect is indefinite unless removed. If [member intveral] is < 0.0 when applied
## the effect applies deltas once and never again.

## Length of time to exist, -1.0 means no timeout
@export var duration: float = -1.0
## Length of time between ticks, -1.0 means no ticking (except for initial apply)
@export var interval: float = -1.0
var _timer := ManualTimer.new()
var _ticker := ManualTimer.new()


static func make_tick(_interval: float) -> EffectTick:
	var v = EffectTick.new()
	v.interval = _interval
	return v


static func make_timeout(_duration: float) -> EffectTick:
	var v = EffectTick.new()
	v.duration = _duration
	return v


static func make_tick_timeout(_interval: float, _duration: float) -> EffectTick:
	var v = EffectTick.new()
	v.interval = _interval
	v.duration = _duration
	return v


func apply(card: StatCard) -> void:
	if duration > 0.0:
		_timer.wait_time = duration
		_timer.start()
		_timer.timeout.connect(remove_from_checked.bind(card))
		card.update.connect(_timer.update)
	if interval > 0.0:
		_ticker.wait_time = interval
		_ticker.start()
		_ticker.timeout.connect(_apply_deltas.bind(card))
		card.update.connect(_ticker.update)

	# Apply temporaries once
	for target in targets:
		card.if_has_stat(
			target.path,
			func(stat: Stat):
				for mod: Mod in target.alts:
					stat.push(mod)
					card._effects.push_back(self)
		)
	# Apply permanent changes once, then on every tick
	_apply_deltas(card)


func _apply_deltas(card: StatCard) -> void:
	for target in targets:
		card.if_has_stat(
			target.path,
			func(stat: Stat):
				# Apply deltas
				for delta in target.deltas:
					delta.change(stat)
		)
