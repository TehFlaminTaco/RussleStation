//Procedures in this file: Gender reassignment
//////////////////////////////////////////////////////////////////
//					GENDER REASSIGNMENT							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/genderreassignment/
	priority = 2
	can_infect = 1
	blood_level = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if (affected.open < 2)
			return 0
		return target_zone == "groin"
	/*can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone != "groin")
			return 0
		var/datum/organ/external/groin = target.get_organ("groin")
		if (!groin)
			return 0
		if (groin.open < 2)
			return 0
		return 1*/

/datum/surgery_step/genderreassignment/preparation	//This is to distinguish from the appendectomy.
	allowed_tools = list(
	/obj/item/weapon/retractor = 100,	\
	/obj/item/weapon/crowbar = 75, 	\
	/obj/item/weapon/kitchen/utensil/fork = 50
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(target.op_stage.appendix != 1)
			return ..() && target.op_stage.genderreassignment == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to prepare [target]'s genitals for reshaping with \the [tool].", \
		"You start to prepare [target]'s genitals for reshaping with \the [tool]." )
		if(target.gender == FEMALE)
			target.custom_pain("Someone's messing around with your genitals!",1)

	end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] has prepared [target]'s genitals for reshaping with \the [tool].", \
		"\blue You have prepared [target]'s genitals for reshaping with \the [tool]." )
		target.op_stage.genderreassignment = 1

	fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, bruising the tissue inside [target]'s abdomen!", \
		"\red Your hand slips, bruising the tissue inside [target]'s abdomen!" )
		target.apply_damage(10, BRUTE, affected)

/datum/surgery_step/genderreassignment/reshape_genitals
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/wirecutters = 75,	\
	/obj/item/weapon/shard = 25, 		\
	/obj/item/weapon/hatchet = 50	//Just for shits.
	)

	min_duration = 110
	max_duration = 130

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.genderreassignment == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(target.gender == FEMALE)
			user.visible_message("[user] starts to reshape [target]'s genitals to make them look more masculine with \the [tool].", \
			"You start to reshape [target]'s genitals to make them more masculine with \the [tool]." )
			target.custom_pain("They're cutting around your vagina!",1)
		else
			user.visible_message("[user] starts to reshape [target]'s genitals to make them look more feminine with \the [tool].", \
			"You start to reshape [target]'s genitals to make them more feminine with \the [tool]." )
			target.custom_pain("THEY'RE CUTTING OFF YOUR JUNK, MAN!",1)

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(target.gender == FEMALE)
			user.visible_message("\blue [user] has made [target] a man with \the [tool].", \
			"\blue You have made [target] a man with \the [tool].")
			target.gender = MALE
		else
			user.visible_message("\blue [user] has made [target] a woman with \the [tool].", \
			"\blue You have made [target] a woman with \the [tool].")
			target.gender = FEMALE
		target.regenerate_icons()
		target.op_stage.genderreassignment = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, mutilating [target]'s genitals beyond all recognition with \the [tool]!", \
		"\red Your hand slips, mutilating [target]'s genitals beyond all recognition with \the [tool]!" )
		//target.gender = pick(MALE, FEMALE)
		target.apply_damage(20, BRUTE, affected)
		target.regenerate_icons()

/*/datum/surgery_step/genderreassigment/finalize
		allowed_tools = list(
		/obj/item/weapon/FixOVein = 100, \
		/obj/item/weapon/cable_coil = 75
		)

		min_duration = 70
		max_duration = 100

		can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
				return ..() && target.op_stage.genderreassignment == 2

		begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
				user.visible_message("[user] starts to finalize [target]'s gender reassignment with \the [tool].", \
				"You start to finalize [target]'s gender reassignment with \the [tool]." )

		end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
				user.visible_message("\blue [user] has finalized [target]'s gender reassignment with \the [tool].", \
				"\blue You have finalized [target]'s gender reassignment with \the [tool]." )
				target.op_stage.genderreassignment = 0

		fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
				var/datum/organ/external/affected = target.get_organ(target_zone)
				user.visible_message("\red [user]'s hand slips, tearing [target]'s genitalia with \the [tool]!", \
				"\red Your hand slips, tearing [target]'s genitalia with \the [tool]!" )
				affected.createwound(CUT, 10, 1)*/