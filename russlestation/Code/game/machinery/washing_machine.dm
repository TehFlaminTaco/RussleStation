/obj/machinery/washing_machine
	name = "Washing Machine"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_10"
	density = 1
	anchored = 1.0
	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/panel = 0
	//0 = closed
	//1 = open
	var/hacked = 1 //Bleh, screw hacking, let's have it hacked by default.
	//0 = not hacked
	//1 = hacked
	var/gibs_ready = 0
	var/obj/crayon


	MouseDrop_T(mob/target, mob/user)
		if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
			return
		if(isanimal(user) && target != user) return //animals cannot put mobs other than themselves into Washing Machine
		src.add_fingerprint(user)
		var/target_loc = target.loc
		var/msg
		for (var/mob/V in viewers(usr))
			if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
				V.show_message("[usr] starts climbing into the [src].", 3)
			if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
				if(target.anchored) return
				V.show_message("[usr] starts stuffing [target.name] into the [src].", 3)
		if(!do_after(usr, 20))
			return
		if(target_loc != target.loc)
			return
		if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)	// if drop self, then climbed in
												// must be awake, not stunned or whatever
			msg = "[user.name] climbs into the [src]."
			user << "You climb into the [src]."
		else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			msg = "[user.name] stuffs [target.name] into the [src]!"
			user << "You stuff [target.name] into the [src]!"

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [target.name] ([target.ckey]) in [src].</font>")
			target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in [src] by [user.name] ([user.ckey])</font>")
			msg_admin_attack("[user] ([user.ckey]) placed [target] ([target.ckey]) in a [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		else
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.loc = src
		state = 3
		update_icon()

		for (var/mob/C in viewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)

		update_icon()
		return
			// can breath normally in the Washing Machine
	alter_health()
		return get_turf(src)

	// attempt to move while inside
	relaymove(mob/user as mob)
		if(user.stat || state == (8|7))
			return
		src.go_out(user)
		return


	// leave the Washing Machine
	proc/go_out(mob/user)

		if (user.client)
			user.client.eye = user.client.mob
			user.client.perspective = MOB_PERSPECTIVE
		user.loc = src.loc
		state = 1
		update_icon()
		return

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)
	if(usr && usr.loc == src)
		usr << "\red You cannot reach the controls from inside."
		return

	if(!istype(usr, /mob/living)) //ew ew ew usr, but it's the only way to check.
		return

	if( state != 4 )
		usr << "The washing machine cannot run in this state."
		return

	if( locate(/mob,contents) )
		state = 8
	else
		state = 5
	update_icon()
	sleep(200)
	for(var/atom/A in contents)
		A.clean_blood()

	for(var/obj/item/I in contents)
		I.decontaminate()

	//Tanning!
	for(var/obj/item/stack/sheet/hairlesshide/HH in contents)
		var/obj/item/stack/sheet/wetleather/WL = new(src)
		WL.amount = HH.amount
		del(HH)


	if(crayon)
		var/wash_color
		if(istype(crayon,/obj/item/toy/crayon))
			var/obj/item/toy/crayon/CR = crayon
			wash_color = CR.colourName
		else if(istype(crayon,/obj/item/weapon/stamp))
			var/obj/item/weapon/stamp/ST = crayon
			wash_color = ST.item_color

		if(wash_color)
			var/new_jumpsuit_icon_state = ""
			var/new_jumpsuit_item_state = ""
			var/new_jumpsuit_name = ""
			var/new_glove_icon_state = ""
			var/new_glove_item_state = ""
			var/new_glove_name = ""
			var/new_shoe_icon_state = ""
			var/new_shoe_name = ""
			var/new_sheet_icon_state = ""
			var/new_sheet_name = ""
			var/new_softcap_icon_state = ""
			var/new_softcap_name = ""
			var/new_desc = "The colors are a bit dodgy."
			for(var/T in typesof(/obj/item/clothing/under))
				var/obj/item/clothing/under/J = new T
				//world << "DEBUG: [color] == [J.color]"
				if(wash_color == J.item_color)
					new_jumpsuit_icon_state = J.icon_state
					new_jumpsuit_item_state = J.item_state
					new_jumpsuit_name = J.name
					del(J)
					//world << "DEBUG: YUP! [new_icon_state] and [new_item_state]"
					break
				del(J)
			for(var/T in typesof(/obj/item/clothing/gloves))
				var/obj/item/clothing/gloves/G = new T
				//world << "DEBUG: [color] == [J.color]"
				if(wash_color == G.item_color)
					new_glove_icon_state = G.icon_state
					new_glove_item_state = G.item_state
					new_glove_name = G.name
					del(G)
					//world << "DEBUG: YUP! [new_icon_state] and [new_item_state]"
					break
				del(G)
			for(var/T in typesof(/obj/item/clothing/shoes))
				var/obj/item/clothing/shoes/S = new T
				//world << "DEBUG: [color] == [J.color]"
				if(wash_color == S.item_color)
					new_shoe_icon_state = S.icon_state
					new_shoe_name = S.name
					del(S)
					//world << "DEBUG: YUP! [new_icon_state] and [new_item_state]"
					break
				del(S)
			for(var/T in typesof(/obj/item/weapon/bedsheet))
				var/obj/item/weapon/bedsheet/B = new T
				//world << "DEBUG: [color] == [J.color]"
				if(wash_color == B.item_color)
					new_sheet_icon_state = B.icon_state
					new_sheet_name = B.name
					del(B)
					//world << "DEBUG: YUP! [new_icon_state] and [new_item_state]"
					break
				del(B)
			for(var/T in typesof(/obj/item/clothing/head/soft))
				var/obj/item/clothing/head/soft/H = new T
				//world << "DEBUG: [color] == [J.color]"
				if(wash_color == H.item_color)
					new_softcap_icon_state = H.icon_state
					new_softcap_name = H.name
					del(H)
					//world << "DEBUG: YUP! [new_icon_state] and [new_item_state]"
					break
				del(H)
			if(new_jumpsuit_icon_state && new_jumpsuit_item_state && new_jumpsuit_name)
				for(var/obj/item/clothing/under/J in contents)
					//world << "DEBUG: YUP! FOUND IT!"
					J.item_state = new_jumpsuit_item_state
					J.icon_state = new_jumpsuit_icon_state
					J.item_color = wash_color
					J.name = new_jumpsuit_name
					J.desc = new_desc
			if(new_glove_icon_state && new_glove_item_state && new_glove_name)
				for(var/obj/item/clothing/gloves/G in contents)
					//world << "DEBUG: YUP! FOUND IT!"
					G.item_state = new_glove_item_state
					G.icon_state = new_glove_icon_state
					G.item_color = wash_color
					G.name = new_glove_name
					G.desc = new_desc
			if(new_shoe_icon_state && new_shoe_name)
				for(var/obj/item/clothing/shoes/S in contents)
					//world << "DEBUG: YUP! FOUND IT!"
					if (istype(S,/obj/item/clothing/shoes/orange))
						var/obj/item/clothing/shoes/orange/L = S
						if (L.chained)
							L.remove_cuffs()
					S.icon_state = new_shoe_icon_state
					S.item_color = wash_color
					S.name = new_shoe_name
					S.desc = new_desc
			if(new_sheet_icon_state && new_sheet_name)
				for(var/obj/item/weapon/bedsheet/B in contents)
					//world << "DEBUG: YUP! FOUND IT!"
					B.icon_state = new_sheet_icon_state
					B.item_color = wash_color
					B.name = new_sheet_name
					B.desc = new_desc
			if(new_softcap_icon_state && new_softcap_name)
				for(var/obj/item/clothing/head/soft/H in contents)
					//world << "DEBUG: YUP! FOUND IT!"
					H.icon_state = new_softcap_icon_state
					H.item_color = wash_color
					H.name = new_softcap_name
					H.desc = new_desc
		del(crayon)
		crayon = null


	if( locate(/mob,contents) )
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	if(!usr.stat || state == 8|7)
		return
	usr.visible_message("[usr] begins to climb out of the [src].", "You begin to climb out of the [src]")
	sleep(20)
	src.go_out(usr)


/obj/machinery/washing_machine/update_icon()
	icon_state = "wm_[state][panel]"

/obj/machinery/washing_machine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	/*if(istype(W,/obj/item/weapon/screwdriver))
		panel = !panel
		user << "\blue you [panel ? "open" : "close"] the [src]'s maintenance panel"*/
	if(istype(W,/obj/item/toy/crayon) ||istype(W,/obj/item/weapon/stamp))
		if( state in list(	1, 3, 6 ) )
			if(!crayon)
				user.drop_item()
				crayon = W
				crayon.loc = src
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/weapon/grab))
		if( (state == 1) && hacked)
			var/obj/item/weapon/grab/G = W
			if(ishuman(G.assailant) && iscorgi(G.affecting)||ishuman(G.affecting))
				usr.visible_message("[usr] begins to stuff [G.affecting] into the [src].", "You begin to stuff [G.affecting] into the [src]")
				sleep(20)
				G.affecting.loc = src
				if(ishuman(G.affecting))
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [G.affecting] ([G.affecting.ckey]) in [src].</font>")
					G.affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in [src] by [usr.name] ([usr.ckey])</font>")
					msg_admin_attack("[user] ([usr.ckey]) placed [G.affecting] ([G.affecting.ckey]) in a [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
				del(G)
				state = 3
		else
			..()
	else if(istype(W,/obj/item/borg/grab))
		if( (state == 1) && hacked)
			var/obj/item/borg/grab/BG = W
			if(ishuman(user) && iscorgi(BG.attack)||ishuman(BG.attack))
				usr.visible_message("[usr] begins to stuff [BG.attack] into the [src].", "You begin to stuff [BG.attack] into the [src]")
				sleep(20)
				BG.attack.loc = src
				if(ishuman(BG.attack))
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [BG.attack] ([BG.attack.ckey]) in [src].</font>")
					BG.attack.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been placed in [src] by [usr.name] ([usr.ckey])</font>")
					msg_admin_attack("[user] ([usr.ckey]) placed [BG.attack] ([BG.attack.ckey]) in a [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
				BG.attack = null
				user.stop_pulling()
				BG.process()
				state = 3

		else
			..()
	else if(istype(W,/obj/item/stack/sheet/hairlesshide) || \
		istype(W,/obj/item/clothing/under) || \
		istype(W,/obj/item/clothing/mask) || \
		istype(W,/obj/item/clothing/head) || \
		istype(W,/obj/item/clothing/gloves) || \
		istype(W,/obj/item/clothing/shoes) || \
		istype(W,/obj/item/clothing/suit) || \
		istype(W,/obj/item/weapon/bedsheet))

		//YES, it's hardcoded... saves a var/can_be_washed for every single clothing item.
		if ( istype(W,/obj/item/clothing/suit/space ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/suit/syndicatefake ) )
			user << "This item does not fit."
			return
//		if ( istype(W,/obj/item/clothing/suit/powered ) )
//			user << "This item does not fit."
//			return
		if ( istype(W,/obj/item/clothing/suit/cyborg_suit ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/suit/bomb_suit ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/suit/armor ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/suit/armor ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/mask/gas ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/mask/cigarette ) )
			user << "This item does not fit."
			return
		if ( istype(W,/obj/item/clothing/head/syndicatefake ) )
			user << "This item does not fit."
			return
//		if ( istype(W,/obj/item/clothing/head/powered ) )
//			user << "This item does not fit."
//			return
		if ( istype(W,/obj/item/clothing/head/helmet ) )
			user << "This item does not fit."
			return

		if(contents.len < 5)
			if ( state in list(1, 3) )
				user.drop_item()
				W.loc = src
				state = 3
			else
				user << "\blue You can't put the item in right now."
		else
			user << "\blue The washing machine is full."
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user as mob)
	if (!ishuman(user))
		usr << "\red You don't have the dexterity to do this!"
		return 1
	if(user && user.loc == src)
		user << "\red You cannot reach the controls from inside."
		return
	else
		switch(state)
			if(1)
				state = 2
			if(2)
				state = 1
				for(var/atom/movable/O in contents)
					O.loc = src.loc
			if(3)
				state = 4
			if(4)
				state = 3
				for(var/atom/movable/O in contents)
					O.loc = src.loc
				crayon = null
				state = 1
			if(5)
				user << "\red The [src] is busy."
			if(6)
				state = 7
			if(7)
				if(gibs_ready)
					gibs_ready = 0
					if(locate(/mob,contents))
						var/mob/M = locate(/mob,contents)
						M.gib()
				for(var/atom/movable/O in contents)
					O.loc = src.loc
				crayon = null
				state = 1


		update_icon()