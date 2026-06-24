class_name Attribute extends Stat

## A Derived stat that matches a [Stat]'s values after applying a formula.[br]
## i.e. var carry_weight := Attribute.make_soft_cap(strength, start, max_level, limit) would make an
## attribute deriving from 'strength' that starts at 'start', when 'strength' is at 'max_level' the
## attribute's [member base] value will be at start + (limit / 2.0). Attributes can still act as
## normal stats and be targeted by [Action], [Effect], or [Shift] to act as bonuses or debuffs.


## Derives a value based on [param from] which falls along an exponential curve where [param start]
## is the start, [param limit] is the derived value's limit, and that limit is reached when
## [param from] reaches [param max_level].
static func make_soft_cap(from: Stat, max_level: float, start: float, limit: float) -> Attribute:
	var v := Attribute.new()
	var rate = get_exp_rate(max_level, start, limit)
	var calc = func(): v.base = start + soft_cap(from.get_value(), rate, limit - start)

	# Set initial value
	calc.call()

	# Connect stat to our calculate lambda
	# .unbind(1) unbinds the 'delta' value from 'value_changed' signal
	from.value_changed.connect(calc.unbind(1))
	from.base_changed.connect(calc.unbind(1))
	return v


static func get_exp_rate(max_level: float, start: float, limit: float) -> float:
	var diff = limit - start if !is_equal_approx(start, limit) else 1.0
	var ratio = (limit / 2.0) / diff
	if ratio <= 0.0 or ratio >= 1.0:
		return log(2.0) / (max_level / 2.0)
	return -log(ratio) / (max_level / 2.0)


static func soft_cap(x: float, rate: float, limit: float) -> float:
	return limit * (1.0 - exp(-rate * x))


func _to_string() -> String:
	return str("%.2f" % get_value())
