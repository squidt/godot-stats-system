class_name Hittable extends Node

## Physical representation of a stat. Directs damage from [Attack] through the [HitPipeline] and
## finally to the stat in [member card] specified by [member target_path].

const COMPONENT_NAME = "Hittable"
const HIT_PIPELINE_DEFAULT: HitPipeline = preload("uid://cbhc4rja5ihja")

## StatCard to be effected
@export var card: StatCard
## Stat to be damaged
@export var target_path: String
@export var pipeline: HitPipeline = HIT_PIPELINE_DEFAULT

var target: Stat


static func is_hittable(node: Node) -> bool:
	return node.has_meta(COMPONENT_NAME)


static func as_hittable(node: Node):
	return node.get_meta(COMPONENT_NAME) as Hittable


static func make(
	_card: StatCard, _target_path: String, _pipeline: HitPipeline = HIT_PIPELINE_DEFAULT
) -> Hittable:
	var v := Hittable.new()
	v.card = _card
	v.target_path = _target_path
	v.pipeline = _pipeline
	assert(_card)
	assert(_card.has_stat(_target_path))
	return v


func _ready() -> void:
	assert(card, "StatCard must be set")
	assert(card.has_stat(target_path), "StatCard does not have the stat @ (%s)" % [target_path])
	get_parent().set_meta(COMPONENT_NAME, self)
	target = card.get_stat(target_path)


## Sets the card and stat target for hits. Fails if [param _target_stat_name] does not exist in the
## [StatCard].[br]
## Returns true on success, false otherwise.
func set_target(_card: StatCard, _target_stat_name: StringName) -> bool:
	if _card.has_stat(_target_stat_name):
		card = _card
		target = _card.get_stat(_target_stat_name)
		return true
	return false


func hit(attack: Attack) -> void:
	assert(card)
	assert(target)

	for dmg in attack.damages:
		var piped = pipeline.pipe(card, target_path, dmg)
		target.base -= piped
	attack.apply_to(card)
