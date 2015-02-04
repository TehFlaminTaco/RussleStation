//Lallander was here
/mob/living/carbon/human/whisper(var/message, var/verb = "whispers", var/datum/language/speaking = null, var/alt_name = "",var/italics = 1, var/mob/speaker = null)
	verb = "whispers"
	var/style = "message"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	message = trim(copytext(strip_html_simple(message), 1, MAX_MESSAGE_LEN))

	if (!message || silent || miming)
		return

	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			src << "\red You cannot whisper (muted)."
			return

		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return


	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return


	if (istype(src, /mob/living/carbon/human) && src.name != GetVoice())
		var/mob/living/carbon/human/H = src
		alt_name = " (as [H.get_id_name("Unknown")])"
	// Mute disability
	if (src.sdisabilities & MUTE)
		return

	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		return

	var/message_range = 1

	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja)&&src.wear_mask:voice=="Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = text2list(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
				temp_message[H] = ninjaspeak(temp_message[H])
				pick_list -= H
			message = list2text(temp_message, " ")
			message = replacetext(message, "o", "�")
			message = replacetext(message, "p", "�")
			message = replacetext(message, "l", "�")
			message = replacetext(message, "s", "�")
			message = replacetext(message, "u", "�")
			message = replacetext(message, "b", "�")
	if(speaking)
		style = speaking.colour
	if (src.stuttering)
		message = stutter(message)

	for (var/obj/O in view(message_range, src))
		spawn (0)
			if (O)
				if(speaking)
					O.hear_talk(src, message, verb, speaking)

	var/list/listening = hearers(message_range, src)
	listening |= src

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/C in L.contents)
			if(istype(C,/mob/living))
				listening += C

	var/list/eavesdropping = hearers(2, src)
	eavesdropping -= src
	eavesdropping -= listening

	var/list/watching  = hearers(5, src)
	watching  -= src
	watching  -= listening
	watching  -= eavesdropping

	var/list/heard_a = list() // understood us
	var/list/heard_b = list() // didn't understand us

	for (var/mob/M in listening)
		if (M.say_understands(src,speaking))
			heard_a += M
		else
			heard_b += M

	var/rendered = null

	for (var/mob/M in watching)
		if (M.say_understands(src, speaking))
			rendered = "<span class='game say'><span class='name'>[src.name]</span> whispers something.</span>"
		else
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> whispers something.</span>"
		M.show_message(rendered, 2)

	if (length(heard_a))
		var/message_a = message

		if (italics)
			message_a = "<i>[message_a]</i>"
		//This appears copied from carbon/living say.dm so the istype check for mob is probably not needed. Appending for src is also not needed as the game will check that automatically.
		if(speaking)
			rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [speaking.whisp], <span class='[style]'>\"[message_a]\"</span></span>"
		else
			rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] whispers, <span class='[style]'>\"[message_a]\"</span></span>"

		for (var/mob/M in heard_a)
			M.show_message(rendered, 2)

	if (length(heard_b))
		var/message_b

		message_b = stars(message)

		if (italics)
			message_b = "<i>[message_b]</i>"
		if(speaking)
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> [speaking.whisp], <span class='[style]'>\"[message_b]\"</span></span>"
		else
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> whispers, <span class='[style]'>\"[message_b]\"</span></span>"

		for (var/mob/M in heard_b)
			M.show_message(rendered, 2)

	for (var/mob/M in eavesdropping)
		if (M.say_understands(src,speaking))
			var/message_c
			message_c = stars(message)
			if(speaking)
				rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [speaking.whisp], <span class='[style]'>\"[message_c]\"</span></span>"
			else
				rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] whispers, <span class='[style]'>\"[message_c]\"</span></span>"
			M.show_message(rendered, 2)
		else
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> whispers something.</span>"
			M.show_message(rendered, 2)

	if (italics)
		message = "<i>[message]</i>"
	if(speaking)
		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] [speaking.whisp], <span class='[style]'>\"[message]\"</span></span>"
	else
		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] whispers, <span class='[style]'>\"[message]\"</span></span>"

	for (var/mob/M in dead_mob_list)
		if (!(M.client))
			continue
		if (M.stat > 1 && !(M in heard_a) && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			M.show_message(rendered, 2)