/obj/structure/Coffin_Despenser
	name = "Coffin Dispenser"
	icon = 'icons/obj/coffindespenser.dmi'
	desc = "A coffin dispenser."
	icon_state = "cd0"
	anchored = 1
	density = 0
	var/numofcoffins = 0


/obj/structure/Coffin_Despenser/New()
	numofcoffins = 6
	icon_state = "cdf"
	update_icon()



/obj/structure/Coffin_Despenser/attack_hand(mob/user as mob)
	dispensecoffin()
/obj/structure/Coffin_Despenser/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return src.attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return



/obj/structure/Coffin_Despenser/proc/dispensecoffin()
	for(var/obj/structure/closet/coffin/C in src.loc.contents)
		usr << "\red The dispenser is blocked."
		return
	if(numofcoffins == 0)
		usr << "\red The dispenser flashes a red light, signifying that it is out of wood."
		return
	if(numofcoffins >= 1)
		var/obj/structure/closet/coffin/D = new /obj/structure/closet/coffin(src.loc)
		D.opened = 1
		D.density = 0
		D.update_icon()
		numofcoffins--
		update_icon()
		return

/obj/structure/Coffin_Despenser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/D = W
		if(src.numofcoffins >=6)
			user << "\red The [src] is full."
			return
		if(D.amount >=5)
			D.use(5)
			numofcoffins++
			update_icon()
			user << "\blue You add enough wood for one coffin to the dispenser."
		else
			user << "\red Not enough wood. Five planks required for one coffin."
			return

/obj/structure/Coffin_Despenser/update_icon()
	icon_state ="cd[numofcoffins]"



/obj/structure/Rollerbed_Despenser
	name = "Rollerbed Dispenser"
	icon = 'icons/obj/coffindespenser.dmi'
	desc = "A rollerbed dispenser."
	icon_state = "rbd0"
	anchored = 1
	density = 0
	var/numofRB = 0


/obj/structure/Rollerbed_Despenser/New()
	numofRB = 8
	icon_state = "rbd8"
	update_icon()



/obj/structure/Rollerbed_Despenser/attack_hand(mob/user as mob)
	dispenseRB()

/obj/structure/Rollerbed_Despenser/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return src.attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return

/obj/structure/Rollerbed_Despenser/proc/dispenseRB()
	for(var/obj/structure/stool/bed/roller/C in src.loc.contents)
		usr << "\red The dispenser is blocked."
		return
	if(numofRB == 0)
		usr << "\red The dispenser flashes a red light, signifying that it is out of rollerbeds."
		return
	if(numofRB >= 1)
		new /obj/structure/stool/bed/roller(src.loc)
		numofRB--
		update_icon()
		return

/obj/structure/Rollerbed_Despenser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/roller))
		var/obj/item/roller/D = W
		if(src.numofRB >=8)
			user << "\red The [src] is full."
			return
		else
			del(D)
			numofRB++
			update_icon()
			user << "\blue You add a rollerbed to the dispenser."
	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/D = W
		if(src.numofRB >=8)
			user << "\red The [src] is full."
			return
		if(D.amount >=5)
			D.use(5)
			numofRB++
			update_icon()
			user << "\blue You add enough metal for one rollerbed to the dispenser."
		else
			user << "\red Not enough metal. Five sheets of metal required for one rollerbed."
			return

/obj/structure/Rollerbed_Despenser/update_icon()
	icon_state ="rbd[numofRB]"

/obj/structure/Wheelchair_Despenser
	name = "Wheelchair Dispenser"
	icon = 'icons/obj/coffindespenser.dmi'
	desc = "A wheelchair dispenser."
	icon_state = "wcd0"
	anchored = 1
	density = 0
	var/numofWC = 0


/obj/structure/Wheelchair_Despenser/New()
	numofWC = 6
	icon_state = "wcd6"
	update_icon()



/obj/structure/Wheelchair_Despenser/attack_hand(mob/user as mob)
	dispenseWC()

/obj/structure/Wheelchair_Despenser/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return src.attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return

/obj/structure/Wheelchair_Despenser/proc/dispenseWC()
	for(var/obj/structure/stool/bed/chair/wheelchair/C in src.loc.contents)
		usr << "\red The dispenser is blocked."
		return
	if(numofWC == 0)
		usr << "\red The dispenser flashes a red light, signifying that it is out of wheelchairs."
		return
	if(numofWC >= 1)
		new /obj/structure/stool/bed/chair/wheelchair(src.loc)
		numofWC--
		update_icon()
		return

/obj/structure/Wheelchair_Despenser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/wheelchair))
		var/obj/item/wheelchair/D = W
		if(src.numofWC >=6)
			user << "\red The [src] is full."
			return
		else
			del(D)
			numofWC++
			update_icon()
			user << "\blue You add a wheelchair to the dispenser."
	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/D = W
		if(src.numofWC >=6)
			user << "\red The [src] is full."
			return
		if(D.amount >=5)
			D.use(5)
			numofWC++
			update_icon()
			user << "\blue You add enough metal for one wheelchair to the dispenser."
		else
			user << "\red Not enough metal. Five sheets of metal required for one wheelchair."
			return

/obj/structure/Wheelchair_Despenser/update_icon()
	icon_state ="wcd[numofWC]"

/obj/structure/Bodybag_Despenser
	name = "Bodybag Dispenser"
	icon = 'icons/obj/coffindespenser.dmi'
	desc = "A bodybag dispenser."
	icon_state = "bbd0"
	anchored = 1
	density = 0
	var/numofBB = 0


/obj/structure/Bodybag_Despenser/New()
	numofBB = 8
	icon_state = "bbd8"
	update_icon()



/obj/structure/Bodybag_Despenser/attack_hand(mob/user as mob)
	dispenseBB()



/obj/structure/Bodybag_Despenser/proc/dispenseBB()
	if(numofBB == 0)
		usr << "\red The dispenser flashes a red light, signifying that it is out of bodybags."
		return
	if(numofBB >= 1)
		new /obj/item/bodybag(src.loc)
		numofBB--
		update_icon()
		return

/obj/structure/Bodybag_Despenser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/bodybag))
		var/obj/item/bodybag/D = W
		if(src.numofBB >=8)
			user << "\red The [src] is full."
			return
		else
			del(D)
			numofBB++
			update_icon()
			user << "\blue You add a bodybag to the dispenser."
	if(istype(W, /obj/item/stack/sheet/mineral/plastic))
		var/obj/item/stack/sheet/mineral/plastic/D = W
		if(src.numofBB >=8)
			user << "\red The [src] is full."
			return
		if(D.amount >=5)
			D.use(5)
			numofBB++
			update_icon()
			user << "\blue You add enough plastic for one bodybag to the dispenser."
		else
			user << "\red Not enough plastic. Five sheets of plastic required for one coffin."
			return

/obj/structure/Bodybag_Despenser/update_icon()
	icon_state ="bbd[numofBB]"