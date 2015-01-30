/client/proc/purlek_respawn()
	set category = "OOC"
	set name = "Purlek Respawn"
	var/mob/M = mob
	M.p_respawn()

/client/proc/wolfiri_respawn()
	set category = "OOC"
	set name = "Wolfiri Respawn"
	var/mob/M = mob
	M.w_respawn()

/client/proc/purlek_jump()
	set category = "OOC"
	set name = "Purlek Jump"
	var/mob/M = mob
	M.w_go()

/mob/proc/w_go()
	if(!client.holder)
		src << "Only administrators may use this command."
		return
	if(src.key == "Purlek")
		var/mob/P = src
		P.x = 35
		P.y = 34
		P.z = 3
	else if(src.key == "Wolfiri")
		var/mob/W = src
		W.x = 35
		W.y = 34
		W.z = 3
	else
		src << "This is for Purlek & Wolfiri only!"
		return

/mob/proc/p_respawn()
	if(!client.holder)
		src << "Only administrators may use this command."
		return
	if(!isobserver(src))
		src << "You must be a ghost to respawn"
		return
	if(src.key != "Purlek")
		src << "This is only for Purlek!"
		return

	var/mob/dead/observer/J = src

	var/mob/living/carbon/human/H = new/mob/living/carbon/human(J.loc)

	H.add_language("Sol Common")

	H.key = J.key		//Manually transfer the key to log them in

	H.real_name = "Bill Werner"
	H.name = "Bill Werner"
	H.h_style = "Half-banged Hair"
	H.f_style = "Goatee"

	//Manually transfer the key to log them in

	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/red(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	var/obj/item/device/pda/captain/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "Accountant"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_to_slot_or_del(pda, slot_wear_pda)

	var/obj/item/weapon/card/id/syndicate/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = get_all_accesses()
	W.assignment = "Accountant"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, slot_wear_id)

	H.regenerate_icons()


	log_admin("[key_name(usr)] Un-ghosted.")
	message_admins("\blue [key_name_admin(usr)] Unghosted.", 1)
	del(J)

/mob/proc/w_respawn()
	if(!client.holder)
		src << "Only administrators may use this command."
		return
	if(!isobserver(src))
		src << "You must be a ghost to respawn"
		return
	if(src.key != "Wolfiri")
		src << "This is only for Wolfiri!"
		return

	var/mob/dead/observer/J = src

	var/mob/living/carbon/human/H = new/mob/living/carbon/human(J.loc)

	H.add_language("Sol Common")

	H.key = J.key		//Manually transfer the key to log them in

	H.real_name = "Eve Werner"
	H.name = "Eve Werner"
	H.h_style = "Long Hair Alt"
	H.r_hair = 102
	H.b_hair = 1
	H.g_hair = 51
	H.f_style = "Shaved"

	//Manually transfer the key to log them in

	H.equip_to_slot_or_del(new /obj/item/clothing/under/schoolgirl(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/kitty(H), slot_head)

	var/obj/item/device/pda/captain/pda = new(H)
	pda.owner = H.real_name
	pda.ownjob = "Accountant's Assistant"
	pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	H.equip_to_slot_or_del(pda, slot_wear_pda)

	var/obj/item/weapon/card/id/syndicate/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.access = get_all_accesses()
	W.assignment = "Accountant's Assistant"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, slot_wear_id)

	H.regenerate_icons()

	log_admin("[key_name(usr)] Un-ghosted.")
	message_admins("\blue [key_name_admin(usr)] Unghosted.", 1)
	del(J)