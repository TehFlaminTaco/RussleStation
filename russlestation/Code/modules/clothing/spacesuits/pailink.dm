/obj/item/device/paicard/proc/pai_holo(var/turf/T in world)//To have an internal AI display a hologram to the pAI and wearer only.
	set name = "Display Hologram"
	set desc = "Can only display hologram within 3 tiles of paicard."
	set category = null
	set src = usr.loc
	if(get_dist(src,T)>3)
		pai << "\red ERROR: \black Cannot display that far away!"
		return

	if(istype(src.loc, /obj))//If the host exists and they are playing, and their location is a turf.
		if(!istype(src.loc,/obj/item/clothing))
			pai << "\red ERROR: \black Unable to project image."
			return
	if(!hologram)//If there is not already a hologram.
		pai << browse(null, "window=pai")//Close window
		hologram = new(T)//Spawn a blank effect at the location.
		hologram.icon = pai.holo_icon
		hologram.mouse_opacity = 0//So you can't click on it.
		hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
		hologram.anchored = 1//So space wind cannot drag it.
		hologram.name = "[pai.name] (Hologram)"//If someone decides to right click.
		hologram.SetLuminosity(2)	//hologram lighting
		pai.current = src
		spawn(5)
			pai.eyeobj.loc = T
			pai.loc = pai.eyeobj.loc
			pai.incorporeal_move = 1
			pai.density = 0
			pai.mouse_opacity = 0
			pai.anchored = 1
			pai.verbs += /mob/living/silicon/pai/proc/pai_holo_clear

		pai_holo_process()//Move to initialize
	else
		pai << "\red ERROR: \black Image feed in progress."
	return

/obj/item/device/paicard/proc/pai_holo_process()
	//set background = 1
	/*if(hologram)//If there is a hologram.
		if(pai.pai && !pai.pai.stat && pai.pai.client && pai.pai.eyeobj)//If there is an AI attached, it's not incapacitated, it has a client, and the client eye is centered on the projector.

			if(get_dist(affecting,hologram.loc)<3)
				return 1

		pai_holo_clear()//If not, we want to get rid of the hologram.
		*/
	spawn while(hologram && pai)//here is an pai present.
		if(get_dist(src,hologram.loc)>3)//Once hologram reaches out of bounds.
			pai.pai_holo_clear()

			pai.verbs -= /mob/living/silicon/pai/proc/pai_holo_clear
			return
		sleep(10)//Checks every second.

/obj/item/device/paicard/proc/move_hologram()
	if(hologram)
		step_to(hologram, pai.eyeobj) // So it turns.
		hologram.loc = get_turf(pai.eyeobj)
		pai.loc = get_turf(hologram)

	return 1
/mob/living/silicon/pai/proc/pai_holo_clear()
	set name = "Clear Hologram"
	set desc = "Stops projecting the current holographic image."
	set category = "pAI Commands"
	loc = current
	if(client)
		client.eye = src
	eyeobj.loc = src.loc
	//del(hologram.i_attached)
	if(istype(current, /obj/item/device/paicard))
		var/obj/item/device/paicard/H = current
		if(H.hologram)
			del(H.hologram)
	current = null
	incorporeal_move = 0
	density = 1
	mouse_opacity = 1
	anchored = 0


	verbs -= /mob/living/silicon/pai/proc/pai_holo_clear
	return




/mob/living/silicon/pai/verb/pai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to pAI to something else."
	set category = "pAI Commands"

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in data_core.locked)//Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				del(holo_icon)//Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face",
		"Standard",
		"mouse",
		"kitten",
		"puppy",
		"bat",
		"chicken",
		"mushroom"
		)
		input = input("Please select a hologram:") as null|anything in icon_list
		if(input)
			del(holo_icon)
			switch(input)
				if("Standard")holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("mouse")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"mouse_brown"))
				if("kitten")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"kitten"))
				if("puppy")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"puppy"))
				if("bat")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"bat"))
				if("chicken")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"chicken_brown"))
				if("mushroom")
					holo_icon = getHologramIcon(icon('icons/mob/animal.dmi',"mushroom_old"))


	return

/obj/item/device/paicard/process()
	if(istype(src.loc,/obj/))
		if(!istype(src.loc,/obj/item/clothing))
			if(hologram)
				pai.pai_holo_clear()





/mob/living/silicon/pai/proc/choosename()
	set name = "Choose Name"
	set desc = "Change the default of the pAI something else."
	set category = "pAI Commands"
	var/new_name = reject_bad_name( input(usr, "Choose your pAI's name:", "pAI name")  as text|null )
	if(new_name)
		real_name = new_name
		name = new_name
		verbs -= /mob/living/silicon/pai/proc/choosename
	else
		usr << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"


/obj/item/clothing/head
	var/obj/item/device/paicard/pai


/obj/item/clothing/head/attackby(obj/item/device/D, mob/user)
	if(istype(D, /obj/item/device/paicard))//If it's a pai card.
		if(!pai)
			user:drop_item()
			D.loc = src
			pai = D
			user << "\blue You slot \the [D.name] into \the [src]."
			return
		else
			user <<"\red There is already a [D.name] in \the [src]."
			return
	else
		return..()

/obj/item/clothing/head/verb/remove_pai()
	set category = "Object"
	set name = "Remove pAI"
	set src in view(1)

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
	if(iscarbon(usr))
		var/mob/living/carbon/U = usr
		var/turf/T = get_turf(loc)
		if(!U.get_active_hand())
			U.put_in_hands(pai)
			pai.add_fingerprint(U)
			pai = null
		else
			if(T)
				pai.loc = T
				pai = null
			else
				U << "\red The pAI card could not be removed."
	else
		usr << "\red You cannot removed the pAI card."

