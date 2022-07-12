import { HttpService, Players } from "@rbxts/services";
import positionTracker from "server/serverMechanics/positionTracker";
import serverItem from "server/serverBase/serverItem";
import serverGun from "server/serverClasses/serverGun"
import hk416_server_definition from "server/serverGunDefinitions/hk416";
import environment from "shared/constants/environment"
import { itemTypeIdentifier } from "shared/gunwork";
import system from "shared/entities/system";
import m870_server_definition from "server/serverGunDefinitions/m870";
import space from "shared/entities/space";
import user, { characterType } from "server/serverClasses/user";
import reinforcement from "server/serverMechanics/reinforcement";
import serverDrone from "server/serverClasses/serverDrone";

let serverData: serverDataInterface = {
    playerConfiguration: {}
};

const dotenv = environment.getSharedEnvironment();

let internalIdentification: {[key: string]: {
    owner?: Player,
    object: serverItem
}} = {}

let internalDrones: {[key: string]: {
    object: serverDrone
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
            primary: m870_server_definition('Gun1', characterClass),
            secondary: hk416_server_definition('Gun2', characterClass),
        },
        currentReinforcement: undefined,

        player: client,

        currentEquipped: undefined,
        characterClass: characterClass,
        
        connections: {
            newCharacterConnection: newCharacterConnection
        }
    }

    mix.items.primary.setUser(client)

    mix.items.secondary.setUser(client)

    internalIdentification['Gun1'] = {
        owner: client,
        object: mix.items.primary
    };

    internalIdentification['Gun2'] = {
        owner: client,
        object: mix.items.secondary
    }

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

system.remote.server.on('reloadFeedSingleContext', (player, itemId) => {
    let fromMap = internalIdentification[itemId]
    if (!fromMap) {
        //handle this somehow. it should never happen in the first place unless the client is being a meanie and sending dumb stuff
    }
    if (fromMap.owner && fromMap.owner === player) {
        let obj = fromMap.object;
        if (obj.typeIdentifier === itemTypeIdentifier.gun) {
            if (obj.userEquipped) {
                (obj as serverGun).feedSingle()
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
    let lr = serverData.playerConfiguration[player.UserId]
    if (lr.currentReinforcement) return;
    let r = reinforcement.reinforce(player, cam)
    lr.currentReinforcement = r
})

system.remote.server.on('cancelReinforcement', (player) => {
    let r = serverData.playerConfiguration[player.UserId].currentReinforcement;
    if (r) {
        r.cancel()
    }
    serverData.playerConfiguration[player.UserId].currentReinforcement = undefined;
})

system.remote.server.on('throwDrone', (player) => {
    let id = HttpService.GenerateGUID()
    let drone = new serverDrone(id, player, serverData, player.Character!.GetPrimaryPartCFrame().Position);
    internalDrones[id] = {object: drone};

    system.remote.server.fireClient('throwDrone', player, id, player, drone.model);
})

system.remote.server.on('observeCamera', (player, id, view) => {
    let d = internalDrones[id]
    if (!d) return;
    view ? d.object.addToQueue(player) : d.object.removeFromQueue(player);
})

system.remote.server.on('moveDrone', (player, id, dir) => {
    let d = internalDrones[id]
    if (!d) return;
    d.object.update(dir)
})

system.remote.server.on('jumpDrone', (player, id) => {
    let d = internalDrones[id]
    if (!d) return;
    d.object.jump()
})