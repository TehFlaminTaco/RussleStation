/datum/job/hos
	title = "Head of Security"
	flag = HOS
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	idtype = /obj/item/weapon/card/id/head
	req_admin_notify = 1
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_rep, access_bs, access_military, access_trading)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_rep, access_bs, access_military, access_trading)
	minimal_player_age = 14

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), slot_wear_pda)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
//		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), slot_wear_mask) //Grab one from the armory you donk
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), slot_glasses)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_in_backpack)
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		H.combat_training = 1
		return 1



/datum/job/warden
	title = "Warden"
	flag = WARDEN
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/sec
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_morgue)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels)
	minimal_player_age = 7

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/warden(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/warden(H), slot_wear_pda)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), slot_glasses)
//		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), slot_wear_mask) //Grab one from the armory you donk
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_in_backpack)
		H.combat_training = 1
		return 1



/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	alt_titles = list("Forensic Technician")
	idtype = /obj/item/weapon/card/id/detective

	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court)
	alt_titles = list("Forensic Technician")
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/det(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/detective(H), slot_wear_pda)
/*		var/obj/item/clothing/mask/cigarette/CIG = new /obj/item/clothing/mask/cigarette(H)
		CIG.light("")
		H.equip_to_slot_or_del(CIG, slot_wear_mask)	*/
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		if(H.mind.role_alt_title && H.mind.role_alt_title == "Forensic Technician")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/forensics/blue(H), slot_wear_suit)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/det_suit(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/lighter/zippo(H), slot_l_store)

		if(H.backbag == 1)//Why cant some of these things spawn in his office?
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), slot_r_store)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), slot_in_backpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_in_backpack)

		return 1



/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/sec
	access = list(access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels)
	minimal_player_age = 7
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_wear_pda)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_l_hand)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_in_backpack)
		H.combat_training = 1
		return 1

/datum/job/blueshield
	title = "Blueshield"
	flag = BLUESHIELD
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Head Of Security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/fluff/blueshield
	access = list(access_bs, access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue)
	minimal_access = list(access_bs, access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels)

	equip(var/mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/fluff/deus_blueshield(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom/captain(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_wear_pda)

		if(H.backbag == 1)
			var/obj/item/weapon/storage/box/survival/Barpack = new /obj/item/weapon/storage/box/survival(H)
			H.equip_to_slot_or_del(Barpack, slot_r_hand)
			new /obj/item/weapon/storage/box/beanbag(Barpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/beanbag(H), slot_in_backpack)
			if(H.client.vipholder && H.client.vipholder.rights & V_SUPER)
				H.equip_to_slot_or_del(new /obj/item/VIP_store(H.back), slot_in_backpack)
		H.combat_training = 1

		return 1



	//// Work on!!!! Blackmarket
/*
/datum/job/russian
	title = "Russian Trader"
	flag = RT
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0
	spawn_positions = 2
	supervisors = "READ THE PAPER ON THE TABLE"
	selection_color = "#dddddd"
	req_admin_notify = 1
	access = list(access_trading, access_teleporter)
	minimal_access = list(access_trading, access_teleporter, access_construction)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/syndigaloshes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_wear_pda)

		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1
	*/
/// /obj/item/clothing/head/ushanka



/*
/datum/job/russian/re
	title = "Russian Engineer"
	flag = RE
	department_flag = ENGSEC
	faction = "Russian"
	total_positions = 0
	spawn_positions = 1
	supervisors = "No-one"
	selection_color = "#990000"
	req_admin_notify = 1
	access = list(access_trading)
	minimal_access = list(access_trading)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/syndigaloshes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_wear_pda)

		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1



/datum/job/military
	title = "Military"
	flag = RE
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0
	spawn_positions = 3
	supervisors = "Centcom and Captain"
	selection_color = "#d403f8"
	req_admin_notify = 1
	access = list(access_military)
	minimal_access = list(access_military)
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_wear_pda)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
		return 1
		*/
