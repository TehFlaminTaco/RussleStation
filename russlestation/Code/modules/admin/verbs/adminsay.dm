/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	if(!(prefs.Atoggles & CHAT_ASAY))
		src << "\red You have ASAY muted."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return



	log_admin("[key_name(src)] : [msg]")

	if(check_rights(R_ADMIN,0))
		msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights)
				if(C.prefs.Atoggles & CHAT_ASAY)
					C << msg

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1
	if(!check_rights(R_ADMIN|R_MOD))	return

	if(!(prefs.Atoggles & CHAT_MSAY))
		src << "\red You have MSAY muted."
		return
	if (!check_rights(R_ADMIN,0))
		if(!msay_allowed)
			src << "\red MSAY for Mods is currently muted"
			return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")

	if (!msg)
		return
	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			if(C.prefs.Atoggles & CHAT_MSAY)
				C << "<span class='[color]'><span class='prefix'>MOD:</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"

/client/proc/cmd_vip_say(msg as text)
	set category = "OOC"
	set name = "Vsay"
	set hidden = 0

	if(!(prefs.Atoggles & CHAT_VSAY))
		src << "\red You have VSAY muted."
		return

	if(vipholder)
		if(!vsay_allowed)
			src << "\red VSAY is globally muted"
			return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_vsay("VIP: [key_name(src)] : [msg]")

	if(!msg)	return
	var/color = "VIP"
	if (check_rights(R_ADMIN|R_MOD,0))
		color = "VIPADMINMOD"
	for(var/client/C in clients)
		if((C.holder && ((R_ADMIN|R_MOD|R_DEV) & C.holder.rights)) | (C.vipholder && (V_VIP & C.vipholder.rights)))
			if(C.prefs.Atoggles & CHAT_VSAY)
				C << "<span class='[color]'><span class='prefix'>VIP:</span> [key]: <span class='message'>[msg]</span></span>"


/client/proc/cmd_dev_say(msg as text)
	set category = "OOC"
	set name = "DEVsay"
	set hidden = 0

	if(!(prefs.Atoggles & CHAT_DEVSAY))
		src << "\red You have DEVSAY muted."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_devsay("DEV: [key_name(src)] : [msg]")

	if(!msg)	return
	var/color = "DEV"
	if (check_rights(R_ADMIN|R_MOD,0))
		color = "DEVADMINMOD"
	for(var/client/C in clients)
		if(C.holder && ((R_ADMIN|R_MOD|R_DEV) & C.holder.rights))
			if(C.prefs.Atoggles & CHAT_DEVSAY)
				C << "<span class='[color]'><span class='prefix'>DEV:</span> [key]: <span class='message'>[msg]</span></span>"




