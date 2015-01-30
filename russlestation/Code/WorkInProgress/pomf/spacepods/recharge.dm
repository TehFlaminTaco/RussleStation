/turf/simulated/floor/SP_recharge_floor
	name = "Space Pod Recharge Station"
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	var/obj/machinery/SP_recharge_port/recharge_port
	var/obj/machinery/computer/SP_power_console/recharge_console
	var/obj/spacepod/recharging_SP = null

	Entered(var/obj/spacepod/SP)
		. = ..()
		if(istype(SP))
			SP.occupant << "<b>Initializing power control devices.</b>"
			if(SP.passenger)
				SP.passenger <<  "<b>Initializing power control devices.</b>"
			init_devices()
			if(recharge_console && recharge_port)
				recharging_SP = SP
				recharge_console.SP_in(SP)
				return
			else if(!recharge_console)
				SP.occupant << "<font color='red'>Control console not found. Terminating.</font>"
				if(SP.passenger)
					SP.passenger << "<font color='red'>Control console not found. Terminating.</font>"
			else if(!recharge_port)
				SP.occupant << "<font color='red'>Power port not found. Terminating.</font>"
				if(SP.passenger)
					SP.passenger << "<font color='red'>Power port not found. Terminating.</font>"
		return

	Exited(atom)
		. = ..()
		if(atom == recharging_SP)
			recharging_SP = null
			if(recharge_console)
				recharge_console.SP_out()
		return

	proc/init_devices()
		recharge_console = locate() in range(1,src)
		recharge_port = locate(/obj/machinery/SP_recharge_port, get_step(src, SOUTH))
		if(recharge_console)
			recharge_console.recharge_floor = src
			if(recharge_port)
				recharge_console.recharge_port = recharge_port
		if(recharge_port)
			recharge_port.recharge_floor = src
			if(recharge_console)
				recharge_port.recharge_console = recharge_console
		return


/obj/machinery/SP_recharge_port
	name = "Space Pod Power Port"
	density = 1
	anchored = 1
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_port"
	var/turf/simulated/floor/SP_recharge_floor/recharge_floor
	var/obj/machinery/computer/SP_power_console/recharge_console
	var/datum/global_iterator/SP_recharger/pr_recharger

	New()
		..()
		pr_recharger = new /datum/global_iterator/SP_recharger(null,0)
		return

	proc/start_charge(var/obj/spacepod/SP)
		if(stat&(NOPOWER|BROKEN))
			SP.occupant << "<font color='red'>Power port not responding. Terminating.</font>"
			if(SP.passenger)
				SP.passenger << "<font color='red'>Power port not responding. Terminating.</font>"
			return 0
		else
			if(SP.battery)
				SP.occupant << "Now charging..."
				if(SP.passenger)
					SP.passenger << "<font color='red'>Power port not responding. Terminating.</font>"
				pr_recharger.start(list(src,SP))
				return 1
			else
				return 0

	proc/stop_charge()
		if(recharge_console && !recharge_console.stat)
			recharge_console.icon_state = initial(recharge_console.icon_state)
		pr_recharger.stop()
		return

	proc/active()
		if(pr_recharger.active())
			return 1
		else
			return 0

	power_change()
		if(powered())
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				stat |= NOPOWER
				pr_recharger.stop()
		return

	proc/set_voltage(new_voltage)
		if(new_voltage && isnum(new_voltage))
			pr_recharger.max_charge = new_voltage
			return 1
		else
			return 0


/datum/global_iterator/SP_recharger
	delay = 20
	var/max_charge = 45
	check_for_null = 0 //since port.stop_charge() must be called. The checks are made in process()

	process(var/obj/machinery/SP_recharge_port/port, var/obj/spacepod/SP)
		if(!port)
			return 0
		if(SP && SP in port.recharge_floor)
			if(!SP.battery)	return
			var/delta = min(max_charge, SP.battery.maxcharge - SP.battery.charge)
			if(delta>0)
				SP.give_power(delta)
				port.use_power(delta*150)
			else
				SP.occupant << "<font color='blue'><b>Fully charged.</b></font>"
				if(SP.passenger)
					SP.passenger << "<font color='blue'><b>Fully charged.</b></font>"
				port.stop_charge()
		else
			port.stop_charge()
		return




/obj/machinery/computer/SP_power_console
	name = "Space Pod Power Control Console"
	density = 1
	anchored = 1
	icon = 'icons/obj/computer.dmi'
	icon_state = "recharge_comp"
	circuit = "/obj/item/weapon/circuitboard/SP_power_console"
	var/autostart = 1
	var/voltage = 45
	var/turf/simulated/floor/SP_recharge_floor/recharge_floor
	var/obj/machinery/SP_recharge_port/recharge_port

	proc/SP_in(var/obj/spacepod/SP)
		if(stat&(NOPOWER|BROKEN))
			SP.occupant << "<font color='red'>Control console not responding. Terminating...</font>"
			if(SP.passenger)
				SP.passenger << "<font color='red'>Control console not responding. Terminating...</font>"
			return
		if(recharge_port && autostart)
			var/answer = recharge_port.start_charge(SP)
			if(answer)
				recharge_port.set_voltage(voltage)
				src.icon_state = initial(src.icon_state)+"_on"
		return

	proc/SP_out()
		if(recharge_port)
			recharge_port.stop_charge()
		return


	power_change()
		if(stat & BROKEN)
			icon_state = initial(icon_state)+"_broken"
			if(recharge_port)
				recharge_port.stop_charge()
		else if(powered())
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				icon_state = initial(icon_state)+"_nopower"
				stat |= NOPOWER
				if(recharge_port)
					recharge_port.stop_charge()

	set_broken()
		icon_state = initial(icon_state)+"_broken"
		stat |= BROKEN
		if(recharge_port)
			recharge_port.stop_charge()

	attack_hand(mob/user as mob)
		if(..()) return
		var/output = "<html><head><title>[src.name]</title></head><body>"
		if(!recharge_floor)
			output += "<font color='red'>Space Pod Recharge Station not initialized.</font><br>"
		else
			output += {"<b>Space Pod Recharge Station Data:</b><div style='margin-left: 15px;'>
							<b>Space Pod: </b>[recharge_floor.recharging_SP||"None"]<br>"}
			if(recharge_floor.recharging_SP)
				var/cell_charge = recharge_floor.recharging_SP.get_charge()
				output += "<b>Cell charge: </b>[isnull(cell_charge)?"No powercell found":"[recharge_floor.recharging_SP.battery.charge]/[recharge_floor.recharging_SP.battery.maxcharge]"]<br>"
				output += "<b>Hull status: </b>[recharge_floor.recharging_SP.health]/[initial(recharge_floor.recharging_SP.health)]<br>"
			output += "</div>"
		if(!recharge_port)
			output += "<font color='red'>Space Pod Power Port not initialized.</font><br>"
		else
			output += "<b>Space Pod Power Port Status: </b>[recharge_port.active()?"Now charging":"On hold"]<br>"

		/*
		output += {"<hr>
						<b>Settings:</b>
						<div style='margin-left: 15px;'>
						<b>Start sequence on succesful init: </b><a href='?src=\ref[src];autostart=1'>[autostart?"On":"Off"]</a><br>
						<b>Recharge Port Voltage: </b><a href='?src=\ref[src];voltage=30'>Low</a> - <a href='?src=\ref[src];voltage=45'>Medium</a> - <a href='?src=\ref[src];voltage=60'>High</a><br>
						</div>"}
		*/

		output += "</ body></html>"
		user << browse(output, "window=space_pod_console")
		onclose(user, "space_pod_console")
		return


	Topic(href, href_list)
		if(href_list["autostart"])
			autostart = !autostart
		if(href_list["voltage"])
			voltage = text2num(href_list["voltage"])
			if(recharge_port)
				recharge_port.set_voltage(voltage)
		updateUsrDialog()
		return