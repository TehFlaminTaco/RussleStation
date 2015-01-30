/datum/hud/proc/ninja_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')
	var/internalicon
	if(mymob.internal)
		internalicon = mymob.internals.icon_state
	var/vamp = 0
	var/chang = 0
	if(mymob.hud_used.vampire_blood_display)
		vamp = 1
	if(mymob.hud_used.changeling_chem_display)
		chang = 1
	mymob.hud_used.human_hud('icons/mob/screen1_NinjaHUD.dmi',"#ffffff",255)
	if(vamp)
		mymob.hud_used.vampire_hud()
	if(chang)
		mymob.hud_used.changeling_hud()
	if(mymob.internal)
		mymob.internals.icon_state = internalicon
	ninja_cell_display = new /obj/screen()
	ninja_cell_display.name = "Energy Charge"
	ninja_cell_display.icon = 'icons/mob/screen1_Midnight.dmi'
	ninja_cell_display.icon_state = "template"
	ninja_cell_display.screen_loc = "14:28,9:15"
	ninja_cell_display.layer = 20

	mymob.client.screen += list(ninja_cell_display)
	mymob.regenerate_icons()