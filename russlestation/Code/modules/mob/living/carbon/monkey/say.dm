/mob/living/carbon/monkey/say(var/message)
	var/verb = pick(src.speak_emote)
	var/alt_name = ""
	var/message_range = world.view
	var/italics = 0
	var/handtalk = ""
	var/handtalkcom = 0
	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (Muted)."
			return

	if(stat == 2)
		return say_dead(message)

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))


	var/message_mode = null
	var/datum/language/speaking = null

	if(copytext(message,1,2) == ";")
		message_mode = "headset"
		message = copytext(message,2)
	if(copytext(message,1,3) == ":w"||copytext(message,1,3) == ":W")
		message_mode = "whisper"
		message = copytext(message,3)
	if(copytext(message,1,3) == ":r"||copytext(message,1,3) == ":R")
		var/obj/item/device/radio/R
		var/has_radio = 0
		if(r_hand && istype(r_hand, /obj/item/device/radio))
			R = r_hand
			if(R.broadcasting)
				has_radio = 0
			else
				has_radio = 1
		if(has_radio)
			message_mode = "right hand"
			message = copytext(message,3)
		if(copytext(message,1,2) == ";")
			handtalkcom = 1
			message = copytext(message,2)
	if(copytext(message,1,3) == ":l"||copytext(message,1,3) == ":L")
		var/has_radio = 0
		var/obj/item/device/radio/R
		if(l_hand && istype(l_hand, /obj/item/device/radio))
			R = l_hand
			if(R.broadcasting)
				has_radio = 0
			else
				has_radio = 1
		if(has_radio)
			message_mode = "left hand"
			message = copytext(message,3)
		if(copytext(message,1,2) == ";")
			handtalkcom = 1
			message = copytext(message,2)


	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		var/check_language_and_radio = copytext(message,3,5)
		if(languages.len)
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == ":[L.key]" || lowertext(check_language_and_radio) == ":[L.key]")
					verb = L.speech_verb
					speaking = L
					break
		if(message_mode =="left hand")
			if(channel_prefix in department_radio_keys)
				handtalk = department_radio_keys[channel_prefix]
			else
				handtalk = ""
		if(message_mode =="right hand")
			if(channel_prefix in department_radio_keys)
				handtalk = department_radio_keys[channel_prefix]
			else
				handtalk = ""
		if(!message_mode)
			message_mode = department_radio_keys[channel_prefix]

	if(speaking || (copytext(message,1,2) == ":"))
		var/positioncut = 3
		if(speaking && (copytext(message,3,4) == ":"))
			positioncut += 2
		message = trim(copytext(message,positioncut))

	message = capitalize(trim_left(message))

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[1]
		verb = handle_r[2]
		speech_problem_flag = handle_r[3]

	if(!message || stat)
		return

	var/ending = copytext(message, length(message))
	if(ending=="!")
		verb=pick("exclaims","shouts","yells")
	if(ending=="?")
		verb="asks"

	var/list/obj/item/used_radios = new

	switch (message_mode)

		if("right hand")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(r_hand && istype(r_hand, /obj/item/device/radio))
				R = r_hand
				if(R.broadcasting)
					has_radio = 0
				else
					has_radio = 1
			if(has_radio)
				if(handtalk != "")
					src.visible_message("[src] speaks into \the [r_hand] in their right hand","\red You speak into \the [r_hand] in your right hand on the [handtalk] channel.")
					R.talk_into(src,message,handtalk,verb,speaking)
					used_radios += R
				else if(handtalkcom)
					src.visible_message("[src] speaks into \the [r_hand] in their right hand","\red You speak into \the [r_hand] in your right hand on the Common channel.")
					R.talk_into(src,message,null,verb,speaking)
					used_radios += R
				else
					..(message, speaking, verb, alt_name, italics, message_range, used_radios)
					return

		if("left hand")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(l_hand && istype(l_hand,/obj/item/device/radio))
				R = l_hand
				if(R.broadcasting)
					has_radio = 0
				else
					has_radio = 1
			if(has_radio)
				if(handtalk != "")
					src.visible_message("[src] speaks into \the [l_hand] in their left hand","\red You speak into \the [l_hand] in your left hand on the [handtalk] channel.")
					R.talk_into(src,message,handtalk,verb,speaking)
					used_radios += R
				else if(handtalkcom)
					src.visible_message("[src] speaks into \the [r_hand] in their right hand","\red You speak into \the [r_hand] in your right hand on the Common channel.")
					R.talk_into(src,message,null,verb,speaking)
					used_radios += R
				else
					..(message, speaking, verb, alt_name, italics, message_range, used_radios)
					return


		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, message, verb, speaking)
				used_radios += I
		if("whisper")
			whisper(message,verb,speaking)
			return
		if("binary")
			if(robot_talk_understand || binarycheck())
				robot_talk(message)
			return
		if("changeling")
			if(mind && mind.changeling)
				log_say("[key_name(src)] ([mind.changeling.changelingID]): [message]")
				for(var/mob/Changeling in mob_list)
					if(istype(Changeling, /mob/living/silicon)) continue //WHY IS THIS NEEDED?
					if(Changeling.mind && Changeling.mind.changeling && Changeling.client)
						Changeling << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"
				for(var/mob/O in player_list)
					if(istype(O, /mob/dead/observer))
						var/mob/dead/observer/obs = O
						if(obs.client.holder)
							if(obs.mind)
								if(!obs.mind.changeling)
									O << "<i><font color=#800080><b>[mind.changeling.changelingID] (:</b> [message]</font></i>"
							if(obs.started_as_observer)
								obs << "<i><font color=#800080><b>[mind.changeling.changelingID] (:</b> [message]</font></i>"
						if(!obs.client.holder && obs.has_enabled_antagHUD && (obs.client.prefs.toggles & CHAT_GHOSTEARS))
							if(obs.mind)
								if(!obs.mind.changeling)
									obs << "<i><font color=#800080><b>[mind.changeling.changelingID] (:</b> [message]</font></i>"
							if(obs.started_as_observer)
								obs << "<i><font color=#800080><b>[mind.changeling.changelingID] (:</b> [message]</font></i>"
				return


	if(used_radios.len)
		italics = 1
		message_range = 1

	var/datum/gas_mixture/environment = loc.return_air()
	if(environment)
		var/pressure = environment.return_pressure()
		if(pressure < SAY_MINIMUM_PRESSURE)
			italics = 1
			message_range =1

	..(message, speaking, verb, alt_name, italics, message_range, used_radios)

/mob/living/carbon/monkey/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1
	if (istype(other, /mob/living/silicon))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	if (istype(other, /mob/living/carbon/slime))
		return 1
	if (istype(other, /mob/living/carbon/human) && !speaking)
		if(languages.len >= 3) // They have sucked down some blood.
			return 1
	return ..()

/mob/living/carbon/monkey/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	return real_name



/mob/living/carbon/monkey/proc/handle_speech_problems(var/message)
	var/list/returns[3]
	var/verb = "says"
	var/handled = 0
	if(silent)
		message = ""
		handled = 1
	if(sdisabilities & MUTE)
		message = ""
		handled = 1
	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				if(mind && mind.changeling && department_radio_keys[copytext(message, 1, 3)] != "changeling")
					message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
					verb = pick("whinnies","neighs", "says")
					handled = 1

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		handled = 1
	if(slurring)
		message = slur(message)
		verb = pick("stammers","stutters")
		handled = 1

	var/braindam = getBrainLoss()
	if(braindam >= 60)
		handled = 1
		if(prob(braindam/4))
			message = stutter(message)
			verb = pick("stammers", "stutters")
		if(prob(braindam))
			message = uppertext(message)
			verb = pick("yells like an idiot","says rather loudly")

	returns[1] = message
	returns[2] = verb
	returns[3] = handled

	return returns
