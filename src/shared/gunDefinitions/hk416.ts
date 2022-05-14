import { tableUtils } from "shared/athena/utils";
import gun from "shared/extended/gun";
import { fireMode } from "shared/types/gunwork";

export default function hk416_definition(id: string) {
    let g = new gun(id, 'ReplicatedStorage//guns//hk416&class=Model', {
        sight: {
            name: 'holographic',
            path: 'ReplicatedStorage//sights//holographic&class=Model',
            zOffset: .13
        }
    }, {
        idle: 'rbxassetid://9335189959'
    });

    g.firerate = {
        burst2: 600,
        auto: 500,
        burst3: 600,
        burst4: 600,
        shotgun: 1000,
        semi: 800
    }

	g.maxAmmo = 9999;
	g.ammo = 9999;
	g.reserveAmmo = 120

    g.togglableFireModes = [fireMode.auto, fireMode.semi]

    g.reloadSpeed = 1.5;

    g.recoilRegroupTime = 1.5;

    g.spreadHipfirePenalty = 1.1;

    g.spreadMovementHipfirePenalty = 1.2;

    g.spreadDelta = 1.15;

    g.spreadPopTime = 1.5;

    g.spreadUpPerShot = .25;

    g.maxAllowedSpread = 35;

	g.recoilPattern = tableUtils.toMap([
		new NumberRange(0, 10),
        new NumberRange(10, 20),
        new NumberRange(20, 31)
	], [
		[new Vector3(.2, .3, .2), new Vector3(.7, 1, .2)],
        [new Vector3(.2, .7, .3), new Vector3(.6, .8, .3)],
        [new Vector3(.7, .9, .2), new Vector3(.5, .5, .4)]
	])

    return g;
}