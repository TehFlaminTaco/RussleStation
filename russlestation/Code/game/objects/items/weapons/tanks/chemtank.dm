/obj/item/weapon/reagent_containers/glass/chemtank
	name = "S.T.A.N.D. Chem Tank"
	desc = "A chemtank backpack with alot of chemical storage."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "waterbackpack"
	item_state = "waterbackpack"
	w_class = 4.0
	slot_flags = SLOT_BACK
	flags = FPRINT | OPENCONTAINER| TABLEPASS
	slowdown = 3
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(25,50,100)
	volume = 500
	can_be_placed_into = null
	var/fillup = 1


	verb/toggle()
		set category = "Object"
		set name = "Toggle Fillup"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.fillup)
				src.fillup = !src.fillup
				usr << "You Open the refill Valve on the tank."

			else
				src.fillup = !src.fillup
				usr << "You Close the refill valve on the tank."

/obj/item/weapon/reagent_containers/glass/chemtank/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/chemtank/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/chemtank/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/chemtank/attack_hand()
	..()
	update_icon()


/obj/item/weapon/reagent_containers/glass/chemtank/attack_self()
	toggle()

/obj/item/weapon/reagent_containers/glass/chemtank/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "waterbackpack10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "waterbackpack-10"
			if(10 to 24) 	filling.icon_state = "waterbackpack10"
			if(25 to 49)	filling.icon_state = "waterbackpack25"
			if(50 to 74)	filling.icon_state = "waterbackpack50"
			if(75 to 79)	filling.icon_state = "waterbackpack75"
			if(80 to 90)	filling.icon_state = "waterbackpack80"
			if(91 to INFINITY)	filling.icon_state = "waterbackpack100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/glass/chemtank/New()
	..()
	create_reagents(volume)
	return




/obj/item/weapon/reagent_containers/glass/chemtank/Del()
	..()
	return

/obj/item/weapon/reagent_containers/glass/chemtank/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(no_attack==1)return
	if(istype(G, /obj/item/weapon/reagent_containers/glass))
		if(fillup)
			if(G.is_open_container() && G.reagents)
				if(!G.reagents.total_volume && G.reagents)
					user << "\red [G] is empty."
					return

				if(reagents.total_volume >= reagents.maximum_volume)
					user << "\red [src] is full."
					return

				var/trans = G.reagents.trans_to(src, G:amount_per_transfer_from_this)
				user << "\blue You fill [src] with [trans] units of the contents of [G]."
		else if(!fillup)
			if(src.is_open_container() && src.reagents) //Something like a glass. Player probably wants to transfer TO it.
				if(!reagents.total_volume)
					user << "\red [src] is empty."
					return

				if(G.reagents.total_volume >= G.reagents.maximum_volume)
					user << "\red [G] is full."
					return

				var/trans = src.reagents.trans_to(G, amount_per_transfer_from_this)
				user << "\blue You transfer [trans] units of the solution to [G]."
	if(istype(G, /obj/item/weapon/mop))
		if(!fillup)
			if(G.reagents.total_volume < G.reagents.maximum_volume)
				if(reagents.total_volume < 1)
					user << "[src] is out of chemicals!</span>"
				else
					reagents.trans_to(G, 5)        //
					user << "<span class='notice'>You wet [G] with the [src].</span>"
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					return


/obj/item/weapon/reagent_containers/glass/chemtank/afterattack(obj/target, mob/user , flag)
	if(fillup)
		if (!is_open_container() || !flag)
			return

		for(var/type in src.can_be_placed_into)
			if(istype(target, type))
				return

		if(istype(target,/obj/structure/table))
			return
		if(istype(target,/obj/structure/sink))
			return
		if(istype(target,/obj/structure/rack))
			return
		if(istype(target,/obj/structure/closet))
			return
		if(ismob(target) && target.reagents && reagents.total_volume)
			user << "\blue You splash the solution onto [target]."


			var/mob/living/M = target
			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			target.griefcheck += "\[[time_stamp()]\] [user.name]([user.ckey]) Splashed [contained] from a [src.name] on to [target].<BR><BR>"
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] has been splashed with something by []!", target, user), 1)
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return

		else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."


		else if(istype(target, /obj/item/clothing/suit/space/space_ninja))
			return

		else if(istype(target, /obj/machinery/bunsen_burner))
			return

		else if(istype(target, /obj/machinery/radiocarbon_spectrometer))
			return

		else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

		else if(reagents.total_volume)
			user << "\blue You splash the solution onto [target]."
			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			target.griefcheck += "\[[time_stamp()]\] [user.name]([user.ckey]) Splashed [contained] from a [src.name] on to [target].<BR><BR>"
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return



/obj/item/weapon/reagent_containers/glass/chemtank/janitank
	name = "J.A.N.I. Chem Tank"
	desc = "A chemtank backpack with alot of chemical storage."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "janitank"
	item_state = "janitank"
	var/obj/item/weapon/mop/mymop = null
	var/signs = 0

/obj/item/weapon/reagent_containers/glass/chemtank/janitank/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(no_attack==1)return
	..()
	if(istype(G, /obj/item/weapon/mop))
		if(!mymop)
			user.drop_item()
			mymop = G
			G.loc = src
			update_icon()
			remove_items(user)
			user << "<span class='notice'>You put [G] into [src].</span>"
			if(!signs)
				verbs += /obj/item/weapon/reagent_containers/glass/chemtank/janitank/proc/remove_items
	else if(istype(G, /obj/item/weapon/caution))
		if(signs < 2)
			user.drop_item()
			G.loc = src
			signs++
			update_icon()
			remove_items(user)
			user << "<span class='notice'>You put [G] into [src].</span>"
			if(!mymop)
				verbs += /obj/item/weapon/reagent_containers/glass/chemtank/janitank/proc/remove_items
		else
			user << "<span class='notice'>[src] can't hold any more signs.</span>"

/obj/item/weapon/reagent_containers/glass/chemtank/janitank/update_icon()
	..()
	if(signs)
		if(!mymop)
			icon_state = "janitank_s[signs]"
			item_state = "janitank_s[signs]"
		else
			icon_state = "janitank_m_s[signs]"
			item_state = "janitank_m_s[signs]"
	if(!signs)
		if(!mymop)
			icon_state = "janitank"
			item_state = "janitank"
		else
			icon_state = "janitank_m"
			item_state = "janitank_m"
	usr.regenerate_icons()

/obj/item/weapon/reagent_containers/glass/chemtank/janitank/proc/remove_items(mob/user)
	set name = "Remove Supplies"
	set category = "Object"
	set src in usr

	user.set_machine(src)
	var/dat
	if(mymop)
		dat += "<a href='?src=\ref[src];mop=1'>[mymop.name]</a><br>"
	if(signs)
		dat += "<a href='?src=\ref[src];sign=1'>[signs] sign\s</a><br>"
	var/datum/browser/popup = new(user, "janitank", name, 240, 160)
	popup.set_content(dat)
	popup.open()


/obj/item/weapon/reagent_containers/glass/chemtank/janitank/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr
	if(href_list["mop"])
		if(mymop)
			user.put_in_hands(mymop)
			user << "<span class='notice'>You take [mymop] from [src].</span>"
			mymop = null
			if(!mymop)
				if(!signs)
					verbs -= /obj/item/weapon/reagent_containers/glass/chemtank/janitank/proc/remove_items
			remove_items(user)
	if(href_list["sign"])
		if(signs)
			var/obj/item/weapon/caution/Sign = locate() in src
			if(Sign)
				user.put_in_hands(Sign)
				user << "<span class='notice'>You take \a [Sign] from [src].</span>"
				signs--
				if(!signs)
					if(!mymop)
						verbs -= /obj/item/weapon/reagent_containers/glass/chemtank/janitank/proc/remove_items
				remove_items(user)
			else
				warning("[src] signs ([signs]) didn't match contents")
				signs = 0

	update_icon()
	remove_items(user)
/obj/item/weapon/reagent_containers/glass/chemtank/meditank
	name = "M.E.D.I. Chem Tank"
	desc = "A chemtank backpack with alot of chemical storage."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "meditank"
	item_state = "meditank"

/obj/item/weapon/reagent_containers/glass/chemtank/hydrotank
	name = "S.U.N.S.H.I.N.E. Chem Tank"
	desc = "A chemtank backpack with alot of chemical storage."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "hydrotank"
	item_state = "hydrotank"