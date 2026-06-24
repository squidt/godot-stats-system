class_name HitHandlerArmor extends HitHandler

@export var armor_path := "armor"


func handle(out: HitHandler.Result) -> void:
	var armor := out.card.get_stat(armor_path) as ArmorBallisticPool
	if armor and out.damage is DamageBallistic:
		armor.try_armor(out)
