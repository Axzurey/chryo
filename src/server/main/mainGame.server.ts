import { Players } from "@rbxts/services";
import positionTracker from "server/serverMechanics/positionTracker";
import serverItem from "server/serverBase/serverItem";
import serverGun from "server/serverExtended/serverGun"
import hk416_server_definition from "server/serverGunDefinitions/hk416";
import environment from "shared/constants/environment"
import { itemTypeIdentifier } from "shared/types/gunwork";
import system from "shared/zero/system";
import m870_server_definition from "server/serverGunDefinitions/m870";
import space from "shared/zero/space";
import user, { characterType } from "server/serverClasses/user";
import reinforcement from "server/serverMechanics/reinforcement";

interface serverDataInterface {
    playerConfiguration: Record<number, {
        currentEquipped: serverGun | undefined
        items: {
            primary: serverGun
        },

        characterClass: user,

        connections: {
            newCharacterConnection: RBXScriptConnection
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
    positionTracker.addPlayer(client);

    const characterClass = space.life.create(user)

    characterClass.setClient(client)

    let character = client.Character || client.CharacterAdded.Wait()[0]

    characterClass.setCharacter(character as characterType)

    const newCharacterConnection = client.CharacterAdded.Connect((character) => {
        characterClass.setCharacter(character as characterType)
    })

    let mix: serverDataInterface['playerConfiguration'][number] = {
        items: {
            primary: m870_server_definition('Gun1', characterClass), //ofc, we gonna generate those normally
            //TODO: ^PUT THE CHARACTERCLASS INSIDE HERE AND USE IT AS VERIFICATION
        },
        currentEquipped: undefined,
        characterClass: characterClass,
        
        connections: {
            newCharacterConnection: newCharacterConnection
        }
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
    if (!fromMap) return
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
    if (!fromMap) return
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
    if (!fromMap) return
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
    let fromMap = internalIdentification[itemId]
    if (!fromMap) return
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).fire(cframe)
            }
        }
    }
})

system.remote.server.on('fireMultiContext', (player, itemId, cframes) => {
    let fromMap = internalIdentification[itemId]
    if (!fromMap) return
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).fireMulti(cframes)
            }
        }
    }
})

system.remote.server.on('updateMovement', (player, newcframe) => {
    let result = positionTracker.setPosition(player, newcframe);
})

system.remote.server.on('startReinforcement', (player, cam) => {
    reinforcement.reinforce(player, cam)
})