/datum/game_mode
	var/list/datum/mind/Syndicateborg = list()
	var/list/datum/mind/orginalSyndicateborg = list()


/datum/game_mode/assimilate
	name = "Syndicate Assimilation"
	config_tag = "assimilate"
	required_players = 15 //15
	required_players_secret = 15 // 15 players - 5 players to be the ipcs = 10 players remaining
	required_enemies = 1 //1
	recommended_enemies = 5 //5

	var/const/agents_possible = 5 //If we ever need more syndicate agents.
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)
	var/assimilated = 0
	var/needassim = 0
	var/deadorignal = 0
	var/lastcheck = 0
	var/amount_dead = 0
	var/amount_total = 0



/datum/game_mode/assimilate/announce()
	world << "<B>The current game mode is - Syndicate Assimilation!</B>"
	world << "<B>A Syndicate ship is approaching [station_name()]!</B>"

/datum/game_mode/assimilate/can_start()//This could be better, will likely have to recode it later
	if(!..())
		return 0

	var/list/possible_Syndicateborg = get_players_for_role(BE_OPERATIVE)
	var/Syndicate_number = 0

	if(possible_Syndicateborg.len < 1)
		return 0

	//Antag number should scale to active crew.
	var/n_players = num_players()
	Syndicate_number = Clamp((n_players/5), 2, 6)
	needassim = round(Clamp((n_players*0.75), 10, 40))

	if(possible_Syndicateborg.len < Syndicate_number)
		Syndicate_number = possible_Syndicateborg.len

	while(Syndicate_number > 0)
		var/datum/mind/new_Syndicate = pick(possible_Syndicateborg)
		Syndicateborg += new_Syndicate
		orginalSyndicateborg += new_Syndicate
		possible_Syndicateborg -= new_Syndicate //So it doesn't pick the same guy each time.
		Syndicate_number--

	for(var/datum/mind/Syndicate_mind in Syndicateborg)
		Syndicate_mind.assigned_role = "MODE" //So they aren't chosen for other jobs.
		Syndicate_mind.special_role = "Syndicate Assimilation Borg"//So they actually have a special role/N
	return 1


/datum/game_mode/assimilate/pre_setup()
	return 1


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_Syndicateborg_icons()
	spawn(0)
		for(var/datum/mind/Syndicate_mind in Syndicateborg)
			if(Syndicate_mind.current)
				if(Syndicate_mind.current.client)
					for(var/image/I in Syndicate_mind.current.client.images)
						if(I.icon_state == "synd")
							del(I)

		for(var/datum/mind/Syndicate_mind in Syndicateborg)
			if(Syndicate_mind.current)
				if(Syndicate_mind.current.client)
					for(var/datum/mind/Syndicate_mind_1 in Syndicateborg)
						if(Syndicate_mind_1.current)
							var/I = image('icons/mob/mob.dmi', loc = Syndicate_mind_1.current, icon_state = "synd")
							Syndicate_mind.current.client.images += I

/datum/game_mode/proc/update_Syndicateborg_icons_added(datum/mind/Syndicate_mind)
	spawn(0)
		if(Syndicate_mind.current)
			if(Syndicate_mind.current.client)
				var/I = image('icons/mob/mob.dmi', loc = Syndicate_mind.current, icon_state = "synd")
				Syndicate_mind.current.client.images += I

/datum/game_mode/proc/update_Syndicateborg_icons_removed(datum/mind/Syndicate_mind)
	spawn(0)
		for(var/datum/mind/Syndicate in Syndicateborg)
			if(Syndicate.current)
				if(Syndicate.current.client)
					for(var/image/I in Syndicate.current.client.images)
						if(I.icon_state == "synd" && I.loc == Syndicate_mind.current)
							del(I)

		if(Syndicate_mind.current)
			if(Syndicate_mind.current.client)
				for(var/image/I in Syndicate_mind.current.client.images)
					if(I.icon_state == "synd")
						del(I)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/assimilate/post_setup()

	var/list/turf/Syndicate_spawn = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "Syndicateborg-Spawn")
			Syndicate_spawn += get_turf(A)
			del(A)
			continue
	for(var/area/A in world)
		if(istype(A, /area/syndicate_station))
			for(var/obj/item/device/transfer_valve/B in A)
				del(B)
			for(var/obj/item/weapon/gun/energy/ionrifle/IR in A)
				del(IR)
			for(var/obj/structure/closet/syndicate/personal/P in A)
				new /obj/structure/closet/syndicate/ipc(P.loc)
				del(P)

	var/spawnpos = 1

	for(var/datum/mind/Syndicate_mind in Syndicateborg)
		if(spawnpos > Syndicate_spawn.len)
			spawnpos = 1
		Syndicate_mind.current.loc = Syndicate_spawn[spawnpos]

		Syndicate_mind.current.real_name = "Syndicate Assimilation Borg [rand(0,999)]" // placeholder while we get their actual name
		Syndicate_mind.current.name = Syndicate_mind.current.real_name
		spawn(0)
			SyndicateNameAssign(Syndicate_mind)

		if(!config.objectives_disabled)
			forge_Syndicateborg_objectives(Syndicate_mind)
		greet_Syndicateborg(Syndicate_mind)
		equip_Syndicateborg(Syndicate_mind.current)
		equip_uplink(Syndicate_mind.current)
		var/mob/living/carbon/human/D = Syndicate_mind.current
		D.hud_updateflag |= 1 << SPECIALROLE_HUD


		spawnpos++
		update_Syndicateborg_icons_added(Syndicate_mind)

	update_all_Syndicateborg_icons()

	if(emergency_shuttle)
		emergency_shuttle.always_fake_recall = 1
	spawn (rand(waittime_l, waittime_h))
		send_intercept()

	return ..()

/datum/game_mode/assimilate/process()
	if (lastcheck < 20)
		lastcheck +=1
	else
		check_finished()
		update_all_Syndicateborg_icons()
		lastcheck = 0
	..()
	return


/datum/game_mode/proc/forge_Syndicateborg_objectives(var/datum/mind/Syndicateborg)
	var/datum/objective/assimilate/Syndicateobj = new
	Syndicateobj.owner = Syndicateborg
	Syndicateborg.objectives += Syndicateobj


/datum/game_mode/proc/greet_Syndicateborg(var/datum/mind/Syndicateborg, var/you_are=1)
	if (you_are)
		Syndicateborg.current << "\blue You are a Syndicate Assimilation Borg!"
	Syndicateborg.current.faction = "syndicate"
	var/obj_count = 1
	if(!config.objectives_disabled)
		for(var/datum/objective/objective in Syndicateborg.objectives)
			Syndicateborg.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++
	else
		Syndicateborg.current << "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>"

	return



/datum/game_mode/proc/equip_Syndicateborg(mob/living/carbon/human/Syndicate_mob, assimilated = 0)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(Syndicate_mob)
	R.set_frequency(radio_freq)
	Syndicate_mob.equip_to_slot_or_del(R, slot_l_ear)

	Syndicate_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(Syndicate_mob), slot_w_uniform)
	Syndicate_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(Syndicate_mob), slot_shoes)
	Syndicate_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/assim(Syndicate_mob), slot_gloves)
	Syndicate_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(Syndicate_mob), slot_wear_id)
	Syndicate_mob.equip_to_slot_or_del(new /obj/item/device/pda/syndicate(Syndicate_mob), slot_wear_pda)
	if(Syndicate_mob.backbag == 2) Syndicate_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(Syndicate_mob), slot_back)
	if(Syndicate_mob.backbag == 3) Syndicate_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(Syndicate_mob), slot_back)
	if(Syndicate_mob.backbag == 4) Syndicate_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(Syndicate_mob), slot_back)

	if(Syndicate_mob.species)
		var/race = Syndicate_mob.species.name
		if(race != "Machine")
			Syndicate_mob.set_species("Machine")
	for(var/obj/item/clothing/gloves/assim/G in Syndicate_mob.contents)
		G.lock_gloves(Syndicate_mob)

	for(var/obj/item/device/pda/syndicate/PDA in Syndicate_mob.contents)
		PDA.owner = Syndicate_mob.real_name
		PDA.cartridge  = null

	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(Syndicate_mob)
	E.imp_in = Syndicate_mob
	E.implanted = 1
	Syndicate_mob.r_fur = 64
	Syndicate_mob.b_fur = 10
	Syndicate_mob.g_fur = 1
	Syndicate_mob.h_style = "blue IPC screen"
	for(var/datum/organ/external/head/D in Syndicate_mob.organs)
		D.icon_name = "head_synd"
	Syndicate_mob.regenerate_icons()
	update_all_Syndicateborg_icons()
	return 1

/datum/game_mode/proc/equip_uplink(mob/living/carbon/human/Syndicate_mob, var/safety = 0)
	. = 1
	var/loc = ""
	var/obj/item/Z = locate() //Hide the uplink in a PDA if available, otherwise radio
	if(Syndicate_mob.client.prefs.uplinklocation == "Headset")
		Z = locate(/obj/item/device/radio) in Syndicate_mob.contents
		if(!Z)
			Z = locate(/obj/item/device/pda) in Syndicate_mob.contents
			Syndicate_mob << "Could not locate a Radio, installing in PDA instead!"
		if (!Z)
			Syndicate_mob << "Unfortunately, neither a radio or a PDA relay could be installed."
	else if(Syndicate_mob.client.prefs.uplinklocation == "PDA")
		Z = locate(/obj/item/device/pda) in Syndicate_mob.contents
		if(!Z)
			Z = locate(/obj/item/device/radio) in Syndicate_mob.contents
			Syndicate_mob << "Could not locate a PDA, installing into a Radio instead!"
		if (!Z)
			Syndicate_mob << "Unfortunately, neither a radio or a PDA relay could be installed."
	else if(Syndicate_mob.client.prefs.uplinklocation == "None")
		Syndicate_mob << "You have elected to not have an AntagCorp portable teleportation relay installed!"
		Z = null
	else
		Syndicate_mob << "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!"
		Z = locate(/obj/item/device/pda) in Syndicate_mob.contents
		if (!Z)
			Z = locate(/obj/item/device/radio) in Syndicate_mob.contents
			Syndicate_mob << "Could not locate a PDA, installing into a Radio instead!"
		if (!Z)
			Syndicate_mob << "Unfortunately, neither a radio or a PDA relay could be installed."

	if (!Z)
		. = 0
	else
		if (istype(Z, /obj/item/device/radio))
			// generate list of radio freqs
			var/obj/item/device/radio/target_radio = Z
			var/freq = 1441
			var/list/freqlist = list()
			while (freq <= 1489)
				if (freq < 1451 || freq > 1459)
					freqlist += freq
				freq += 2
				if ((freq % 2) == 0)
					freq += 1
			freq = freqlist[rand(1, freqlist.len)]

			var/obj/item/device/uplink/hidden/T = new(Z)
			target_radio.hidden_uplink = T
			target_radio.traitor_frequency = freq
			Syndicate_mob << "A portable object teleportation relay has been installed in your [Z.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features."
			Syndicate_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([Z.name] [loc]).")
		else if (istype(Z, /obj/item/device/pda))
			// generate a passcode if the uplink is hidden in a PDA
			var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"

			var/obj/item/device/uplink/hidden/T = new(Z)
			Z.hidden_uplink = T
			var/obj/item/device/pda/P = Z
			P.lock_code = pda_pass

			Syndicate_mob << "A portable object teleportation relay has been installed in your [Z.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features."
			Syndicate_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([Z.name] [loc]).")

/datum/game_mode/proc/equip_new_Syndicateborg(mob/living/carbon/human/Syndicate_mob, assimilated = 0)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(Syndicate_mob)
	R.set_frequency(radio_freq)
	for(var/obj/item/W in Syndicate_mob.contents)
		if (W==Syndicate_mob.r_ear)
			Syndicate_mob.drop_from_inventory(W)
	Syndicate_mob.equip_to_slot_or_del(R, slot_r_ear)
	for(var/obj/item/W in Syndicate_mob.contents)
		if (W==Syndicate_mob.gloves)
			Syndicate_mob.drop_from_inventory(W)
	Syndicate_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/assim(Syndicate_mob), slot_gloves)

	if(Syndicate_mob.species)
		var/race = Syndicate_mob.species.name
		if(race != "Machine")
			Syndicate_mob.set_species("Machine")
	for(var/obj/item/clothing/gloves/assim/G in Syndicate_mob.contents)
		G.lock_gloves(Syndicate_mob)

	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(Syndicate_mob)
	E.imp_in = Syndicate_mob
	E.implanted = 1
	Syndicate_mob.r_fur = 136
	Syndicate_mob.b_fur = 21
	Syndicate_mob.g_fur = 1
	Syndicate_mob.h_style = "blue IPC screen"
	Syndicate_mob.revive()
	Syndicate_mob.oxygen_alert = 0
	for(var/datum/organ/external/head/D in Syndicate_mob.organs)
		D.icon_name = "head_synd"
	Syndicate_mob.real_name = "Syndicate Assimilation Borg [rand(0,999)]"
	Syndicate_mob.regenerate_icons()
	update_all_Syndicateborg_icons()
	return 1

/datum/game_mode/assimilate/check_finished()
	assimilated = 0
	amount_dead = 0
	amount_total = 0
	for(var/datum/mind/A in Syndicateborg)
		assimilated +=1
	for(var/datum/mind/S in orginalSyndicateborg)
		assimilated -=1
	if(assimilated>=needassim)
		return 1
	for(var/datum/mind/D in Syndicateborg)
		amount_total +=1
		if(D.current.aghost==1)
			continue
		else
			if(D.current.stat ==2||!D.current.client)
				amount_dead +=1

	if(amount_dead == amount_total)
		return 1

	return ..()



/datum/game_mode/assimilate/declare_completion()
	if(config.objectives_disabled)
		return



	if      (assimilated>=needassim &&(assimilated>= amount_dead))
		feedback_set_details("round_end_result","win - Enough assimilated and less dead than assimilated")
		world << "<FONT size = 3><B>Syndicate Assimilation Borgs Major Victory!</B></FONT>"
		world << "<B>Syndicate Assimilation Borgs have assimilated most of the crew of [station_name()]!  The rest are bound to fall prey to their assimilation!</B>"

	else if (assimilated<=needassim &&(assimilated<= amount_dead))
		feedback_set_details("round_end_result","loss - Not enough assimilated and more dead than assimilated")
		world << "<FONT size = 3><B>Crew Minor Victory!</B></FONT>"
		world << "<B>The crew were able to fend off the Syndicate Assimilation Borgs with very little assimilated crew."
	else if (assimilated>=needassim &&(assimilated<= amount_dead))
		feedback_set_details("round_end_result","loss - Enough assimilated and more dead than assimilated")
		world << "<FONT size = 3><B>Crew Major Victory!</B></FONT>"
		world << "<B>The crew were able to fend off the Syndicate Assimilation Borgs with most of the crew assimilated."
	else if (assimilated<=needassim &&(assimilated>= amount_dead))
		feedback_set_details("round_end_result","loss - Not enough assimilated and less dead than assimilated")
		world << "<FONT size = 3><B>Syndicate Assimilation Borgs Minor Victory!</B></FONT>"
		world << "<B>Syndicate Assimilation Borgs have Assimilated Some of the Crew but not enough to assimilate the entire station!</B>"



	..()
	return


/datum/game_mode/proc/auto_declare_completion_assimilate()
	if( Syndicateborg.len || (ticker && istype(ticker.mode,/datum/game_mode/assimilate)) )
		var/text = "<FONT size = 2><B>The Syndicate Assimilation Borgs were:</B></FONT>"

		for(var/datum/mind/A in Syndicateborg)
			if(A.key)
				text += "<br>[A.key] was [A.name] ("
			else
				text += "<br>Syndicate(DCed) was [A.name] ("
			if(A.current)
				if(A.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(A.current.real_name != Syndicateborg.name)
					text += " as [A.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

		world << text
	return 1



/proc/SyndicateNameAssign(var/datum/mind/Syndicate_mind)
	var/choose_name = input(Syndicate_mind.current, "You are a Syndicate Assimilation Borg! What is your name?", "Choose a name") as text

	if(!choose_name)
		return

	else
		Syndicate_mind.current.name = choose_name
		Syndicate_mind.name = choose_name
		Syndicate_mind.current.real_name = choose_name
		return

datum/objective/assimilate
	explanation_text = "Assimilate the crew of the station."