/datum/guardian_ability/major/special/onewayroad // a cookie for you if you get the reference
	name = "Absolution"
	desc = "The stand forms an absolute shield around it's user, protecting them from all harm."
	cost = 5

/datum/guardian_ability/major/special/onewayroad/New()
	..()
	START_PROCESSING(SSfastprocess, src)

/datum/guardian_ability/major/special/onewayroad/Destroy()
	..()
	STOP_PROCESSING(SSfastprocess, src)

/datum/guardian_ability/major/special/onewayroad/Manifest()
	update_status()

/datum/guardian_ability/major/special/onewayroad/Recall()
	update_status()

/datum/guardian_ability/major/special/onewayroad/Berserk()
	if(!HAS_TRAIT(guardian, TRAIT_ONEWAYROAD))
		ADD_TRAIT(guardian, TRAIT_ONEWAYROAD, STAND_TRAIT)

/datum/guardian_ability/major/special/onewayroad/process()
	if(!guardian || !guardian.summoner)
		return
	update_status()
	if(isopenturf(guardian.summoner.loc))
		var/turf/open/T = guardian.summoner.loc
		T.air?.parse_gas_string("o2=22;n2=82;TEMP=293.15")
		for(var/obj/effect/particle_effect/smoke/S in T)
			S.visible_message("<span class='danger'>\The [S] is dispersed into a million tiny particles!</span>")
			qdel(S)
		for(var/obj/effect/particle_effect/foam/F in T)
			F.visible_message("<span class='danger'>\The [F] is dispersed into a million tiny particles!</span>")
			qdel(F)

/datum/guardian_ability/major/special/onewayroad/proc/update_status()
	if(!guardian || !guardian.summoner)
		return
	if(guardian.loc == guardian.summoner)
		if(HAS_TRAIT(guardian.summoner, TRAIT_ONEWAYROAD))
			REMOVE_TRAIT(guardian.summoner, TRAIT_ONEWAYROAD, STAND_TRAIT)
		if(HAS_TRAIT(guardian.summoner, TRAIT_NOBREATH))
			REMOVE_TRAIT(guardian.summoner, TRAIT_NOBREATH, STAND_TRAIT)
	else
		ADD_TRAIT(guardian.summoner, TRAIT_ONEWAYROAD, STAND_TRAIT)
		ADD_TRAIT(guardian.summoner, TRAIT_NOBREATH, STAND_TRAIT) // this kinda simulates the "Absolution filters out harmful gases around the user" thing better than constantly parsing gas strings

// STUFF

/obj/item/melee_attack_chain(mob/user, atom/target, params)
	if(!tool_attack_chain(user, target) && pre_attack(target, user, params))
		var/resolved
		if(HAS_TRAIT(target, TRAIT_ONEWAYROAD))
			resolved = user.attackby(src, user, params) // you just hit yourself
		else
			resolved = target.attackby(src, user, params)
		if(!resolved && target && !QDELETED(src))
			afterattack(target, user, 1, params)

/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		var/atom/movable/oldfirer = P.firer
		P.firer = src
		P.original = oldfirer
		P.setAngle(Get_Angle(src, oldfirer))
		visible_message("<span class='danger'>The air around [src] diverts \the [P] back towards [oldfirer]!</span>")
		return BULLET_ACT_FORCE_PIERCE
	return ..()

/mob/living/simple_animal/hostile/guardian/bullet_act(obj/item/projectile/P)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		var/atom/movable/oldfirer = P.firer
		P.firer = src
		P.original = oldfirer
		P.setAngle(Get_Angle(src, oldfirer))
		visible_message("<span class='danger'>The air around [src] diverts \the [P] back towards [oldfirer]!</span>")
		return BULLET_ACT_FORCE_PIERCE
	return ..()

/mob/living/simple_animal/hostile/guardian/ex_act(severity, target, origin)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		visible_message("<span class='danger'>The air around [src] diverts the explosion!</span>")
		return
	return ..()

/mob/living/carbon/human/ex_act(severity, target, origin)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		visible_message("<span class='danger'>The air around [src] diverts the explosion!</span>")
		return
	return ..()

/mob/living/carbon/human/contents_explosion(severity, target)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		return
	return ..()

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		visible_message("<span class='danger'>The air around [src] diverts \the [AM] back towards [throwingdatum.thrower]!</span>")
		AM.throw_at(throwingdatum.thrower, throwingdatum.maxrange * 2, throwingdatum.speed * 2, src, TRUE)
		return
	return ..()

/mob/living/simple_animal/hostile/guardian/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(HAS_TRAIT(src, TRAIT_ONEWAYROAD))
		visible_message("<span class='danger'>The air around [src] diverts \the [AM] back towards [throwingdatum.thrower]!</span>")
		AM.throw_at(throwingdatum.thrower, throwingdatum.maxrange * 2, throwingdatum.speed * 2, src, TRUE)
		return
	return ..()
