
/datum/spacepod/equipment
	var/obj/spacepod/my_atom
	var/obj/item/device/spacepod_equipment/weaponry/weapon_system // weapons system
	//var/obj/item/device/spacepod_equipment/engine/engine_system // engine system
	//var/obj/item/device/spacepod_equipment/shield/shield_system // shielding system

/datum/spacepod/equipment/New(var/obj/spacepod/SP)
	..()
	if(istype(SP))
		my_atom = SP

/obj/item/device/spacepod_equipment
	name = "equipment"
// base item for spacepod weapons

/obj/item/device/spacepod_equipment/weaponry
	name = "pod weapon"
	desc = "You shouldn't be seeing this"
	icon = 'icons/pods/ship.dmi'
	icon_state = "blank"
	var/projectile_type
	var/shot_cost = 0
	var/shots_per = 1
	var/fire_sound
	var/fire_delay = 10
	var/list/construction_cost = list("metal"=1000,"glass"=500)
	var/construction_time = 75
	var/locked = 1

/obj/item/device/spacepod_equipment/weaponry/taser
	name = "\improper taser weapons system"
	desc = "A weak taser system for space pods, fires electrodes that shock upon impact."
	icon_state = "pod_taser"
	projectile_type = "/obj/item/projectile/energy/electrode"
	shot_cost = 10
	fire_sound = "sound/weapons/Taser.ogg"
	construction_cost = list("metal" = 5000, "glass" = 1000, "uranium" = 500)
	construction_time = 75

/obj/item/device/spacepod_equipment/weaponry/taser/burst
	name = "\improper burst taser weapons system"
	desc = "A weak taser system for space pods, this one fires 3 at a time."
	icon_state = "pod_b_taser"
	shot_cost = 20
	shots_per = 3
	construction_cost = list("metal" = 5000, "glass" = 1000, "uranium" = 500, "gold" = 500)
	construction_time = 75

/obj/item/device/spacepod_equipment/weaponry/laser
	name = "\improper laser weapons system"
	desc = "A weak laser system for space pods, fires concentrated bursts of energy"
	icon_state = "pod_w_laser"
	projectile_type = "/obj/item/projectile/beam"
	shot_cost = 15
	fire_sound = 'sound/weapons/Laser.ogg'
	fire_delay = 25
	construction_cost = list("metal" = 5000, "glass" = 1000, "uranium" = 500, "diamond" = 500, "gold" = 500)
	construction_time = 75

/obj/item/device/spacepod_equipment/weaponry/clown
	name = "\improper Honk weapons system"
	desc = "A Honk system for space pods, fires concentrated bursts of Honk energy"
	icon_state = "pod_w_honk"
	shot_cost = 5
	fire_sound = 'sound/items/bikehorn.ogg'
	fire_delay = 25
	construction_cost = list("metal" = 5000, "glass" = 1000, "silver" = 500)
	construction_time = 75