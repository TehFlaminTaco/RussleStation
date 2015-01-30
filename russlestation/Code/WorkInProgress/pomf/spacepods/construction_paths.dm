////////////////////////////////
///// Construction datums //////
////////////////////////////////

/datum/construction/SP/custom_action(step, atom/used_atom, mob/user)
	if(istype(used_atom, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = used_atom
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(istype(used_atom, /obj/item/weapon/wrench))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/screwdriver))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/wirecutters))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/C = used_atom
		if(C.amount<4)
			user << ("There's not enough cable to finish the task.")
			return 0
		else
			C.use(4)
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			user << ("There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/SP/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	if(istype(used_atom, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = used_atom
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(istype(used_atom, /obj/item/weapon/wrench))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/screwdriver))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/wirecutters))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/C = used_atom
		if(C.amount<4)
			user << ("There's not enough cable to finish the task.")
			return 0
		else
			C.use(4)
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			user << ("There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1


/datum/construction/SP/civ_chassis
	steps = list(list("key"=/obj/item/SP_parts/part/civ_plat),//1
					 list("key"=/obj/item/SP_parts/part/window),//2
					 list("key"=/obj/item/SP_parts/part/engine)//3
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/SP_parts/chassis/civ/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/SP/civ/chassis(const_holder)
		const_holder.icon = 'icons/48x48/pods.dmi'
		const_holder.icon_state = "pod_civ+n"
		const_holder.density = 0
		const_holder.overlays.len = 0
		spawn()
			del src
		return


/datum/construction/reversible/SP/civ/chassis
	result = "/obj/spacepod/civilian"
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/SP_parts/part/civ_armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is secured"),
					 //7
					 list("key"=/obj/item/weapon/cell/high,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Guidance control module is secured"),
					 //8
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/SP/civ/guidance,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/SP/civ/main,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "pod_civ+n"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "pod_civ+w"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "pod_civ+n"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/weapon/circuitboard/SP/civ/main(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the guidance control module into [holder].", "You install the guidance control module into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "pod_civ+n"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the guidance control module.", "You secure the guidance control module.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the guidance control module from [holder].", "You remove the guidance control module from [holder].")
					new /obj/item/weapon/circuitboard/SP/civ/guidance(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] Adds a Power cell to [holder].", "You add a Power Cell to the [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the guidance control module.", "You unfasten the guidance control module.")
					holder.icon_state = "pod_civ+n"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the Power cell from [holder].", "You remove the Power Cell from [holder].")
					new /obj/item/weapon/cell/high(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "pod_civ+n"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "pod_civ+n"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					del used_atom
					holder.icon_state = "pod_civ+f"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "pod_civ+n"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "pod_civ+f"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					new /obj/item/SP_parts/part/civ_armor(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "pod_civ+f"
		return 1

	spawn_result()
		if(result)
			var/obj/spacepod/civilian/civ = new result(get_turf(holder))
			civ.dir = holder.dir
			spawn()
				del holder
		return
		feedback_inc("Space_pod_civ_created",1)
		return


////////////
//gold civ//
///////////

/datum/construction/SP/gciv_chassis
	steps = list(list("key"=/obj/item/SP_parts/part/gciv_plat),//1
					 list("key"=/obj/item/SP_parts/part/window),//2
					 list("key"=/obj/item/SP_parts/part/engine)//3
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/SP_parts/chassis/gciv/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/SP/gciv/chassis(const_holder)
		const_holder.icon = 'icons/48x48/pods.dmi'
		const_holder.icon_state = "pod_gciv+n"
		const_holder.density = 0
		const_holder.overlays.len = 0
		spawn()
			del src
		return


/datum/construction/reversible/SP/gciv/chassis
	result = "/obj/spacepod/gold"
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/SP_parts/part/gciv_armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is secured"),
					 //7
					 list("key"=/obj/item/weapon/cell/high,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Guidance control module is secured"),
					 //8
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/SP/gciv/guidance,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/SP/gciv/main,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "pod_gciv+n"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "pod_gciv+n"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "pod_gciv+w"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "pod_gciv+n"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "pod_gciv+n"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					del used_atom
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "pod_gciv+n"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/weapon/circuitboard/SP/gciv/main(get_turf(holder))
					holder.icon_state = "pod_gciv+n"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the guidance control module into [holder].", "You install the guidance control module into [holder].")
					del used_atom
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "pod_gciv+n"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the guidance control module.", "You secure the guidance control module.")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] removes the guidance control module from [holder].", "You remove the guidance control module from [holder].")
					new /obj/item/weapon/circuitboard/SP/gciv/guidance(get_turf(holder))
					holder.icon_state = "pod_gciv+n"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] Adds a Power cell to [holder].", "You add a Power Cell to the [holder].")
					del used_atom
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] unfastens the guidance control module.", "You unfasten the guidance control module.")
					holder.icon_state = "pod_gciv+n"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] removes the Power cell from [holder].", "You remove the Power Cell from [holder].")
					new /obj/item/weapon/cell/high(get_turf(holder))
					holder.icon_state = "pod_gciv+n"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "pod_gciv+n"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "pod_gciv+n"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "pod_gciv+n"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					del used_atom
					holder.icon_state = "pod_gold+f"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "pod_gciv+n"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "pod_gold+f"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					new /obj/item/SP_parts/part/gciv_armor(get_turf(holder))
					holder.icon_state = "pod_gciv+n"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "pod_gold+f"
		return 1

	spawn_result()
		if(result)
			var/obj/spacepod/gold/gciv = new result(get_turf(holder))
			gciv.dir = holder.dir
			spawn()
				del holder
		return
		feedback_inc("Space_pod_gciv_created",1)
		return


//////////////////////
/////Military////////
////////////////////

/datum/construction/SP/mil_chassis
	steps = list(list("key"=/obj/item/SP_parts/part/mil_plat),//1
					 list("key"=/obj/item/SP_parts/part/window),//2
					 list("key"=/obj/item/SP_parts/part/engine)//3
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/SP_parts/chassis/mil/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/SP/mil/chassis(const_holder)
		const_holder.icon = 'icons/48x48/pods.dmi'
		const_holder.icon_state = "pod_civ+n"
		const_holder.density = 0
		const_holder.overlays.len = 0
		spawn()
			del src
		return


/datum/construction/reversible/SP/mil/chassis
	result = "/obj/spacepod/nanomil"
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/SP_parts/part/mil_armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is secured"),
					 //7
					 list("key"=/obj/item/weapon/cell/high,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Guidance control module is secured"),
					 //8
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/SP/mil/guidance,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/SP/mil/main,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "pod_civ+n"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "pod_civ+w"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "pod_civ+n"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/weapon/circuitboard/SP/mil/main(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the guidance control module into [holder].", "You install the guidance control module into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "pod_civ+n"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the guidance control module.", "You secure the guidance control module.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the guidance control module from [holder].", "You remove the guidance control module from [holder].")
					new /obj/item/weapon/circuitboard/SP/mil/guidance(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] Adds a Power cell to [holder].", "You add a Power Cell to the [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the guidance control module.", "You unfasten the guidance control module.")
					holder.icon_state = "pod_civ+n"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the Power cell from [holder].", "You remove the Power Cell from [holder].")
					new /obj/item/weapon/cell/high(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "pod_civ+n"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "pod_civ+n"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					del used_atom
					holder.icon_state = "pod_mil+f"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "pod_civ+n"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "pod_mil+f"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					new /obj/item/SP_parts/part/mil_armor(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "pod_mil+f"
		return 1

	spawn_result()
		if(result)
			var/obj/spacepod/nanomil/mil = new result(get_turf(holder))
			mil.dir = holder.dir
			spawn()
				del holder
		return
		feedback_inc("Space_pod_mil_created",1)
		return

////////////////
///indy/////////
///////////////

/datum/construction/SP/indy_chassis
	steps = list(list("key"=/obj/item/SP_parts/part/indy_plat),//1
					 list("key"=/obj/item/SP_parts/part/window),//2
					 list("key"=/obj/item/SP_parts/part/engine)//3
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/SP_parts/chassis/indy/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/SP/indy/chassis(const_holder)
		const_holder.icon = 'icons/48x48/pods.dmi'
		const_holder.icon_state = "pod_civ+n"
		const_holder.density = 0
		const_holder.overlays.len = 0
		spawn()
			del src
		return


/datum/construction/reversible/SP/indy/chassis
	result = "/obj/spacepod/indy"
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/SP_parts/part/indy_armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is secured"),
					 //7
					 list("key"=/obj/item/weapon/cell/high,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Guidance control module is secured"),
					 //8
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/SP/indy/guidance,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/SP/indy/main,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "pod_civ+n"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "pod_civ+w"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "pod_civ+n"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "pod_civ+n"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "pod_civ+n"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/weapon/circuitboard/SP/indy/main(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the guidance control module into [holder].", "You install the guidance control module into [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "pod_civ+n"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the guidance control module.", "You secure the guidance control module.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the guidance control module from [holder].", "You remove the guidance control module from [holder].")
					new /obj/item/weapon/circuitboard/SP/indy/guidance(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] Adds a Power cell to [holder].", "You add a Power Cell to the [holder].")
					del used_atom
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the guidance control module.", "You unfasten the guidance control module.")
					holder.icon_state = "pod_civ+n"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] removes the Power cell from [holder].", "You remove the Power Cell from [holder].")
					new /obj/item/weapon/cell/high(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "pod_civ+n"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "pod_civ+n"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "pod_civ+n"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					del used_atom
					holder.icon_state = "pod_industrial+f"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "pod_civ+n"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "pod_industrial+f"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					new /obj/item/SP_parts/part/indy_armor(get_turf(holder))
					holder.icon_state = "pod_civ+n"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "pod_industrial+f"
		return 1

	spawn_result()
		if(result)
			var/obj/spacepod/indy/indy = new result(get_turf(holder))
			indy.dir = holder.dir
			spawn()
				del holder
		return
		feedback_inc("Space_pod_indy_created",1)
		return

////////////////
////////HONK////
///////////////

/datum/construction/SP/honk_chassis
	steps = list(list("key"=/obj/item/SP_parts/part/honk_plat),//1
					 list("key"=/obj/item/SP_parts/part/window),//2
					 list("key"=/obj/item/SP_parts/part/engine)//3
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/SP_parts/chassis/honk/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/SP/honk/chassis(const_holder)
		const_holder.icon = 'icons/48x48/pods.dmi'
		const_holder.icon_state = "pod_honk+n"
		const_holder.density = 0
		const_holder.overlays.len = 0
		spawn()
			del src
		return


/datum/construction/reversible/SP/honk/chassis
	result = "/obj/spacepod/clown"
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/SP_parts/part/honk_armor,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is secured"),
					 //7
					 list("key"=/obj/item/weapon/cell/high,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Guidance control module is secured"),
					 //8
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Guidance control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/circuitboard/SP/honk/guidance,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/weapon/circuitboard/SP/honk/main,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/weapon/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "pod_honk+n"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "pod_honk+n"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "pod_honk+w"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "pod_honk+n"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "pod_honk+n"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					del used_atom
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "pod_honk+n"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/weapon/circuitboard/SP/honk/main(get_turf(holder))
					holder.icon_state = "pod_honk+n"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the guidance control module into [holder].", "You install the guidance control module into [holder].")
					del used_atom
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "pod_honk+n"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the guidance control module.", "You secure the guidance control module.")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] removes the guidance control module from [holder].", "You remove the guidance control module from [holder].")
					new /obj/item/weapon/circuitboard/SP/honk/guidance(get_turf(holder))
					holder.icon_state = "pod_honk+n"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] Adds a Power cell to [holder].", "You add a Power Cell to the [holder].")
					del used_atom
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] unfastens the guidance control module.", "You unfasten the guidance control module.")
					holder.icon_state = "pod_honk+n"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] removes the Power cell from [holder].", "You remove the Power Cell from [holder].")
					new /obj/item/weapon/cell/high(get_turf(holder))
					holder.icon_state = "pod_honk+n"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/sheet/plasteel/MS = new /obj/item/stack/sheet/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "pod_honk+n"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "pod_honk+n"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "pod_honk+n"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					del used_atom
					holder.icon_state = "pod_clown+f"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "pod_honk+n"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "pod_clown+f"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					new /obj/item/SP_parts/part/honk_armor(get_turf(holder))
					holder.icon_state = "pod_honk+n"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "pod_clown+f"
		return 1

	spawn_result()
		if(result)
			var/obj/spacepod/clown/honk = new result(get_turf(holder))
			honk.dir = holder.dir
			spawn()
				del holder
		return
		feedback_inc("Space_pod_honk_created",1)
		return




