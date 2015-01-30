/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/SP_parts
	name = "space pod part"
	icon = 'icons/pods/ship.dmi'
	icon_state = "blank"
	w_class = 5
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "programming=2;materials=2"
	var/construction_time = 100
	var/list/construction_cost = list("metal"=20000,"glass"=5000)


/obj/item/SP_parts/chassis
	icon = 'icons/48x48/pods.dmi'
	name="Space pod Chassis"
	icon_state = "Frame"
	var/datum/construction/construct
	construction_cost = list("metal"=20000)
	flags = FPRINT | CONDUCT
	bound_width = 64
	bound_height = 64

	attackby(obj/item/W as obj, mob/user as mob)
		if(!construct || !construct.action(W, user))
			..()
		return

	attack_hand()
		return

/////////// Ripley




/obj/item/SP_parts/part/window
	name="Space Pod Window"
	desc="A window for a Space Pod"
	icon_state = "window"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("glass"=25000)

/obj/item/SP_parts/part/engine
	name="Spade Pod Engine"
	desc="A Space pod engine. This is what makes it go vroom!"
	icon_state = "engine"
	origin_tech = "programming=2;materials=4;engineering=4;phorontech= 3"
	construction_time = 150
	construction_cost = list("metal"=25000,"phoron"=50000)

////////////
//civilian//
////////////
/obj/item/SP_parts/chassis/civ
	name = "Civilian Space Pod Chassis"

	New()
		..()
		construct = new /datum/construction/SP/civ_chassis(src)

/obj/item/SP_parts/part/civ_plat
	name="Civilian Space Pod Plating"
	desc="The Armor for a Civilian Space Pod plating with included life support!"
	icon_state = "plating"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=40000)

/obj/item/SP_parts/part/civ_armor
	name="Civilian Space Pod Armor"
	desc="The Armor for a Civilian Space Pod!"
	icon_state = "armor"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=40000,"diamond"=10000)


/////////////////
//gold civilian//
////////////////
/obj/item/SP_parts/chassis/gciv
	name = "Gold Civilian Space Pod Chassis"

	New()
		..()
		construct = new /datum/construction/SP/gciv_chassis(src)

/obj/item/SP_parts/part/gciv_plat
	name="Gold Civilian Space Pod Plating"
	desc="The Armor for a Gold Civilian Space Pod plating with included life support!"
	icon_state = "gplating"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("gold"=40000)

/obj/item/SP_parts/part/gciv_armor
	name="Gold Civilian Space Pod Armor"
	desc="The Armor for a Civilian Space Pod!"
	icon_state = "garmor"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("gold"=40000,"diamond"=10000)

/////////////
//Millitary//
/////////////
/obj/item/SP_parts/chassis/mil
	name = "Military Space Pod Chassis"

	New()
		..()
		construct = new /datum/construction/SP/mil_chassis(src)

/obj/item/SP_parts/part/mil_plat
	name="Military Space Pod Plating"
	desc="The Armor for a Military Space Pod plating with included life support!"
	icon_state = "milplating"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=40000)

/obj/item/SP_parts/part/mil_armor
	name="Military Space Pod Armor"
	desc="The Armor for a Military Space Pod!"
	icon_state = "milarmor"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=60000,"diamond"=20000)

/////////////
//Industrial//
/////////////
/obj/item/SP_parts/chassis/indy
	name = "Industrial Space Pod Chassis"

	New()
		..()
		construct = new /datum/construction/SP/indy_chassis(src)

/obj/item/SP_parts/part/indy_plat
	name="Industrial Space Pod Plating"
	desc="The Armor for an Industrial Space Pod plating with included life support!"
	icon_state = "indyplating"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=40000)

/obj/item/SP_parts/part/indy_armor
	name="Industrial Space Pod Armor"
	desc="The Armor for an Industrial Space Pod!"
	icon_state = "indyarmor"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("metal"=50000,"diamond"=15000)

////////
//Honk//
////////

/obj/item/SP_parts/chassis/honk
	name = "Honk Pod Chassis"

	New()
		..()
		construct = new /datum/construction/SP/honk_chassis(src)

/obj/item/SP_parts/part/honk_plat
	name="Industrial Space Pod Plating"
	desc="The Armor for an Honk Pod plating with included life support!"
	icon_state = "honkplating"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("bananium"=40000)

/obj/item/SP_parts/part/honk_armor
	name="Industrial Space Pod Armor"
	desc="The Armor for an Honk Pod with included Honk Weapons system!"
	icon_state = "honkarmor"
	origin_tech = "programming=2;materials=4;biotech=2;engineering=4"
	construction_time = 200
	construction_cost = list("bananium"=50000,"diamond"=15000)
///////// Circuitboards

/obj/item/weapon/circuitboard/SP
	name = "Space Pod Circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15

	civ
		origin_tech = "programming=3"

	civ/guidance
		name = "Circuit board (Civilian Space Pod Guidance module)"
		icon_state = "mcontroller"

	civ/main
		name = "Circuit board (Civilian Space Pod Central Control module)"
		icon_state = "mainboard"

	gciv
		origin_tech = "programming=3"

	gciv/guidance
		name = "Circuit board (Gold Civilian Space Pod Guidance module)"
		icon_state = "mcontroller"

	gciv/main
		name = "Circuit board (Gold Civilian Space Pod Central Control module)"
		icon_state = "mainboard"

	mil
		origin_tech = "programming=3"

	mil/guidance
		name = "Circuit board (Gold Civilian Space Pod Guidance module)"
		icon_state = "mcontroller"

	mil/main
		name = "Circuit board (Gold Civilian Space Pod Central Control module)"
		icon_state = "mainboard"

	indy
		origin_tech = "programming=3"

	indy/guidance
		name = "Circuit board (Gold Civilian Space Pod Guidance module)"
		icon_state = "mcontroller"

	indy/main
		name = "Circuit board (Gold Civilian Space Pod Central Control module)"
		icon_state = "mainboard"

	honk
		origin_tech = "programming=3"

	honk/guidance
		name = "Circuit board (Gold Civilian Space Pod Guidance module)"
		icon_state = "mcontroller"

	honk/main
		name = "Circuit board (Gold Civilian Space Pod Central Control module)"
		icon_state = "mainboard"


