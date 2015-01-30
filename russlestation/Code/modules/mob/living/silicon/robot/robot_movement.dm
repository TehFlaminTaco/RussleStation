/mob/living/silicon/robot/Process_Spacemove()
	if(module)
		for(var/obj/item/weapon/tank/jetpack/J in module.modules)
			if(J && istype(J, /obj/item/weapon/tank/jetpack))
				if(J.allow_thrust(0.01))	return 1
	if(..())	return 1
	return 0

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			tally = -2
			icon_state = rolling_state
		else
			tally = speed
			icon_state = base_icon

	return tally+config.robot_delay

/mob/living/silicon/robot/Move()
	..()