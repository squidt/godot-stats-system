# !!! WARNING !!!
This addon is in the super early stages of being worked on and added to. It is not stable or feature complete.

# Features
## Stats
- `Mod` Modifiers
	- Adding and removing `Mod`s by name or value
	- Customizable, simple extend `Mod` and override `func modify()`
- `ModOp` Arithmetic Modifiers
	- Addition, Subtraction, Additive Multiplication, Division
- `Effect` Modifier packs with stat targets
- `EffectTimeout` Effects with durations that automatically remove themselves
- `EffectTick`

- `Deltas` Permanent changes
	- Addition, Subtraction, Multiplication, Division
	- Customizable, simple extend `Delta` and override `func change()`
- `Shift` Permanent change packs with stat targets
## Actions
- `Action` Packs of `Effect`s and `Shift`s that are applied to stat packs
- Can be used to represent Abilities, Spells, Conditions
## Damage System Example
- `Hittable` directs an `Attack`'s damage toward whichever stat `Hittable` represents
	- Allows for a simple health system for things like breakable props
	- Allows for complex health systems such as `HealthPool`
- `HitPipeline`
	- Customizable complexity
	- Early exiting
	- `HitHandler`
		- `Dodge`
		- `Resist`
		- `Armor`
	- `HitHandlerResult`
- `Attack` extends `Action` with an additional `Damage` array that is used by `Hittable` to direct the damage to a specific stat on hit
