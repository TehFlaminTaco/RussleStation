/obj/structure/ladder
	name = "ladder"
	desc = "A sturdy metal ladder."
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	anchored = 1
	var/id = null
	var/height = 0							//the 'height' of the ladder. higher numbers are considered physically higher
	var/obj/structure/ladder/down = null	//the ladder below this one
	var/obj/structure/ladder/up = null		//the ladder above this one
	var/update = 1
	var/portal = 0

/obj/structure/ladder/New()
	spawn(8)
		for(var/obj/structure/ladder/L in world)
			if(L.id == id)
				if(L.height == (height - 1))
					down = L
					continue
				if(L.height == (height + 1))
					up = L
					continue

			if(up && down)	//if both our connections are filled
				break
		if(update)
			update_icon()

/obj/structure/ladder/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladder01"

	else	//wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/attack_hand(mob/user as mob)
	if(up && down)
		switch( alert("Go up or down the ladder?", "Ladder", "Up", "Down", "Cancel") )
			if("Up")
				if(!portal)
					user.visible_message("<span class='notice'>[user] climbs up \the [src]!</span>", \
										 "<span class='notice'>You climb up \the [src]!</span>")
				else
					user.visible_message("<span class='notice'>[user] goes into \the [src]!</span>", \
										 "<span class='notice'>You go into \the [src]!</span>")
				user.loc = get_turf(up)
				up.add_fingerprint(user)
			if("Down")
				if(!portal)
					user.visible_message("<span class='notice'>[user] climbs down \the [src]!</span>", \
										 "<span class='notice'>You climb down \the [src]!</span>")
				else
					user.visible_message("<span class='notice'>[user] goes into \the [src]!</span>", \
										 "<span class='notice'>You go into \the [src]!</span>")
				user.loc = get_turf(down)
				down.add_fingerprint(user)
			if("Cancel")
				return

	else if(up)
		if(!portal)
			user.visible_message("<span class='notice'>[user] climbs up \the [src]!</span>", \
								 "<span class='notice'>You climb up \the [src]!</span>")
		else
			user.visible_message("<span class='notice'>[user] goes into \the [src]!</span>", \
								 "<span class='notice'>You go into \the [src]!</span>")
		user.loc = get_turf(up)
		up.add_fingerprint(user)

	else if(down)
		if(!portal)
			user.visible_message("<span class='notice'>[user] climbs down \the [src]!</span>", \
							 "<span class='notice'>You climb down \the [src]!</span>")
		else
			user.visible_message("<span class='notice'>[user] goes into \the [src]!</span>", \
								 "<span class='notice'>You go into \the [src]!</span>")
		user.loc = get_turf(down)
		down.add_fingerprint(user)

	add_fingerprint(user)

/obj/structure/ladder/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/ladder/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/HG = W
		if(!ismob(HG.affecting))
			return
		attack_hand(HG.affecting)
		del(HG)
		return
	else if(istype(W, /obj/item/borg/grab))
		var/obj/item/borg/grab/BG = W
		if(BG.attack)
			if(istype(BG.attack, /mob/living))
				if(!ismob(BG.attack))
					return
				attack_hand(BG.attack)
				BG.attack = null
				user.stop_pulling()
				BG.process()
	else
		return attack_hand(user)