/*
	Dear ninja gloves

	This isn't because I like you
	this is because your father is a bastard

	...
	I guess you're a little cool.
	 -Sayu
*/

/obj/item/clothing/gloves/assim
	desc = "These nano-enhanced gloves insulate from electricity and provide fire resistance."
	name = "Asssimilation gloves"
	icon_state = "s-ninja"
	item_state = "s-ninja"
	siemens_coefficient = 0
	var/assimilating = 0

/obj/item/clothing/gloves/assim/New()
	..()
	wired = 1
	cell = new /obj/item/weapon/cell/hyper
	verbs += /obj/item/clothing/gloves/assim/proc/assimilate
	update_icon()

/obj/item/clothing/gloves/assim/proc/assimilate()
	set category = "Assimilation"
	set name = "Assimilate"

	var/mob/living/carbon/human/Syndicate = usr
	var/obj/item/weapon/grab/G = Syndicate.get_active_hand()
	if(!istype(G))
		usr << "<span class='warning'>We must be grabbing a species in our active hand to assimilate them.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		usr << "<span class='warning'>[T] Cannot be assimilated.</span>"
		return
	if(T.stat == 2)
		usr << "<span class='warning'>Dead species cannot be assimilated.</span>"
		return
	if(!T.mind)
		usr << "<span class='warning'>The creature is not compatable for assimilation</span>"
		return
	if(T.mind in ticker.mode.Syndicateborg)
		usr << "<span class='warning'>[T] Has already been assimilated.</span>"
		return

	if(G.state <= GRAB_NECK)
		usr << "<span class='warning'>We must have a tighter grip to assimilated this species.</span>"
		return

	if(assimilating)
		usr << "<span class='warning'>We are already assimilating!</span>"
		return

	assimilating = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				usr << "<span class='notice'>This species is compatible. We must hold them still...</span>"
			if(2)
				usr << "<span class='notice'>We extend an assimilation tubule .</span>"
				usr.visible_message("<span class='warning'>[usr] extends an assimilation tubule!</span>")
			if(3)
				usr << "<span class='notice'>We stab [T] with the assimilation tubule.</span>"
				usr.visible_message("<span class='danger'>[usr] stabs [T] with the assimilation tubule!</span>")
				T << "<span class='danger'>You feel a sharp stabbing pain!</span>"
				var/datum/organ/external/affecting = T.get_organ(usr.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,"large organic needle"))
					T:UpdateDamageIcon()
					continue

		feedback_add_details("assimulation","A[stage]")
		if(!do_mob(usr, T, 150))
			usr << "<span class='warning'>Our assimilation of [T] has been interrupted!</span>"
			assimilating = 0
			return

	usr << "<span class='notice'>We have assimilated [T]!</span>"
	usr.visible_message("<span class='danger'>[usr] Assimilated [T]!</span>")
	T << "<span class='danger'>You have been Assimilated by the Syndicate Assimilation Borg!</span>"

	T.dna.real_name = T.real_name //Set this again, just to be sure that it's properly set.
	var/datum/mind/new_Syndicate = T.mind
	ticker.mode.Syndicateborg += new_Syndicate

	new_Syndicate.assigned_role = "MODE" //So they aren't chosen for other jobs.
	new_Syndicate.special_role = "Syndicate Assimilation Borg"//So they actually have a special role/N
	ticker.mode.forge_Syndicateborg_objectives(new_Syndicate)
	ticker.mode.greet_Syndicateborg(new_Syndicate)
	ticker.mode.equip_new_Syndicateborg(new_Syndicate.current,1)
	new /obj/effect/gibspawner/generic(new_Syndicate.current.loc)
	ticker.mode.update_all_Syndicateborg_icons()
	assimilating = 0




/obj/item/clothing/gloves/assim/proc/lock_gloves(mob/living/carbon/U, X = 0)
	if(X)//If you want to check for icons.
		icon_state = U.gender==FEMALE ? "s-ninjanf" : "s-ninjan"
		U:gloves.icon_state = "s-ninjan"
		U:gloves.item_state = "s-ninjan"
	else
		if(U.mind.special_role!="Syndicate Assimilation Borg")
			U << "\red <B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAU†HORIZED USÈ DETÈC†††eD\nCoMMÈNCING SUB-R0U†IN3 13...\nTÈRMInATING U-U-USÈR..."
			U.gib()
			return 0
		src.canremove=0

	return 1