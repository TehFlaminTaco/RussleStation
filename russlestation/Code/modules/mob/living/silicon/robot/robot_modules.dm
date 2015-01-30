/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS | CONDUCT

	var/list/modules = list()
	var/channels = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null


	emp_act(severity)
		if(modules)
			for(var/obj/O in modules)
				O.emp_act(severity)
		if(emag)
			emag.emp_act(severity)
		..()
		return


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.emag = new /obj/item/toy/sword(src)
		src.emag.name = "Placeholder Emag Item"
//		src.jetpack = new /obj/item/toy/sword(src)
//		src.jetpack.name = "Placeholder Upgrade Item"
		return


/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R)
	return

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/weapon/robot_module/standard
	name = "standard robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.emag = new /obj/item/weapon/melee/energy/sword(src)
		return

/obj/item/weapon/robot_module/standard/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/melee/baton/B = locate() in src.modules
	if(B.charges < 10)
		B.charges += 1

/obj/item/weapon/robot_module/medical
	name = "medical robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		//src.modules += new /obj/item/borg/sight/hud/med(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.modules += new /obj/item/weapon/reagent_containers/borghypo(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
		src.modules += new /obj/item/weapon/extinguisher/mini(src)
		src.emag = new /obj/item/weapon/reagent_containers/spray(src)

		src.emag.reagents.add_reagent("pacid", 250)
		src.emag.name = "Polyacid spray"
		return

/obj/item/weapon/robot_module/medical/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)

/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		//src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/weapon/rcd/borg(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
//		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/weapon/weldingtool/largetank(src)
		src.modules += new /obj/item/weapon/screwdriver(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/weapon/wirecutters(src)
		src.modules += new /obj/item/device/multitool(src)
		src.modules += new /obj/item/device/t_scanner(src)
		src.modules += new /obj/item/device/analyzer(src)
		src.modules += new /obj/item/taperoll/engineering(src)

		var/obj/item/stack/sheet/metal/cyborg/M = new /obj/item/stack/sheet/metal/cyborg(src)
		M.amount = 50
		src.modules += M

		var/obj/item/stack/sheet/rglass/cyborg/G = new /obj/item/stack/sheet/rglass/cyborg(src)
		G.amount = 50
		src.modules += G

		var/obj/item/weapon/cable_coil/W = new /obj/item/weapon/cable_coil(src)
		W.amount = 50
		src.modules += W

		return


/obj/item/weapon/robot_module/engineering/respawn_consumable(var/mob/living/silicon/robot/R)
	var/list/stacks = list (
		/obj/item/stack/sheet/metal,
		/obj/item/stack/sheet/rglass,
		/obj/item/weapon/cable_coil,
	)
	for(var/T in stacks)
		var/O = locate(T) in src.modules
		if(O)
			if(O:amount < 50)
				O:amount++
		else
			src.modules -= null
			O = new T(src)
			src.modules += O
			O:amount = 1
	return



/obj/item/weapon/robot_module/security
	name = "security robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		//src.modules += new /obj/item/borg/sight/hud/sec(src)
		src.modules += new /obj/item/weapon/book/manual/security_space_law(src)
		src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
		src.modules += new /obj/item/taperoll/police(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/gun/energy/taser/cyborg(src)
		src.emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)
		return

/obj/item/weapon/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0
	var/obj/item/weapon/melee/baton/B = locate() in src.modules
	if(B.charges < 10)
		B.charges += 1

/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/soap/nanotrasen(src)
		src.modules += new /obj/item/weapon/storage/bag/trash(src)
		src.modules += new /obj/item/weapon/mop(src)
		src.modules += new /obj/item/device/lightreplacer(src)
		src.emag = new /obj/item/weapon/reagent_containers/spray(src)

		src.emag.reagents.add_reagent("lube", 250)
		src.emag.name = "Lube spray"
		return

/obj/item/weapon/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--

/obj/item/weapon/robot_module/butler
	name = "service robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/condiment/enzyme(src)
		src.modules += new /obj/item/weapon/pen/robopen(src)

		var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
		M.matter = 30
		src.modules += M

		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)

		var/obj/item/weapon/lighter/zippo/L = new /obj/item/weapon/lighter/zippo(src)
		L.lit = 1
		src.modules += L

		src.modules += new /obj/item/weapon/tray/robotray(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/drinks/shaker(src)
		src.emag = new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)

		var/datum/reagents/R = new/datum/reagents(50)
		src.emag.reagents = R
		R.my_atom = src.emag
		R.add_reagent("beer2", 50)
		src.emag.name = "Mickey Finn's Special Brew"
		return

/obj/item/weapon/robot_module/butler/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/food/drinks/cans/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2)

/obj/item/weapon/robot_module/miner
	name = "miner robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		//src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/weapon/storage/bag/ore(src)
		src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
		src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
		src.modules += new /obj/item/device/mining_scanner(src)
//		src.modules += new /obj/item/weapon/shovel(src) Uneeded due to buffed drill
		return


/obj/item/weapon/robot_module/syndicate
	name = "syndicate robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/melee/energy/sword(src)
		src.modules += new /obj/item/weapon/gun/energy/pulse_rifle/destroyer(src)
		src.modules += new /obj/item/weapon/card/emag(src)
		return

/obj/item/weapon/robot_module/combat
	name = "combat robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
	//	src.modules += new /obj/item/borg/sight/thermal(src)
		src.modules += new /obj/item/weapon/gun/energy/laser/cyborg(src)
		src.modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
		src.modules += new /obj/item/weapon/gun/energy/taser/cyborg(src)
		src.modules += new /obj/item/borg/combat/shield(src)
		src.modules += new /obj/item/borg/combat/mobility(src)
		src.modules += new /obj/item/weapon/book/manual/security_space_law(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/taperoll/police(src)
		src.emag = new /obj/item/weapon/gun/energy/lasercannon/cyborg(src)


		return

/obj/item/weapon/robot_module/combat/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0
	var/obj/item/weapon/melee/baton/B = locate() in src.modules
	if(B.charges < 10)
		B.charges += 1


/obj/item/weapon/robot_module/surgery
	name = "medical surgery module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/grab(src)
		src.modules += new /obj/item/weapon/retractor(src)
		src.modules += new /obj/item/weapon/hemostat(src)
		src.modules += new /obj/item/weapon/cautery(src)
		src.modules += new /obj/item/weapon/surgicaldrill(src)
		src.modules += new /obj/item/weapon/scalpel(src)
		src.modules += new /obj/item/weapon/circular_saw(src)
		src.modules += new /obj/item/weapon/bonegel(src)
		src.modules += new /obj/item/weapon/FixOVein(src)
		src.modules += new /obj/item/weapon/bonesetter(src)
		var/obj/item/stack/nanopaste/B = new /obj/item/stack/nanopaste(src)
		B.amount = 10
		B.max_amount = 10
		src.modules += B

		var/obj/item/stack/medical/advanced/bruise_pack/M = new /obj/item/stack/medical/advanced/bruise_pack(src)
		M.amount = 10
		M.max_amount = 10
		src.modules += M

		var/obj/item/stack/medical/advanced/ointment/G = new /obj/item/stack/medical/advanced/ointment(src)
		G.amount = 10
		G.max_amount = 10
		src.modules += G


		src.modules += new /obj/item/device/healthanalyzer(src)
		var/obj/item/weapon/reagent_containers/borghypo/BH = new /obj/item/weapon/reagent_containers/borghypo(src)
		BH.add_reagent("stoxin")
		src.modules += BH
		src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
		src.modules += new /obj/item/weapon/extinguisher/mini(src)
		src.emag = new /obj/item/weapon/reagent_containers/spray(src)

		src.emag.reagents.add_reagent("pacid", 250)
		src.emag.name = "Polyacid spray"

		return

/obj/item/weapon/robot_module/surgery/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/list/stacks = list (
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/nanopaste,
	)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)
	for(var/T in stacks)
		var/O = locate(T) in src.modules
		if(O)
			if(O:amount < 10)
				O:amount++
		else
			src.modules -= null
			O = new T(src)
			src.modules += O
			O:amount = 1
			O:max_amount = 10

	return


/obj/item/weapon/robot_module/drone
	name = "drone module"
	var/list/stacktypes = list(
		/obj/item/stack/sheet/wood/cyborg = 1,
		/obj/item/stack/sheet/mineral/plastic/cyborg = 1,
		/obj/item/stack/sheet/rglass/cyborg = 5,
		/obj/item/stack/tile/wood = 5,
		/obj/item/stack/rods = 15,
		/obj/item/stack/tile/plasteel = 15,
		/obj/item/stack/sheet/metal/cyborg = 20,
		/obj/item/stack/sheet/glass/cyborg = 20,
		/obj/item/stack/sheet/plasteel/cyborg = 2,
		/obj/item/weapon/cable_coil = 50
		)

	New()
		src.modules += new /obj/item/device/flashlight/drone(src)
		src.modules += new /obj/item/weapon/weldingtool(src)
		src.modules += new /obj/item/weapon/screwdriver(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/weapon/wirecutters(src)
		src.modules += new /obj/item/weapon/soap/nanotrasen(src)
		src.modules += new /obj/item/device/multitool(src)
		src.modules += new /obj/item/device/lightreplacer(src)
		src.modules += new /obj/item/weapon/reagent_containers/spray/cleaner/drone(src)
		src.modules += new /obj/item/weapon/gripper(src)
		src.modules += new /obj/item/weapon/matter_decompiler(src)

		src.emag = new /obj/item/weapon/gun/energy/taser/cyborg(src)

		for(var/T in stacktypes)
			var/obj/item/stack/sheet/W = new T(src)
			W.amount = stacktypes[T]
			src.modules += W

		return

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/spray/cleaner/C = locate() in src.modules
	C.reagents.add_reagent("cleaner", 3)

	for(var/T in stacktypes)
		var/O = locate(T) in src.modules
		var/obj/item/stack/sheet/S = O

		if(!S)
			src.modules -= null
			S = new T(src)
			src.modules += S
			S.amount = 1

		if(S && S.amount < stacktypes[T])
			S.amount++

	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)

	return