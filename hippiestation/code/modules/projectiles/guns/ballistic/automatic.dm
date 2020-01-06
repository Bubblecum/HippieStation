/obj/item/gun/ballistic/automatic/l6_saw/attack_self(mob/living/user)
	if(!internal_magazine && magazine)
		if(!cover_open)
			to_chat(user, "<span class='warning'>[src]'s cover is closed! Open it before trying to remove the magazine!</span>")
			return
		eject_magazine(user)
		return
	if (recent_rack > world.time)
		return
	recent_rack = world.time + rack_delay
	rack(user)

	// Improvised semi-automatic carbine //
/obj/item/gun/ballistic/automatic/improvcarbine
	name = "Improvised Semi-automatic carbine"
	desc = "A haphazardly constructed firearm favored by revolutionaries and greytiders alike. Uses 45 acp ammo"
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "improvcarbine-8"
	item_state = "moistnugget"
	mag_type = /obj/item/ammo_box/magazine/m10mm/rifle
	fire_delay = 10
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/improvcarbine/update_icon()//hippie edit -- bring back old gun icons
	if(magazine)
		icon_state = "[initial(icon_state)][magazine.ammo_count() ? "" : "-e"]"
	else
		icon_state = "improvcarbine[chambered ? "" : "-e"]"

obj/item/gun/ballistic/automatic/improvcarbine/rack(mob/user = null)
    if (bolt_locked == FALSE)
        to_chat(user, "<span class='notice'>You open the bolt of \the [src]</span>")
        playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
        process_chamber(FALSE, FALSE, FALSE)
        bolt_locked = TRUE
        update_icon()
        return
    drop_bolt(user)

obj/item/gun/ballistic/automatic/improvcarbine/can_shoot()
    if (bolt_locked)
        return FALSE
    . = ..()

/obj/item/gun/ballistic/automatic/improvcarbine/examine(mob/user)
    ..()
    to_chat(user, "The bolt is [bolt_locked ? "open" : "closed"].")

