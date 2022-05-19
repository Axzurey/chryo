import { tableUtils } from "shared/athena/utils";
import { fireMode } from "shared/types/gunwork";

const hk416_config = {
    firerate: {
        burst2: 600,
        auto: 500,
        burst3: 600,
        burst4: 600,
        shotgun: 1000,
        semi: 800
    },
    adsLength: .5,
    ammo: 9999,
    maxAmmo: 9999,
    reserveAmmo: 9999,
    togglableFireModes: [fireMode.auto, fireMode.semi],
    reloadSpeed: 1.5,
    recoilRegroupTime: 1.5,
    spreadHipfirePenalty: 1.1,
    spreadMovementHipfirePenalty: 1.2,
    spreadDelta: 1.15,
    spreadPopTime: 1.5,
    spreadUpPerShot: .25,
    maxAllowedSpread: 35,
    recoilPattern: tableUtils.toMap([
        new NumberRange(0, 10),
        new NumberRange(10, 20),
        new NumberRange(20, 31)
    ], [
        [new Vector3(.2, .3, .2), new Vector3(.7, 1, .2)],
        [new Vector3(.2, .7, .3), new Vector3(.6, .8, .3)],
        [new Vector3(.7, .9, .2), new Vector3(.5, .5, .4)]
    ])
}

export = hk416_config;