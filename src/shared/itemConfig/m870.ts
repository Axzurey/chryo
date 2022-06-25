import { tableUtils } from "shared/athena/utils";
import { fireMode, reloadType } from "shared/types/gunwork";

const m870_config = {
    firerate: {
        burst2: 0,
        auto: 0,
        burst3: 0,
        burst4: 0,
        shotgun: 75,
        semi: 0
    },
    adsLength: .5,
    ammo: 9999,
    maxAmmo: 9999,
    reserveAmmo: 9999,
    togglableFireModes: [fireMode.shotgun],
    reloadSpeed: 1.5,
    recoilRegroupTime: 1.5,
    spreadHipfirePenalty: 1.1,
    spreadMovementHipfirePenalty: 1.2,
    spreadDelta: 1.15,
    spreadPopTime: 1.5,
    spreadUpPerShot: .25,
    maxAllowedSpread: 35,
    recoilPattern: tableUtils.toMap([
        new NumberRange(0, 90),
    ], [
        [new Vector3(.4, .5, -.4 * 5), new Vector3(.8, .8, -.6 * 5)],
    ]),
    reloadType: reloadType.shell,
    unaimAfterShot: true,
    shellPath: 'ReplicatedStorage//gunAddons//blue_shotgun_shell'
}

export = m870_config;