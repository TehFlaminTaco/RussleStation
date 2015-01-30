


/obj/machinery/cashex
	name = "Cash Exchange"
	desc = "Used to Exchange Cash or Put cash into an account."
	icon = 'icons/obj/computer.dmi'
	icon_state = "guest"
	req_one_access = list(access_hop, access_captain, access_bank)
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/obj/item/weapon/card/id/held_card
	var/obj/item/weapon/card/id/held_card2
	var/temp = null
	var/amountofcash = 0
	var/access_level = 0
	var/cash = null

/obj/machinery/cashex/New()
	..()

/obj/machinery/cashex/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/cashex/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/cashex/attack_hand(var/mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	user.set_machine(src)
	var/dat
	if (access_level == 0)
		dat += "<h3>Cash Exchange Console</h3><BR>"
		dat += "Confirm identity: <a href='?src=\ref[src];insert_card=1'>[held_card ? held_card : "-----"]</a><br>"
		dat += "Target identity: <a href='?src=\ref[src];insert_card2=1'>[held_card2 ? held_card2 : "-----"]</a><br>"
		if(amountofcash == 0)
			dat+= "No Cash Inserted"
		else
			dat += "Current Inserted Cash Amount:[amountofcash]<BR>"
	else
		if(access_level == 1)
			dat += "<h3>Cash Exchange Console</h3><BR>"
			dat += "Confirm identity: <a href='?src=\ref[src];insert_card=1'>[held_card ? held_card : "-----"]</a><br>"
			dat += "Target identity: <a href='?src=\ref[src];insert_card2=1'>[held_card2 ? held_card2 : "-----"]</a><br>"
			if(amountofcash == 0)
				dat+= "No Cash Inserted"
			else
				dat += "Current Inserted Cash Amount:[amountofcash]<BR>"
				dat += "<A href='?src=\ref[src];withdraw=1'>Withdraw 1c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=5'>Withdraw 5c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=10'>Withdraw 10c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=20'>Withdraw 20c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=50'>Withdraw 50c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=100'>Withdraw 100c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=200'>Withdraw 200c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=500'>Withdraw 500c</A><BR>"
				dat += "<A href='?src=\ref[src];withdraw=1000'>Withdraw 1000c</A><BR>"
				dat += "<BR>"
				dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='withdrawal'>"
				dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Move funds to Electronic Credit Chip'><br>"
				dat += "</form>"
				if(held_card2)
					dat += "Name on Electronic Credit Chip:[held_card2.registered_name]<BR>"
				if(held_card && !held_card2)
					dat += "Name on Electronic Credit Chip:[held_card.registered_name]<BR>"

	user << browse(dat, "window=computer;size=425x450")
	onclose(user, "computer")
	return

/obj/machinery/cashex/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if (href_list["withdraw"])
			var/amount = max(text2num(href_list["withdraw"]),0)
			if(amount <= amountofcash)
				spawn_money(amount,src.loc)
				amountofcash -= amount
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
			else
				usr << "\red not enough inserted cash"
		if(href_list["choice"])
			switch(href_list["choice"])
				if("withdrawal")
					var/amount = max(text2num(href_list["funds_amount"]),0)
					if(amount <= 0)
						alert("That is not a valid amount.")
					else if(amountofcash && amount > 0)
						if(amount <= amountofcash)
							playsound(src, 'sound/machines/chime.ogg', 50, 1)

							//remove the money
							amountofcash -= amount
							spawn_ewallet(amount,src.loc)
						else
							usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
		if(href_list["insert_card"])
			if(held_card)
				held_card.loc = src.loc

				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(held_card)
				held_card = null
				access_level = 0

			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					var/obj/item/weapon/card/id/C = I
					usr.drop_item()
					C.loc = src
					held_card = C

					if(access_hop in C.access || access_captain in C.access)
						access_level = 1
					else if(access_bank in C.access)
						access_level = 1
		if(href_list["insert_card2"])
			if(held_card2)
				held_card2.loc = src.loc

				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(held_card2)
				held_card2 = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					var/obj/item/weapon/card/id/C = I
					usr.drop_item()
					C.loc = src
					held_card2 = C
		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/cashex/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/card))
		var/obj/item/weapon/card/id/idcard = O
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard

			if(access_hop in idcard.access || access_captain in idcard.access)
				access_level = 1
			else if(access_bank in idcard.access)
				access_level = 1
		else if(held_card && !held_card2)
			usr.drop_item()
			idcard.loc = src
			held_card2 = idcard
		src.attack_hand(user)
	else if(istype(O,/obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = O
		amountofcash += C.worth
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		user << "<span class='info'>You insert [C] into [src].</span>"
		del(C)
		src.attack_hand(user)

	else if(istype(O,/obj/item/weapon/coin))
		var/obj/item/weapon/coin/D = O
		if(D.credits <= 0)
			user <<"<span class='info'>[D] has no value.</span>"
			return
		else
			amountofcash += D:credits
			var/coinsound = pick(\
			'sound/items/coin_drop_1.ogg',\
			'sound/items/coin_drop_2.ogg',\
			'sound/items/coin_drop_3.ogg')
			playsound(loc, coinsound, 50, 1)
			user << "<span class='info'>You insert [D] into [src].</span>"
			del(D)
			src.attack_hand(user)

	else
		..()

/obj/machinery/cashex/proc/spawn_ewallet(var/sum, loc)
	var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
	E.worth = sum
	if(held_card2)
		E.owner_name = held_card2.registered_name
	else
		E.owner_name = held_card.registered_name