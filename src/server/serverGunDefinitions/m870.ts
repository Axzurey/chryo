import serverGun from "server/serverExtended/serverGun";
import itemConfig, { itemClean } from "shared/global/itemConfig";
import { images } from "shared/global/source";

const gunIdentifier = 'm870';

export default function m870_server_definition(id: string) {
	let gun = new serverGun(id);

    for (let [p, v] of pairs(itemClean(itemConfig.getProperties(gunIdentifier)))) {
        if (gun[p as keyof typeof gun] !== undefined) {
            gun[p as keyof typeof gun] = v as never;
        }
    }

    gun.source.images = {
        'normal': images.bullet_hole_default,
        'glass': images.bullet_hole_glass,
        'metal': images.bullet_hole_default
    }

    return gun;
}