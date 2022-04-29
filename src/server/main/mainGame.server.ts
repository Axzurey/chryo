import { Players } from "@rbxts/services";
import serverItem from "server/serverBase/serverItem";
import serverGun from "server/serverExtended/serverGun"
import environment from "shared/constants/environment"
import { itemTypeIdentifier } from "shared/types/gunwork";
import system from "shared/zero/system";

interface serverDataInterface {
    playerConfiguration: Record<number, {
        currentEquipped: serverGun | undefined
        items: {
            primary: serverGun
        }
    }>
}

let serverData: serverDataInterface = {
    playerConfiguration: {}
};

const dotenv = environment.getSharedEnvironment();

let internalIdentification: {[key: string]: {
    owner?: Player,
    object: serverItem
}} = {}

Players.PlayerAdded.Connect((client) => {
    let mix = {
        items: {
            primary: new serverGun('Gun1'), //ofc, we gonna generate those normally
        },
        currentEquipped: undefined
    }

    mix.items.primary.setUser(client)

    internalIdentification['Gun1'] = {
        owner: client,
        object: mix.items.primary
    };

    serverData.playerConfiguration[client.UserId] = mix
})

system.remote.server.on('equipContext', (player, itemId) => {
    let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        for (const [i, v] of pairs(serverData.playerConfiguration[player.UserId].items)) {
            if (v.serverItemIdentification === itemId) {
                v.equip();
            }
            else {
                v.unequip();
            }
        }
    }
})

system.remote.server.on('reloadStartContext', (player, itemId) => {
	let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).startReload()
            }
        }
    }
})

system.remote.server.on('reloadEndContext', (player, itemId) => {
	let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).finishReload()
            }
        }
    }
})

system.remote.server.on('reloadCancelContext', (player, itemId) => {
	let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).cancelReload()
            }
        }
    }
})

system.remote.server.on('fireContext', (player, itemId, cframe) => {
    print(itemId)
    let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        print("s1")
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            print('s2')
            if (obj.userEquipped) {
                print('s3');
                (obj as serverGun).fire(cframe)
            }
        }
    }
})

system.remote.server.on('updateMovement', (player, newcframe) => {
    
})