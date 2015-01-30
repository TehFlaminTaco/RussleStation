/datum/hud/proc/changeling_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')

	changeling_chem_display = new /obj/screen()
	changeling_chem_display.name = "Chemical Storage"
	changeling_chem_display.icon = 'icons/mob/screen1_Midnight.dmi'
	changeling_chem_display.icon_state = "template"
	changeling_chem_display.screen_loc = "14:28,9:15"
	changeling_chem_display.layer = 20

	mymob.client.screen += list(changeling_chem_display)