// Pretty much everything here is stolen from the dna scanner FYI
var/vrpads = list()


/obj/machinery/vrpod
	var/mob/living/carbon/occupant
	var/turfOn
	var/locked
	var/mob/living/carbon/vrbody
	var/vrloc
	var/zPlane = 2
	var/mob/living/carbon/lastoccupant
	var/savedkey
	var/backupMind
	var/foundMind
	name = "VR Pod"
	desc = "A very advanced machine. It appears to be pulsating."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "vrpod_0"
	density = 1
	anchored = 1

/obj/machinery/vrpod/New(var/loc)
	vrloc = src
	..()

/obj/machinery/vrpod/Del()
	if (src.occupant)
		src.go_out()
	..()


/*/obj/machinery/vrpod/allow_drop()
	return 0*/

/obj/machinery/vrpod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/vrpod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject VR Pod"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/vrpod/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter VR Pod"

	if (usr.stat != 0)
		return
	if (src.occupant)
		usr << "\blue <B>The pod is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "vrpod_1"
	for(var/obj/O in src)
		//O = null
		del(O)
		//Foreach goto(124)
	src.add_fingerprint(usr)

	src.go_in()
	return


/obj/machinery/vrpod/proc/go_out()
	src.foundMind = 0
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(30)
	if (src.vrbody)
		if (src.vrbody.ckey)
			src.occupant.ckey = src.vrbody.ckey
			if (src.vrbody.mind)
				src.vrbody.mind.transfer_to(src.occupant)
				src.foundMind = 1
			//Drop all items where they stand. So that people don't eat the valuables.
			for(var/obj/item/W in src.vrbody)
				src.vrbody.drop_from_inventory(W)
				W.loc = src.vrbody.loc

				if(W.contents.len) //Make sure we catch anything not handled by del() on the items.
					for(var/obj/item/O in W.contents)
						O.loc = src
				if (istype(W, /obj/item/clothing/under))
					del(W)
				if (istype(W, /obj/item/clothing/shoes))
					del(W)
		del(src.vrbody)
	else
		src.occupant.ckey = src.savedkey // Done outside the loop JUST incase we can't find a guy.
		for(var/mob/M in player_list)
			if (!M.client)
				continue
			if (M.ckey == src.savedkey)
				M.mind.transfer_to(src.occupant)
				src.foundMind = 1
				break
			// How to save a life!
	if (src.foundMind==0)
		if(src.backupMind)
			if(istype(src.backupMind, /datum/mind))
				var/datum/mind/M = src.backupMind
				M.transfer_to(src.occupant)
				src.foundMind = 1
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant.suiciding = 0 // IT COULD HAPPEN!
	src.lastoccupant = src.occupant
	if (src.foundMind==0)
		src.occupant << "\red<b>As the pod bursts open you realise you can't remember much of anything.</b>"
	src.occupant = null
	src.icon_state = "vrpod_0"
	return

/obj/machinery/vrpod/proc/go_in()
	// Make New body
	src.savedkey = null
	if (!src.occupant)
		return
	if (!src.occupant.ckey)
		return
	if (!src.occupant.client)
		return

	// LET'S FIND A PAD!
	// Very shitty way of doing it, but meh.
	src.vrloc = pick(vrpads)
	if(src.vrloc) //Make sure we found it~
		var/obj/machinery/pad = src.vrloc
		src.vrloc = pad.loc
	else
		return
	var/mob/living/carbon/human/VRbody = new /mob/living/carbon/human(src.vrloc, src.occupant.dna.species)
	src.vrbody = VRbody

	// Set its name.
	if(!src.occupant.real_name)	//to prevent null names
		src.occupant.real_name = "Virtual Guy([rand(0,999)])"
	VRbody.real_name = "Virtual [src.occupant.real_name]"
	VRbody.updatehealth()

	VRbody.ckey = src.occupant.ckey
	src.backupMind = src.occupant.mind
	src.occupant.mind.transfer_to(VRbody)
	src.savedkey = VRbody.ckey
	VRbody << "<span class='notice'><i>Your body feels momenterily numb as you awake in a new world.</i></span>"

	// Set its DNA to match
	if(!src.occupant.dna)
		VRbody.dna = new /datum/dna()
		VRbody.dna.real_name = VRbody.real_name
	else
		VRbody.dna=src.occupant.dna
		VRbody.dna.real_name = VRbody.real_name

	VRbody.UpdateAppearance()
	VRbody.dna.UpdateSE()
	VRbody.dna.UpdateUI()

	// Give it languages to speak.
	for(var/datum/language/L in src.occupant.languages)
		VRbody.add_language(L.name)

	VRbody.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(VRbody), slot_w_uniform)
	VRbody.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(VRbody), slot_shoes)
	return

/obj/machinery/vrpod/attackby(obj/item/D as obj, user as mob)
	if (src.occupant)
		user << "\blue <B>The pod is already occupied!</B>"
		return
	if(istype(D, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = D
		if(!ismob(G.affecting))
			return
		if (G.affecting.abiotic())
			user << "\blue <B>Subject cannot have abiotic items on.</B>"
			return
		var/mob/M = G.affecting
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		src.icon_state = "vrpod_1"
		src.go_in()
		for(var/obj/O in src)
			O.loc = src.loc
			//Foreach goto(154)
		src.add_fingerprint(user)
		//G = null
		del(G)
		return
	if(istype(D, /obj/item/borg/grab))
		var/obj/item/borg/grab/BG = D
		if(!ismob(BG.attack))
			return
		if (BG.attack.abiotic())
			user << "\blue <B>Subject cannot have abiotic items on.</B>"
			return
		var/mob/M = BG.attack
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		src.icon_state = "vrpod_1"
		src.go_in()
		for(var/obj/O in src)
			O.loc = src.loc
			//Foreach goto(154)
		//G = null
		BG.attack = null
		usr.stop_pulling()
		BG.process()
		return
	return

/obj/machinery/vrpod/process()
	// Log out the dead! Because it'd suck if they stuck.
	if (src.occupant)
		if (!src.vrbody)
			src.go_out()
			src.visible_message("\red \icon[src] GAME SESSION HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		if (src.vrbody.aghost==1) // So that admins can Aghost all they like and not be popped out.
			return
		if (!(src.vrbody.ckey&&src.vrbody.client)) // No body? No problem.
			src.visible_message("\red \icon[src] ERROR; CONNECTION TO VR BODY SEVERED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			src.go_out()
			return
		if (src.occupant.stat & DEAD)
			src.go_out() // If this didn't happen, they'd be in VR forever.
			src.visible_message("\red \icon[src] ERROR; BRAIN FUNCTIONS HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		if (src.vrbody.stat & DEAD)
			src.vrbody << "\red <B>The VR pod bursts open, the thrill of death still sweeping over you.</B>"
			src.go_out()
			src.visible_message("\red \icon[src] GAME SESSION HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return


/obj/machinery/vrpod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/vrpod/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)


// VR POD ENTRY PADS, YEEE.
/obj/machinery/vrpad
	var/turfOn
	name = "VR Pad"
	desc = "A pulsating machine."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "vrpad"
	anchored = 1

/obj/machinery/vrpad/New()
	vrpads+=src // So that we can find it later. Probably a better way to do this, but meh.
	..()

/obj/machinery/vrpad/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/vrpad/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/machinery/vrpad/attack_hand(mob/user)
	if(!user)
		return
	src.add_fingerprint(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/confirm = alert("Do you wish to leave the VR Realm?", "Confirm Log Out", "Yes", "No")

		if(confirm=="Yes")
			if (!(H.species && H.species.flags & NO_PAIN))
				H << "\red <B>You feel a jolt of pain as you touch the device.</B>"
			else
				H << "\blue You feel your form be destroyed."
			H.apply_damage(9001, BRUTE, "chest") // BAMN, dead