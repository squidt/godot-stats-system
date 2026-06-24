class_name DeltaOp extends Delta

enum Op {
	ADD,
	SUB,
	MUL,
	DIV,
}

@export var operator := Op.ADD
@export var value := 0.0


static func make(_operator: Op, _value: float) -> DeltaOp:
	var v = DeltaOp.new()
	v.operator = _operator
	v.value = _value
	return v


static func make_add(_value: float) -> DeltaOp:
	return make(Op.ADD, _value)


static func make_sub(_value: float) -> DeltaOp:
	return make(Op.SUB, _value)


static func make_mul(_value: float) -> DeltaOp:
	return make(Op.MUL, _value)


static func make_div(_value: float) -> DeltaOp:
	return make(Op.DIV, _value)


func change(stat: Stat) -> void:
	match operator:
		Op.ADD:
			stat.base += value
		Op.SUB:
			stat.base -= value
		Op.MUL:
			stat.base *= value
		Op.DIV:
			if value != 0.0:
				stat.base /= value
