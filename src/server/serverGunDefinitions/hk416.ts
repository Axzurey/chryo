import serverGun from "server/serverExtended/serverGun";

export default function hk416_server_definition(id: string) {
	let gun = new serverGun(id);

    gun.ammo = 999;
    gun.maxAmmo = 999;
    gun.reserveAmmo = 999;

    return gun;
}