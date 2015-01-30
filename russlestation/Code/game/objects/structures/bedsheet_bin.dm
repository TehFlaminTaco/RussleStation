/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "bedsheet"
	item_state = "bedsheet"
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 2.0
	item_color = "white"
	flags = BLOCKHAIR | HEADCOVERSMOUTH | FPRINT
	slot_flags = SLOT_HEAD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDEBODY
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS|HEAD


/obj/item/weapon/bedsheet/attack_self(mob/user as mob)
	user.drop_item()
	if(layer == initial(layer))
		layer = 5
	else
		layer = initial(layer)
	add_fingerprint(user)
	return


/obj/item/weapon/bedsheet/blue
	icon_state = "sheetblue"
	item_color = "blue"

/obj/item/weapon/bedsheet/green
	icon_state = "sheetgreen"
	item_color = "green"

/obj/item/weapon/bedsheet/orange
	icon_state = "sheetorange"
	item_color = "orange"

/obj/item/weapon/bedsheet/purple
	icon_state = "sheetpurple"
	item_color = "purple"

/obj/item/weapon/bedsheet/rainbow
	icon_state = "sheetrainbow"
	item_color = "rainbow"

/obj/item/weapon/bedsheet/red
	icon_state = "sheetred"
	item_color = "red"

/obj/item/weapon/bedsheet/yellow
	icon_state = "sheetyellow"
	item_color = "yellow"

/obj/item/weapon/bedsheet/mime
	icon_state = "sheetmime"
	item_color = "mime"

/obj/item/weapon/bedsheet/clown
	icon_state = "sheetclown"
	item_color = "clown"

/obj/item/weapon/bedsheet/captain
	icon_state = "sheetcaptain"
	item_color = "captain"

/obj/item/weapon/bedsheet/rd
	icon_state = "sheetrd"
	item_color = "director"

/obj/item/weapon/bedsheet/medical
	icon_state = "sheetmedical"
	item_color = "medical"

/obj/item/weapon/bedsheet/hos
	icon_state = "sheethos"
	item_color = "hosred"

/obj/item/weapon/bedsheet/hop
	icon_state = "sheethop"
	item_color = "hop"

/obj/item/weapon/bedsheet/ce
	icon_state = "sheetce"
	item_color = "chief"

/obj/item/weapon/bedsheet/brown
	icon_state = "sheetbrown"
	item_color = "brown"
/obj/item/weapon/bedsheet/random
	icon_state = "bedsheet"
	item_color = "white"

/obj/item/weapon/bedsheet/random/New()
	..()
	var/sheetcolor = pick(/obj/item/weapon/bedsheet/brown,/obj/item/weapon/bedsheet/ce,/obj/item/weapon/bedsheet/hop,/obj/item/weapon/bedsheet/hos,/obj/item/weapon/bedsheet/medical,/obj/item/weapon/bedsheet/rd,/obj/item/weapon/bedsheet/yellow,/obj/item/weapon/bedsheet/red,/obj/item/weapon/bedsheet/purple,/obj/item/weapon/bedsheet/green,/obj/item/weapon/bedsheet/blue,/obj/item/weapon/bedsheet)
	new sheetcolor(src.loc)
	del(src)


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-empty"
	amount = 0

/obj/structure/bedsheetbin/New()
	..()
	spawn(1)
		for(var/obj/item/I in src.loc)
			if(I.density || I.anchored || I == src) continue
			if(!istype(I, /obj/item/weapon/bedsheet)) continue
			I.loc = src
			sheets.Add(I)
			amount++
	src.update_icon()


/obj/structure/bedsheetbin/examine()
	usr << desc
	if(amount < 1)
		usr << "There are no bed sheets in the bin."
		return
	if(amount == 1)
		usr << "There is one bed sheet in the bin."
		return
	usr << "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	if(anchored)
		switch(amount)
			if(0)				src.icon_state = "linenbin-empty"
			if(1 to amount / 2)	src.icon_state = "linenbin-half"
			else				src.icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/bedsheet))
		user.drop_item()
		I.loc = src
		sheets.Add(I)
		amount++
		user << "<span class='notice'>You put [I] in [src].</span>"
	else if(amount && !hidden && I.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_item()
		I.loc = src
		hidden = I
		user << "<span class='notice'>You hide [I] among the sheets.</span>"



/obj/structure/bedsheetbin/attack_paw(mob/user as mob)
	return attack_hand(user)


/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		B.loc = user.loc
		user.put_in_hands(B)
		user << "<span class='notice'>You take [B] out of [src].</span>"

		if(hidden)
			hidden.loc = user.loc
			user << "<span class='notice'>[hidden] falls out of [B]!</span>"
			hidden = null
	update_icon()


	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)

		B.loc = loc
		user << "<span class='notice'>You telekinetically remove [B] from [src].</span>"
		update_icon()

		if(hidden)
			hidden.loc = loc
			user << "<span class='notice'>[hidden] falls out of [B]!</span>"
			hidden = null


	add_fingerprint(user)