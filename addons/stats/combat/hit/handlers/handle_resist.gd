class_name HitHandlerResist extends HitHandler

@export var resistances_path := "resists"


func handle(out: HitHandler.Result) -> void:
	var resists = out.card.get_stat(resistances_path) as Resists
	if resists:
		out.remainder = resists.resisted(out.damage)
