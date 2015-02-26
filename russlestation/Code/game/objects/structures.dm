/obj/structure
	icon = 'icons/obj/structures.dmi'
	var/climbable = 0
	var/breakable

obj/structure/blob_act()
	if(prob(50))
		del(src)

obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if(prob(50))
				del(src)
				return
		if(3.0)
			return

obj/structure/meteorhit(obj/O as obj)
	del(src)

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		user << "<span class='notice'>You need your hands and legs free for this.</span>"
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		user << "<span class='notice'>You need hands for this.</span>"
		return 0
	return 1

/obj/structure/proc/can_climb(var/mob/living/user)
	if (!can_touch(user) || !climbable)
		return 0

	var/turf/T = src.loc
	if(!T || !istype(T)) return 0

	if (!user.Adjacent(src))
		user << "\red You can't climb there, the way is blocked."
		return 0

	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable)
				continue

		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			user << "\red There's \a [O] in the way."
			return 0
	return 1

/obj/structure/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")

	if(!do_after(user,50))
		return

	if (!can_climb(user))
		return

	usr.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")


/obj/structure/verb/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)






