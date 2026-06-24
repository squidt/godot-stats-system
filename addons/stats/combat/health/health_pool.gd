@abstract
class_name HealthPool extends StatFill


func fill_pool() -> void:
	base = value_max.base
	for prop in get_property_list():
		if prop.name in self:
			var got := get(prop.name)
			if got is HealthPart:
				got.base = got.value_max.base
