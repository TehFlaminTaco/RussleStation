/obj/item/clothing/head/helmet/space/EMHardsuits
	name = "EMHardsuits"
	icon_state = null
	item_state = null
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight)
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	item_color = "engineering" //Determines used sprites: rig[on]-[color] and rig[on]-[color]2 (lying down sprite)
	icon_action_button = "action_hardhat"
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		icon_state = "rig[on]-[item_color]"
//		item_state = "rig[on]-[item_color]"

		if(on)	user.SetLuminosity(user.luminosity + brightness_on)
		else	user.SetLuminosity(user.luminosity - brightness_on)

	pickup(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity + brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(0)

	dropped(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity - brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(brightness_on)

/obj/item/clothing/suit/space/EMHardsuits
	name = "EM hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = null
	item_state = null
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE


	//Red
/obj/item/clothing/head/helmet/space/EMHardsuits/Red
	name = "Red hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-red"
	item_color = "red"

/obj/item/clothing/suit/space/EMHardsuits/Red
	icon_state = "rig-red"
	name = "Red hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "red_hardsuit"

	//Blue
/obj/item/clothing/head/helmet/space/EMHardsuits/Blue
	name = "Blue hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-blue"
	item_color = "blue"

/obj/item/clothing/suit/space/EMHardsuits/Blue
	icon_state = "rig-blue"
	name = "Blue hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "blue_hardsuit"

	//Green
/obj/item/clothing/head/helmet/space/EMHardsuits/Green
	name = "Green hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-green"
	item_color = "green"

/obj/item/clothing/suit/space/EMHardsuits/Green
	icon_state = "rig-green"
	name = "Green hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "green_hardsuit"

	//Orange
/obj/item/clothing/head/helmet/space/EMHardsuits/Orange
	name = "Orange hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-orange"
	item_color = "orange"

/obj/item/clothing/suit/space/EMHardsuits/Orange
	icon_state = "rig-orange"
	name = "Orange hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "orange_hardsuit"

	//Purple
/obj/item/clothing/head/helmet/space/EMHardsuits/Purple
	name = "Purple hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-purple"
	item_color = "purple"

/obj/item/clothing/suit/space/EMHardsuits/Purple
	icon_state = "rig-purple"
	name = "Purple hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "purple_hardsuit"

	//Yellow
/obj/item/clothing/head/helmet/space/EMHardsuits/Yellow
	name = "Yellow hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-yellow"
	item_color = "yellow"

/obj/item/clothing/suit/space/EMHardsuits/Yellow
	icon_state = "rig-yellow"
	name = "Yellow hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "yellow_hardsuit"

/obj/item/clothing/head/helmet/space/rig/syndi/Jamie
	name = "Jamie's Helmet"
	desc = "A special helmet that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans, it has the words Jamie sctratched on the back."
	icon_state = "rig0-jamie"
	item_state = "rig0-jamie"
	item_color = "jamie" //Determines used sprites: rig[on]-[color] and rig[on]-[color]2 (lying down sprite)
	icon_action_button = "action_hardhat"
	species_restricted = list("Avisaran")

/obj/item/clothing/suit/space/rig/syndi/Jamie
	name = "Jamie's Hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans, it has the words Jamie sctratched on the back. It has two large slits for wings to be put through."
	icon_state = "rig-jamie"
	item_state = "rig-jamie"
	species_restricted = list("Avisaran")
