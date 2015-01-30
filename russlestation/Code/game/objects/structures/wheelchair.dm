/obj/structure/stool/bed/chair/wheelchair
	name = "Wheelchair"
	icon = 'icons/obj/wheelchair.dmi'
	desc = "A chair with wheels on it"
	icon_state = "wheelchair"
	anchored = 1
	density = 0
	var/wheellock = 1
	var/mob/living/buckled_mob2
	var/list/proc_res = list()
	var/datum/events/events
	var/can_move = 1
	var/step_in = 5
	var/datum/global_iterator/pr_inertial_movement
	var/attachedtank = 0
	var/obj/item/weapon/tank/mytank = null
	var/tanktoggle = 0








/obj/structure/stool/bed/chair/wheelchair/New()
	..()
	events = new
	add_iterators()
	if(!attachedtank)
		src.verbs -= /obj/structure/stool/bed/chair/wheelchair/verb/Toggle_Tank
		src.verbs -= /obj/structure/stool/bed/chair/wheelchair/verb/removetank

	return

/obj/structure/stool/bed/chair/wheelchair/verb/wheellock()
	set name = "Wheel Lock"
	set category = "Object"
	set src in oview(1)
	if(wheellock >= 1)
		wheellock = 0
		anchored = 0
		usr << "<span class='notice'>You unlock the wheels</span>"
	else
		usr << "<span class='notice'>You lock the wheels</span>"
		wheellock = 1
		anchored = 1

/*  //broken sprite of buckled mob will not change when pulled
/obj/structure/stool/bed/chair/wheelchair/verb/pullWC()
	set name = "Pull"
	set category = "IC"
	set src in oview(1)

	usr.start_pulling(src)
	return
*/

/obj/structure/stool/bed/chair/wheelchair/verb/Toggle_Tank()
	set name = "Toggle Tank"
	set category = "Object"
	set src in oview(1)
	if(attachedtank)
		if(tanktoggle >= 1)
			tanktoggle = 0
			usr << "<span class='notice'>You turn off the tank</span>"
		else
			usr << "<span class='notice'>You turn on the tank</span>"
			tanktoggle = 1
	else
		usr << "<span class='notice'>You need a tank attached to the wheelchair to use this</span>"




/obj/structure/stool/bed/chair/wheelchair/proc/add_iterators()
	pr_inertial_movement = new /datum/global_iterator/WC_intertial_movement(null,0)

/datum/global_iterator/WC_intertial_movement //inertial movement in space
	delay = 7

	process(var/obj/structure/stool/bed/chair/wheelchair/WC as obj,direction)
		if(direction)
			if(!step(WC, direction)||WC.check_for_support())
				src.stop()
		else
			src.stop()
		return


/obj/structure/stool/bed/chair/wheelchair/Move()
	if(buckled_mob)
		if(buckled_mob.stat || buckled_mob.stunned || buckled_mob.weakened || buckled_mob.paralysis)
			unbuckle()
			handle_rotation()
	. = ..()
	if(.)
		events.fireEvent("onMove",get_turf(src))
		if(buckled_mob)
			buckled_mob.loc = src.loc
	return

/obj/structure/stool/bed/chair/wheelchair/proc/do_after(delay as num)
	sleep(delay)
	if(src)
		return 1
	return 0



/obj/structure/stool/bed/chair/wheelchair/relaymove(mob/user,direction)
	if(user != src.buckled_mob) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		user << "You climb out from [src]"
		return 0
	handle_rotation()
	return domove(direction)

/obj/structure/stool/bed/chair/wheelchair/proc/domove(direction)
	return call((proc_res["dyndomove"]||src), "dyndomove")(direction)

/obj/structure/stool/bed/chair/wheelchair/proc/dyndomove(direction)
	if(wheellock >= 1)
		usr << "You need to unlock the wheels"
	else
		update_mob()
	//	update_mob2()
		handle_rotation()
		var/tmp_step_in = step_in
		if(!can_move)
			return 0
		var/move_result = 0
		if(!attachedtank && src.pr_inertial_movement.active())
			return 0
		if(src.dir!=direction)
			move_result = WCturn(direction)
			handle_rotation()
		else
			move_result	= WCstep(direction)
			handle_rotation()

		if(move_result)
			can_move = 0
			if(istype(src.loc, /turf/space))
				if(!src.check_for_support())
					src.pr_inertial_movement.start(list(src,direction))
					if(attachedtank && tanktoggle >= 1)
						if(mytank.air_contents.total_moles >=0.01)
							src.pr_inertial_movement.set_process_args(list(src,direction))
							mytank.air_contents.remove_ratio(0.025)
							step_in = 4
						else
							usr << "The [mytank] on the [src] has ran out"
							step_in = 5
							tanktoggle = 0
					else if(attachedtank && tanktoggle <= 0)
						return 0
			else
				if(attachedtank && (tanktoggle >=1) && (mytank.air_contents.total_moles >=0.01))
					step_in = 2
					mytank.air_contents.remove_ratio(0.010)
				else if(attachedtank && (tanktoggle >=1) && (mytank.air_contents.total_moles <=0.00))
					step_in = 5
					usr << "The [mytank] on the [src] has ran out"
					tanktoggle = 0


		can_move = 0
		spawn(tmp_step_in) can_move = 1
		return 1
	return 0

/obj/structure/stool/bed/chair/wheelchair/proc/WCturn(direction)
	dir = direction
	handle_rotation()

	return 1

/obj/structure/stool/bed/chair/wheelchair/proc/WCstep(direction)
	var/result = step(src,direction)
	handle_rotation()
	return result


/obj/structure/stool/bed/chair/wheelchair/proc/WCsteprand()
	var/result = step_rand(src)
	handle_rotation()

	return result

/obj/structure/stool/bed/chair/wheelchair/Bump(var/atom/obstacle)
	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(istype(O, /obj/effect/portal)) //derpfix
			src.anchored = 0
			O.HasEntered(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				src.anchored = 1
		else if(!O.anchored)
			step(obstacle,src.dir)
		else //I have no idea why I disabled this
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		step(obstacle,src.dir)
	else
		obstacle.Bumped(src)
	return

/obj/structure/stool/bed/chair/wheelchair/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/simulated, orange(1, src)) || locate(/turf/unsimulated, orange(1, src)))
		return 1
	else
		return 0

/obj/structure/stool/bed/chair/wheelchair/attackby(obj/item/W, mob/user)
	if((istype(W, /obj/item/weapon/tank)) && attachedtank <= 0)
		user << "<span class='notice'>You hook the tank onto the wheelchair.</span>"
		user.drop_item()
		W.loc = src
		attachedtank = 1
		src.verbs += /obj/structure/stool/bed/chair/wheelchair/verb/Toggle_Tank
		src.verbs += /obj/structure/stool/bed/chair/wheelchair/verb/removetank
		mytank = W
	if(buckled_mob)
		icon_state = "wheelchair-at-1"
	else
		icon_state = "wheelchair-at"
/obj/structure/stool/bed/chair/wheelchair/Bumped(atom/movable/M as mob|obj)
	update_mob()
	handle_rotation()
	return

/obj/structure/stool/bed/chair/wheelchair/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	if (istype(M, /mob/living/carbon/slime))
		user << "The [M] is too squishy to buckle in."
		return

	unbuckle()

	if (M == usr)
		update_mob()
		M.visible_message(\
			"\blue [M.name] buckles in!",\
			"You buckle yourself to [src].",\
			"You hear metal clanking")
	else
		update_mob()
		M.visible_message(\
			"\blue [M.name] is buckled in to [src] by [user.name]!",\
			"You are buckled in to [src] by [user.name].",\
			"You hear metal clanking")
	src.density = 1
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	return




/obj/structure/stool/bed/chair/wheelchair/handle_rotation()
	if(dir == SOUTH)
		layer = OBJ_LAYER
	else
		layer = FLY_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring
	update_mob()

/obj/structure/stool/bed/chair/wheelchair/proc/update_mob()
	if(buckled_mob)
		if(attachedtank)
			icon_state = "wheelchair-at-1"
			buckled_mob.dir = dir
			switch(dir)
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 1
				if(WEST)
					buckled_mob.pixel_x = 2
					buckled_mob.pixel_y = 3
				if(NORTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 1
				if(EAST)
					buckled_mob.pixel_x = -2
					buckled_mob.pixel_y = 3
		else
			icon_state = "wheelchair-1"
			buckled_mob.dir = dir
			switch(dir)
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 1
				if(WEST)
					buckled_mob.pixel_x = 2
					buckled_mob.pixel_y = 3
				if(NORTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 1
				if(EAST)
					buckled_mob.pixel_x = -2
					buckled_mob.pixel_y = 3

/obj/structure/stool/bed/chair/wheelchair/attack_paw(mob/user as mob)
	return src.attack_hand(user)
/obj/structure/stool/bed/chair/wheelchair/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return src.attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return
/obj/structure/stool/bed/chair/wheelchair/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/stool/bed/chair/wheelchair/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/wheelchair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

/obj/structure/stool/bed/chair/wheelchair/unbuckle(mob/M as mob, mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			if (attachedtank)
				icon_state = "wheelchair-at"
			else
				icon_state = "wheelchair"
		src.density = 0
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/structure/stool/bed/chair/wheelchair/manual_unbuckle(mob/user as mob)
	if(user)
		if(buckled_mob == null)
			return
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] was unbuckled by [user.name]!",\
					"You were unbuckled from [src] by [user.name].",\
					"You hear metal clanking")
			else
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] unbuckled \himself!",\
					"You unbuckle yourself from [src].",\
					"You hear metal clanking")
			unbuckle()
			src.add_fingerprint(user)

/obj/structure/stool/bed/chair/wheelchair/verb/removetank()
	set name = "Remove Tank"
	set category = "Object"
	set src in oview(1)
	usr.put_in_hands(src.mytank)
	src.mytank = null
	src.update_mob()
	src.handle_rotation()
	src.attachedtank = 0
	src.verbs -= /obj/structure/stool/bed/chair/wheelchair/verb/Toggle_Tank
	src.verbs -= /obj/structure/stool/bed/chair/wheelchair/verb/removetank
	src.tanktoggle = 0
	src.step_in = 5
	if(buckled_mob)
		icon_state = "wheelchair-1"
	else
		icon_state = "wheelchair"



/obj/structure/stool/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		removetank()
		usr << "it will take a few seconds to folded the [src]"
		sleep 15
		visible_message("[usr] collapses \the [src.name]")
		new/obj/item/wheelchair(get_turf(src))
		spawn(0)
			del(src)
		return

/obj/item/wheelchair
	name = "Wheelchair"
	desc = "A collapsed Wheelchair that can be carried around."
	icon = 'wheelchair.dmi'
	icon_state = "folded"
	w_class = 4.0 // Can't be put in backpacks. Oh well.
	slowdown = 1

	attack_self(mob/user)
		usr << "it will take a few seconds to unfolded the [src]"
		sleep 15
		var/obj/structure/stool/bed/chair/wheelchair/R = new /obj/structure/stool/bed/chair/wheelchair(user.loc)
		R.add_fingerprint(user)
		del(src)
