//these are probably broken
/obj/machinery/floodframe
	name = "Emergency Floodlight Frame"
	icon = 'floodlight.dmi'
	icon_state = "floodframe"
	density = 1
	var/lights = 0
	var/obj/item/weapon/cell/cell = null
	var/unlocked = 1
	var/open = 1
	var/ready = 0

/obj/machinery/floodframe/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/cell))
		if(lights != 3)
			user << "\red You must add the light bulbs first!"
		else
			user.drop_item()
			W.loc = src
			user << "\blue You add a cell to the frame"
			user.drop_item()
			W.loc = src
			cell = W
			icon_state = "floodob00"
			ready = 1
			return
	if(istype(W,/obj/item/weapon/light))
		if(lights == 0)
			user << "\blue You add a light to the frame"
			lights++
			del(W)
			icon_state = "floodframe1"
			return
		if(lights == 1)
			user << "\blue You add another light to the frame"
			lights++
			del(W)
			icon_state = "floodframe2"
			return
		if(lights == 2)
			user << "\blue You add the last light to the frame"
			lights ++
			del(W)
			icon_state = "floodo00"
			return
		if(lights == 3)
			user << "\red You cannot add any more lights all you need now is a cell"
			return
	if (istype(W, /obj/item/weapon/crowbar))
		if(ready)
			if(unlocked)
				if(open)
					open = 0
					overlays = null
					user << "\blue You crowbar the battery panel in place."
					icon_state = "flood00"
				else
					if(unlocked)
						open = 1
						user << "\blue You remove the battery panel."
						icon_state = "floodob00"
		else
			user << "\red You need to add all the parts first"
	if(istype(W,/obj/item/weapon/screwdriver))
		if(!open)
			if(unlocked)
				unlocked = 0
				user << "\blue You screw the battery panel in place."
				var/obj/machinery/floodlight/F = new /obj/machinery/floodlight(src.loc)
				var/obj/item/weapon/cell/D = src.cell
				D.loc = F
				F.cell = D
				del(src)
			else
				unlocked = 1
				user << "You unscrew the battery panel."
		else
			user << "\red You need to use a crowbar to put the battery panel in place."


/obj/machinery/floodframe/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.updateicon()

		src.cell = null
		user << "You remove the power cell"
		icon_state = "floodo00"
		return
/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/weapon/cell/cell = null
	var/use = 5
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 999		//can't remember what the maxed out value is

/obj/machinery/floodlight/New()
	src.cell = new /obj/item/weapon/cell
	..()

/obj/machinery/floodlight/proc/updateicon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(on)
		cell.charge -= use
		if(cell.charge <= 0)
			on = 0
			updateicon()
			SetLuminosity(0)
			src.visible_message("<span class='warning'>[src] shuts down due to lack of power!</span>")
			return

/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
			else
				cell.loc = loc

		cell.add_fingerprint(user)
		cell.updateicon()

		src.cell = null
		user << "You remove the power cell"
		updateicon()
		return

	if(on)
		on = 0
		user << "\blue You turn off the light"
		SetLuminosity(0)
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		user << "\blue You turn on the light"
		SetLuminosity(brightness_on)

	updateicon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (!open)
			if(unlocked)
				unlocked = 0
				user << "You screw the battery panel in place."
			else
				unlocked = 1
				user << "You unscrew the battery panel."

	if (istype(W, /obj/item/weapon/crowbar))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				user << "You crowbar the battery panel in place."
			else
				if(unlocked)
					open = 1
					user << "You remove the battery panel."

	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				user << "There is a power cell already installed."
			else
				user.drop_item()
				W.loc = src
				cell = W
				user << "You insert the power cell."
	updateicon()
