// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/construction_time = 120
	var/construction_cost = list("metal"=10000)
	var/locked = 0
	var/require_module = 0
	var/installed = 0
	req_access = list(access_heads)

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		usr << "\red The [src] will not function on a deceased robot."
		return 1
	return 0


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = 1

/obj/item/borg/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.uneq_all()
	R.hands.icon_state = "nomod"
	R.icon_state = "robot"
	del(R.module)
	R.module = null
	R.camera.network.Remove(list("Medical","MINE"))
	R.updatename("Default")
	R.status_flags |= CANPUSH
	R.updateicon()
	R.hud = null
	R.openpanel_icon = "ov-openpanel"
	for(var/obj/item/borg/upgrade/combat/C in R)
		del C
	for(var/obj/item/borg/upgrade/surgery/su in R)
		del su
	for(var/obj/item/borg/sight/hud/sec/S in R)
		del S
	for(var/obj/item/borg/sight/hud/med/M in R)
		del M
	R.sight_mode = 0
	for(var/client/C in vips)
		if(C.vipholder)
			R.vip_triesleft = 4
			C.verbs.Add(/client/proc/VIP_Borg_Sprite)

	return 1

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	construction_cost = list("metal"=35000)
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as mob)
	heldname = stripped_input(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	construction_cost = list("metal"=60000 , "glass"=5000)
	icon_state = "cyborg_upgrade1"


/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		usr << "You have to repair the robot before using this module!"
		return 0

	if(!R.key)
		for(var/mob/dead/observer/ghost in player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.stat = CONSCIOUS
	return 1


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	construction_cost = list("metal"=80000 , "glass"=6000 , "gold"= 5000)
	icon_state = "cyborg_upgrade2"
	require_module = 1

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if(R.modtype == "Combat")
		usr << "\red Cannot be used on Combat Borgs!"
		return 0
	if(R.speed == -1)
		return 0

	R.speed--
	return 1


/obj/item/borg/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	construction_cost = list("metal"=80000 , "glass"=6000 , "gold"= 2000, "diamond" = 500)
	icon_state = "cyborg_upgrade3"
	require_module = 1


/obj/item/borg/upgrade/tasercooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!istype(R.module, /obj/item/weapon/robot_module/security))
		R << "Upgrade mounting error!  No suitable hardpoint detected!"
		usr << "There's no mounting point for the module!"
		return 0

	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		usr << "This robot has had its taser removed!"
		return 0

	if(T.recharge_time <= 2)
		R << "Maximum cooling achieved for this hardpoint!"
		usr << "There's no room for another cooling unit!"
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return 1

/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	construction_cost = list("metal"=10000,"phoron"=15000,"uranium" = 20000)
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!istype(R.module, /obj/item/weapon/robot_module/miner))
		R << "Upgrade mounting error!  No suitable hardpoint detected!"
		usr << "There's no mounting point for the module!"
		return 0
	else
		R.module.modules += new/obj/item/weapon/tank/jetpack/carbondioxide
		for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.modules)
			R.internals = src
		//R.icon_state="Miner+j"
		return 1

/obj/item/borg/upgrade/grabber
	name = "cyborg grabbing upgrade"
	desc = "A upgrade to allow borgs to grab living things."
	construction_cost = list("metal"=10000,"phoron"=15000,"uranium" = 20000)
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/grabber/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if(contents)
		var/obj/item/borg/upgrade/grabber/G = locate() in R
		if(G)
			R << "Upgrade mounting error!  Grabber Upgrade already installed!"
			usr << "Grabber Upgrade already installed!"
			return 0
	if(istype(R.module, /obj/item/weapon/robot_module/surgery))
		R << "Upgrade mounting error!  Grabber Upgrade already installed!"
		usr << "Grabber Upgrade already installed!"
		return 0
	else
		R.module.modules += new/obj/item/borg/grab
		return 1

/obj/item/borg/upgrade/syndicate/
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot"
	construction_cost = list("metal"=10000,"glass"=5000,"diamond" = 10000)
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.emagged == 1)
		return 0

	R.emagged = 1
	return 1

/obj/item/borg/upgrade/combat
	name = "Combat Module Board"
	desc = "Used to make a cyborg into a combat cyborg."
	icon_state = "cyborg_upgrade1"
	construction_cost = list("metal"=10000,"glass"=15000,"gold"= 10000, "diamond" = 10000)
	require_module = 1
	locked = 1


/obj/item/borg/upgrade/combat/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if (get_security_level() == "green")
		usr << "\red Cannot be used during green alert"
		return 0
	if(R.modtype != "Security")
		usr << "\red Can only be used on Security Borgs!"
		return 0
	R.uneq_all()
	R.hands.icon_state = "nomod"
	del(R.module)
	R.module = new /obj/item/weapon/robot_module/combat(src)
	R.modtype = "Combat"
	R.updatename("Combat")
	R.icon_state = "droid-combat"
	R.base_icon = R.icon_state
	R.rolling_state = "[R.icon_state]-roll"
	R.updateicon()
	R.openpanel_icon = "ov-openpanel"
	R.sight_mode = 0
	R.sight_mode = BORGTHERM
	for(var/obj/item/borg/upgrade/vtec/V in R.contents)
		del V
		R.speed = 0
	for(var/obj/item/borg/sight/hud/med/M in R)
		del M
	for(var/obj/item/borg/sight/hud/sec/S in R)
		del S
	R.hud = new /obj/item/borg/sight/hud/sec(R)

	for(var/client/C in vips)
		if(C.vipholder)
			R.vip_triesleft = 4
			C.verbs.Add(/client/proc/VIP_Borg_Sprite)

	return 1

/obj/item/borg/upgrade/surgery
	name = "Surgery Module Board"
	desc = "Used to make a medical cyborg into a advanced surgery cyborg."
	icon_state = "cyborg_upgrade1"
	construction_cost = list("metal"=10000,"glass"=15000,"gold"= 10000, "diamond" = 10000)
	require_module = 1
	locked = 1

/obj/item/borg/upgrade/surgery/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if(R.modtype != "Medical")
		usr << "\red Can only be used on Medical Borgs!"
		return 0
	R.uneq_all()
	R.hands.icon_state = "nomod"
	del(R.module)
	R.module = new /obj/item/weapon/robot_module/surgery(src)
	R.modtype = "Surgery"
	R.updatename("Surgery")
	R.icon_state = "medbot-Surgery"
	R.updateicon()
	R.openpanel_icon = "ov-openpanel"
	R.sight_mode = 0
	for(var/obj/item/borg/upgrade/grabber/G in R)
		del G
	for(var/obj/item/borg/sight/hud/med/M in R)
		del M
	for(var/obj/item/borg/sight/hud/sec/S in R)
		del S
	R.hud = new /obj/item/borg/sight/hud/med(R)
	R.verbs.Add(/mob/living/silicon/robot/proc/changeiconsurgery)
	R << "\blue you can change your sprite via the robot commands tab"
	for(var/client/C in vips)
		if(C.vipholder)
			R.vip_triesleft = 4
			C.verbs.Add(/client/proc/VIP_Borg_Sprite)

	return 1


/obj/item/borg/upgrade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/id))
		if(check_access(W))
			src.locked = !( src.locked )
			if(src.locked)
				user << "\red You lock the [src.name]!"
				return
			else
				user << "\red You unlock the [src.name]!"
				return
		else
			user << "\red Access Denied"
			return
	else if(istype(W, /obj/item/weapon/card/emag))
		locked = 0
		for(var/mob/O in viewers(user, 3))
			O.show_message(text("\blue The locker has been broken by [] with an electromagnetic card!", user), 1, text("You hear a faint electrical spark."), 2)

	if(!locked)
		..()
	else
		user << "\red Its locked!"
	return
/obj/item/borg/upgrade/check_access(obj/item/weapon/card/id/I)
	if(!istype(req_access, /list)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!L.len) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/weapon/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/robot/proc/changeiconsurgery()
	set category = "Robot Commands"
	set name = "Change Sprite"
	var/module_sprites[0]
	module_sprites["Basic"] = "medbot-Surgery"
	module_sprites["Advanced Surgery Droid"] = "droid-Surgery"
	module_sprites["Needles(surgery)"] = "medicalrobot-Surgery"
	module_sprites["Standard(surgery)"] = "surgeon-Surgery"
	if(isrobot(usr))
		var/mob/living/silicon/robot/Ro = usr
		if(Ro.modtype == "Surgery")
			Ro.choose_icon(6,module_sprites)
		else
			Ro.verbs.Remove(/mob/living/silicon/robot/proc/changeiconsurgery)
			return
	else
		verbs.Remove(/mob/living/silicon/robot/proc/changeiconsurgery)
