class_name ManualTimer extends Resource

signal timeout

## How long the timer lasts
@export var wait_time: float = -1.0

var one_shot: bool = true
## Time remaining for the duration
var _time_left = -1.0


static func make_timer(_wait_time: float, _one_shot := true) -> ManualTimer:
	var v = ManualTimer.new()
	v.wait_time = _wait_time
	v.one_shot = _one_shot
	return v


func is_stopped() -> bool:
	return _time_left <= 0.0


func start() -> void:
	_time_left = wait_time


func stop() -> void:
	_time_left = -1.0


func update(delta: float) -> void:
	if _time_left > 0.0:
		_time_left -= delta
		if is_equal_approx(_time_left, 0.0) or _time_left < 0.0:
			timeout.emit()
			if one_shot:
				stop()
			else:
				_time_left = wait_time
