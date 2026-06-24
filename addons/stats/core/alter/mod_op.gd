class_name ModOp extends Mod

enum Op { ADD, SUB, MUL, DIV }

@export var operator := Op.ADD
@export var value: float


static func make_add(_value: float) -> ModOp:
	var v := ModOp.new()
	v.operator = Op.ADD
	v.value = _value
	return v


static func make_sub(_value: float) -> ModOp:
	var v := ModOp.new()
	v.operator = Op.SUB
	v.value = _value
	return v


static func make_mul(_value: float) -> ModOp:
	var v := ModOp.new()
	v.operator = Op.MUL
	v.value = _value
	return v


static func make_div(_value: float) -> ModOp:
	var v := ModOp.new()
	v.priority = -100
	v.operator = Op.DIV
	v.value = _value
	return v


func apply_to(stat: Stat):
	stat.push(self)


func remove_from(stat: Stat):
	stat.erase(self)


# total = modify(base, total)
func modify(base: float, total: float) -> float:
	var result: float = 0.0
	match operator:
		Op.ADD:
			result = total + value
		Op.SUB:
			result = total - value
		Op.MUL:
			# First iteration
			if is_equal_approx(total, base):
				result = base * value
			else:
				result = total + (base * value)
		Op.DIV:
			result = total / value if !is_zero_approx(value) else total
		_:
			result = total
	return result
