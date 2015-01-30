//vip verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/vip_verbs_default = list(
	/client/proc/de_vip_self
	)
var/list/vip_verbs_vip = list(
	/client/proc/cmd_vip_say,
	/client/proc/de_vip_self)

var/list/vip_verbs_super = list(
	/client/proc/Namepick)

var/list/vip_verbs_transform = list(
	/client/proc/vip_vox,
	/client/proc/vip_vox_ship_tele,
	/client/proc/VIP_Borg_Sprite,
	/client/proc/VIP_AI_Sprite)

/client/proc/add_vip_verbs()
	if(vipholder)
		if(vipholder.rights & V_VIPDEFAULT)		verbs += vip_verbs_default
		if(vipholder.rights & V_VIP)			verbs += vip_verbs_vip
		if(vipholder.rights & V_SUPER)			verbs += vip_verbs_super
		if(vipholder.rights & V_TRANSFORM)		verbs += vip_verbs_transform

/client/proc/remove_vip_verbs()
	verbs.Remove(
		vip_verbs_default,
		vip_verbs_vip,
		vip_verbs_super,
		vip_verbs_transform
		)

/client/proc/de_vip_self()
	set name = "De-vip self"
	set category = "Vip"

	if(vipholder)
		if(alert("Confirm self-de-vip for the round? You can't re-vip yourself without someone promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] de-vip-ed themself.")
			message_admins("[src] de-vip-ed themself.", 1)
			de_vip()
			src << "<span class='interface'>You are now a normal player.</span>"


