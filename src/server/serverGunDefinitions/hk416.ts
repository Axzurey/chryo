import user from "server/serverClasses/user";
import serverGun from "server/serverClasses/serverGun";
import { images } from "shared/global/source";

export default function hk416_server_definition(id: string, characterClass: user) {
	let gun = new serverGun(id, characterClass);

    gun.ammo = 999;
    gun.maxAmmo = 999;
    gun.reserveAmmo = 999;

    gun.source.images = {
        'normal': images.bullet_hole_default,
        'glass': images.bullet_hole_glass,
        'metal': images.bullet_hole_default
    }

    return gun;
}