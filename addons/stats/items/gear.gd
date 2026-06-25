class_name Gear extends Resource

@export var name: String
## Comma separated list of tags. Allows [EquipSlot] to require or exlude tags
@export var tags: StringName
## Action executed on equip
@export var action: Effect
@export var armor := ArmorBallistic.new()
