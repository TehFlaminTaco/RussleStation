/obj/item/VIP_store
	name = "Strange PDA"
	desc = "A Strange PDA.  Probably Nothing of importance."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda-VIP"
	var/uses = 1

/obj/item/VIP_store/attack_self(mob/M as mob)

	if(usr.client.vipholder || usr.client.holder)
		VIP_Store()
	else
		M << "\red it doesn't do anything"
		return

/obj/item/VIP_store/proc/VIP_Store(mob/user as mob)
/*	var/list/prizes = list(	/obj/item/weapon/storage/box/snappops			= 2,
						/obj/item/toy/blink								= 2,
						/obj/item/clothing/under/syndicate/tacticool	= 2,
						/obj/item/toy/sword								= 2,
						/obj/item/toy/gun								= 2,
						/obj/item/toy/crossbow							= 2,
						/obj/item/clothing/suit/syndicatefake			= 2,
						/obj/item/weapon/storage/fancy/crayons			= 2,
						/obj/item/toy/spinningtoy						= 2,
						/obj/item/toy/prize/ripley						= 1,
						/obj/item/toy/prize/fireripley					= 1,
						/obj/item/toy/prize/deathripley					= 1,
						/obj/item/toy/prize/gygax						= 1,
						/obj/item/toy/prize/durand						= 1,
						/obj/item/toy/prize/honk						= 1,
						/obj/item/toy/prize/marauder					= 1,
						/obj/item/toy/prize/seraph						= 1,
						/obj/item/toy/prize/mauler						= 1,
						/obj/item/toy/prize/odysseus					= 1,
						/obj/item/toy/prize/phazon						= 1
						)
*/
	if(..())
		return
	usr.set_machine(src)
	var/dat = "<body link='yellow' alink='white' bgcolor='#601414'><font color='white'><center><b>"
	dat += "Welcome to the VIP Store<br>"
	dat += "You can only chose 1 item so choose carefully<br><br>"
	dat += "Toys and Items<br>"
	dat += "<a href='byond://?src=\ref[src];gun=1 close=1'>Toy Gun</a> <br>"
	dat += "<a href='byond://?src=\ref[src];sword=1 close=1'>Toy Sword</a> <br>"
	dat += "<a href='byond://?src=\ref[src];crayons=1 close=1'>Crayons</a> <br>"
	dat += "<a href='byond://?src=\ref[src];r_flash=1 close=1'>Red Flashlight</a> <br>"
	dat += "<a href='byond://?src=\ref[src];old_camera=1 close=1'>Blue Camera</a> <br>"
	dat += "<a href='byond://?src=\ref[src];o_camera=1 close=1'>Orange Camera</a> <br>"
	dat += "<a href='byond://?src=\ref[src];balloon=1 close=1'>VIP Balloon</a> <br><br>"
	dat += "Clothing<br>"
	dat += "<a href='byond://?src=\ref[src];VIP_Uniform=1 close=1'>VIP Uniform</a> <br>"
	dat += "<a href='byond://?src=\ref[src];o_bandana=1 close=1'>Orange Bandana(hat)</a> <br>"
	dat += "<a href='byond://?src=\ref[src];w_hat=1 close=1'>Worn Hat</a> <br>"
	dat += "<a href='byond://?src=\ref[src];s_goggles=1 close=1'>Scanning Goggles</a> <br>"
	dat += "<a href='byond://?src=\ref[src];s_pan=1 close=1'>Saucepan Hat</a> <br>"
	dat += "<a href='byond://?src=\ref[src];p_dress=1 close=1'>Purple Dress</a> <br>"
	dat += "<a href='byond://?src=\ref[src];k_offsuit=1 close=1'>Knockoff Suit</a> <br>"
	dat += "<a href='byond://?src=\ref[src];r_dressuniform=1 close=1'>Retired Dress Uniform</a> <br>"
	dat += "<a href='byond://?src=\ref[src];ex_com_suit=1 close=1'>Ex-Commander Suit</a> <br>"
	dat += "<a href='byond://?src=\ref[src];w_officer=1 close=1'>Worn Officer Uniform</a> <br>"
	dat += "<a href='byond://?src=\ref[src];r_uniform=1 close=1'>Retired Uniform</a> <br>"
	dat += "<a href='byond://?src=\ref[src];duckbelt=1 close=1'>Inflatable Duck Belt</a> <br>"
	dat += "<a href='byond://?src=\ref[src];flippers=1 close=1'>Flippers</a> <br>"
	dat += "<a href='byond://?src=\ref[src];snorkel=1 close=1'>Snorkel</a> <br>"
	dat += "</center></b>"


	usr << browse(dat, "window=VIP")
	onclose(usr, "VIP")
	return


/obj/item/VIP_store/Topic(href, href_list)
	if((!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr)))
		usr.unset_machine()
		usr << browse(null, "window=VIP")
	else if (href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=VIP")

	else if (href_list["r_flash"])
		if(uses >= 1)
			new /obj/item/device/flashlight/fluff/thejesster14_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["gun"])
		if(uses >= 1)
			new /obj/item/toy/gun(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["sword"])
		if(src.uses >= 1)
			new /obj/item/toy/sword(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["crayons"])
		if(uses >= 1)
			new /obj/item/weapon/storage/fancy/crayons(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["VIP_Uniform"])
		if(uses >= 1)
			new /obj/item/clothing/under/color/VIP(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["old_camera"])
		if(uses >= 1)
			new /obj/item/device/camera/fluff/oldcamera(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["o_camera"])
		if(uses >= 1)
			new /obj/item/device/camera/fluff/orange(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["o_bandana"])
		if(uses >= 1)
			new /obj/item/clothing/head/helmet/greenbandana/fluff/taryn_kifer_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["w_hat"])
		if(uses >= 1)
			new /obj/item/clothing/head/fluff/bruce_hachert(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["s_goggles"])
		if(uses >= 1)
			new /obj/item/clothing/glasses/fluff/uzenwa_sissra_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["s_pan"])
		if(uses >= 1)
			new /obj/item/clothing/head/fluff/krinnhat(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["p_dress"])
		if(uses >= 1)
			new /obj/item/clothing/under/fluff/tian_dress(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["k_offsuit"])
		if(uses >= 1)
			new /obj/item/clothing/under/fluff/callum_suit(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["r_dressuniform"])
		if(uses >= 1)
			new /obj/item/clothing/under/fluff/olddressuniform(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["ex_com_suit"])
		if(uses >= 1)
			new /obj/item/clothing/under/fluff/wyatt_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["w_officer"])
		if(uses >= 1)
			new /obj/item/clothing/under/rank/security/fluff/jeremy_wolf_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["r_uniform"])
		if(uses >= 1)
			new /obj/item/clothing/under/fluff/ana_issek_1(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["duckbelt"])
		if(uses >= 1)
			new /obj/item/weapon/storage/belt/inflatable(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["flippers"])
		if(uses >= 1)
			new /obj/item/clothing/shoes/swimmingfins(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["snorkel"])
		if(uses >= 1)
			new /obj/item/clothing/mask/snorkel(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()
	else if (href_list["balloon"])
		if(uses >= 1)
			new /obj/item/toy/vipballoon(usr.loc)
			uses -= 1
			usr.visible_message("\icon[src]Poof! The [src] dissappaers")
			del src
			close()




/obj/item/VIP_store/proc/close(mob/user as mob)
	usr.unset_machine()
	usr << browse(null, "window=VIP")




/mob/living/carbon/human/proc/equipvipvox()
	equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_robes(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(src), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/vox(src), slot_gloves) // AS ABOVE.
	equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), slot_wear_mask)
	equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen/emergency(src), slot_l_store)
	equip_to_slot_or_del(new /obj/item/VIP_store(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/medic(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/medic(src), slot_head)
	equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), slot_belt) // Who needs actual surgical tools?
	equip_to_slot_or_del(new /obj/item/device/radio/headset(src), slot_l_ear)
	equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(src), slot_back)


	var/obj/item/weapon/card/id/C = new(src)
	C.name = "[real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(access_maint_tunnels,access_trading,access_external_airlocks)
	C.assignment = "Trader"
	C.registered_name = real_name
	var/obj/item/weapon/storage/wallet/W = new(src)
	W.handle_item_insertion(C)
	spawn_money(rand(50,150)*10,W)
	equip_to_slot_or_del(W, slot_wear_id)

/client/proc/vip_vox()
	set name = "Make Me Vox!"
	set category = "Vip"
	if(usr.client.vipholder)
		if(!vip_check_rights(V_SUPER))
			return
	var/mob/M = usr
	if (istype(M, /mob/dead/))
		M << "\red You are dead you can't become a Vox unless you are alive and a humanonid"
		return
	if(jobban_isbanned(usr, "VIP VOX"))
		src << "\red <B>You have been banned from using this feature</B>"
		return

	if(alert("Are you sure you want to become a Vox? If so your current charater and items will be deleted and you will spawn on the Skipjack.",,"Yes","No")=="No")
		return
	if(ticker && istype(ticker.mode,/datum/game_mode/heist))
		usr << "This can not be used in this game mode"
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(usr,/mob/living/carbon/human))

		usr << "This can only be used on instances of type /mob/living/carbon/human"
		return
	else
		vip_vox_ship_tele()
		H.Voxify()
		verbs.Remove(/client/proc/vip_vox_ship_tele,/client/proc/vip_vox)


/client/proc/vip_vox_ship_tele()
	set name = "Teleport to Skipjack!"
	set category = "Vip"

	if(ticker && istype(ticker.mode,/datum/game_mode/heist))
		verbs.Remove(/client/proc/vip_vox_ship_tele)
		return
	if(usr.client.vipholder)
		if(!vip_check_rights(V_SUPER))
			return
	if(jobban_isbanned(usr, "VIP VOX"))
		src << "\red <B>You have been banned from using this feature</B>"
		return
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		if(!H.species.name == "Vox")
			src << "\red <B>You have to be a Vox to use this verb</B>"
			return
	else
		src << "\red <B>You have to be a Vox to use this verb</B>"
		return
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	var/shipx = 0
	var/shipy = 0
	var/shipz = 0
	if(vox_shuttle_transit == 1)
		shipx = 72
		shipy = 218
		shipz = 2
	else
		if(vip_vox_shuttle_location == "solars_fore_starboard")
			shipx = 211
			shipy = 173
			shipz = 1
		else if(vip_vox_shuttle_location == "solars_fore_port")
			shipx = 80
			shipy = 180
			shipz = 1
		else if(vip_vox_shuttle_location == "solars_aft_starboard")
			shipx = 216
			shipy = 79
			shipz = 1
		else if(vip_vox_shuttle_location == "solars_aft_port")
			shipx = 48
			shipy = 79
			shipz = 1
		else if(vip_vox_shuttle_location == "mining")
			shipx = 178
			shipy = 41
			shipz = 5

		else if(vip_vox_shuttle_location == "start")
			shipx = 76
			shipy = 17
			shipz = 2



	var/mob/living/carbon/human/H = usr
	if(!istype(usr,/mob/living/carbon/human))

		usr << "This can only be used on instances of type /mob/living/carbon/human"
		return
	else

		H.x = shipx
		H.y = shipy
		H.z = shipz

		verbs.Remove(/client/proc/vip_vox_ship_tele)


/client/proc/vipNamepick()
	set name = "Change Name!"
	set category = "Vip"
	if(!ticker)
		return
	if(usr.client.vipholder)
		if(!vip_check_rights(V_SUPER))
			return

	var/mob/M = usr
	if (istype(M, /mob/dead/))
		M << "\red You are dead you can't change your name unless you are alive and a humanonid"
		return

	if(alert("Are you sure you want to change your name?",,"Yes","No")=="No")
		return

	if(!istype(usr,/mob))
		usr << "This can only be used on instances of type /mob"
		return
	else
		var/new_name
		new_name = copytext(sanitize(input(usr,"What would you like your new name to be? You may only do this once.","Input a name",M.real_name) as text|null),1,MAX_NAME_LEN)
		if( !new_name || !M )	return

		M.fully_replace_character_name(M.real_name,new_name)
		verbs.Remove(/client/proc/Namepick)

/client/proc/VIP_Borg_Sprite()
	set name = "VIP Borg Sprite!"
	set category = "Vip"
	if(!ticker)
		return
	if(usr.client.vipholder)
		if(!vip_check_rights(V_SUPER))
			return

	var/mob/M = usr
	if (istype(M, /mob/dead/))
		M << "\red You are dead you can't Change your Sprite unless you are alive and a Cyborg"
		return

	if (!istype(M, /mob/living/silicon/robot))
		M << "\red You Must be a Cyborg this to work"
		return

	var/mob/living/silicon/robot/D = usr
	if(D.modtype == "Default")
		D << "\red You must selet a Module first"
		return
	else
		if(D.vip_triesleft == 0)
			verbs.Remove(/client/proc/VIP_Borg_Sprite)
			return
		else
			D.vip_triesleft--

	if (istype(D, /mob/living/silicon/robot) && D.vip_triesleft >= 1)
		var/previous_icon = D.icon_state

		if(D.modtype == "Default")
			D << "\red You must selet a Module first"
			return
		if(D.modtype == "Standard")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale","Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Robot"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Standard"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Standard"
					D.openpanel_icon ="ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Standard"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Service")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Service"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Service"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Service"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Service"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Miner")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Miner"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Miner"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Miner"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Miner"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Medical")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Medical"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Medical"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Medical"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Medical"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Security")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Security"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Security"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Security"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Security"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Engineering")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Engineering"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Engineering"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Engineering"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Engineering"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
		if(D.modtype == "Janitor")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Janitor"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Janitor"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Janitor"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Janitor"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = "previous_icon"
		if(D.modtype == "Combat")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Vip", "Sydrec", "Djsnapshot")
			switch(icontype)
				if("Vip")
					D.icon_state = "vip-Combat"
					D.openpanel_icon = "ov-openpanel"
				if("Sydrec")
					D.icon_state = "sydrec-Combat"
					D.openpanel_icon = "sydrec-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Combat"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = previous_icon
			D.base_icon = D.icon_state
			D.rolling_state = "[D.icon_state]-roll"

		if(D.modtype == "Surgery")
			var/icontype = ""
			icontype = input("Select an icon! [D.vip_triesleft ? "You have [D.vip_triesleft] more chances." : "This is your last try."]", "Cyborg", null, null) in list("Sydrec", "Ravensdale", "Djsnapshot")
			switch(icontype)
				if("Sydrec")
					D.icon_state = "sydrec-Surgery"
					D.openpanel_icon = "sydrec-openpanel"
				if("Ravensdale")
					D.icon_state = "ravensdale-Surgery"
					D.openpanel_icon = "ov-openpanel"
				if("Djsnapshot")
					D.icon_state = "djsnapshot-Surgery"
					D.openpanel_icon ="djsnapshot-openpanel"
				else D.icon_state = "previous_icon"

		if (D.vip_triesleft >= 1)
			var/choice = input("Look at your icon - is this what you want?") in list("Yes","No")
			if(choice=="No")
				VIP_Borg_Sprite()
			else
				D.vip_triesleft = 0
				verbs.Remove(/client/proc/VIP_Borg_Sprite)
				return
		else
			src << "Your icon has been set. You now require a module reset to change it."
	else
		return


/client/proc/VIP_AI_Sprite()
	set name = "VIP AI Sprite!"
	set category = "Vip"
	if(!ticker)
		return
	if(usr.client.vipholder)
		if(!vip_check_rights(V_SUPER))
			return

	var/mob/M = usr
	if (istype(M, /mob/dead/))
		M << "\red You are dead you can't Change your Sprite unless you are alive and an AI"
		return

	if (!istype(M, /mob/living/silicon/ai))
		M << "\red You Must be a AI for this to work"
		return
	var/mob/living/silicon/ai/A = usr
	if (istype(A, /mob/living/silicon/ai))
		if(A.vip_triesleft== 0)
			verbs.Remove(/client/proc/VIP_AI_Sprite)
			return
		else
			A.vip_triesleft--

	if (istype(A, /mob/living/silicon/ai))
		var/previous_icon = A.icon_state

		var/icontype = ""
		icontype = input("Select an icon! [A.vip_triesleft ? "You have [A.vip_triesleft] more chances." : "This is your last try."]", "ai", null, null) in list("Vip", "Serithi", "Ravensdale")
		switch(icontype)
			if("Vip") A.icon_state = "vip-ai"
			if("Serithi") A.icon_state = "serithi-ai"
			if("Ravensdale") A.icon_state = "ravensdale-ai"
			else A.icon_state = previous_icon

	if (A.vip_triesleft >= 1)
		var/choice = input("Look at your icon - is this what you want?") in list("Yes","No")
		if(choice=="No")
			VIP_AI_Sprite()
		else
			A.vip_triesleft = 0
			verbs.Remove(/client/proc/VIP_AI_Sprite)
			return


