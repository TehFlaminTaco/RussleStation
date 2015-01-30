/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	var/magpulse = 0
	icon_action_button = "action_blank"
	action_button_name = "Toggle the magboots"
//	flags = NOSLIP //disabled by default

	attack_self(mob/user as mob)

		var/mob/living/carbon/human/H = user
		var/digitigrade
		if(H.species.digitigrade) //Is this some idiot wearing the wrong shoes? ~Aztec
			digitigrade = 1
		else
			digitigrade = null

		if(magpulse)
			flags &= ~NOSLIP
			if (digitigrade) //Slow them down! ~Aztec
				slowdown = 3
			else
				slowdown = SHOES_SLOWDOWN

			baseslowdown = SHOES_SLOWDOWN
			magpulse = 0
			icon_state = "magboots0"
			user << "You disable the mag-pulse traction system."
		else
			flags |= NOSLIP
			if (digitigrade) //Slow them down! ~Aztec
				slowdown = 5
			else
				slowdown = 2

			baseslowdown = 2
			magpulse = 1
			icon_state = "magboots1"
			user << "You enable the mag-pulse traction system."
		user.update_inv_shoes()	//so our mob-overlays update


	examine()
		set src in view()
		..()
		var/state = "disabled"
		if(src.flags&NOSLIP)
			state = "enabled"
		usr << "Its mag-pulse traction system appears to be [state]."