import serverGun from "./serverClasses/serverGun"
import user from "./serverClasses/user"

declare global {
    interface serverDataInterface {
        playerConfiguration: Record<number, {
            player: Player,
            currentEquipped: serverGun | undefined
            items: {
                primary: serverGun
            },
            currentReinforcement: undefined | {cancel: () => void},
            characterClass: user,
    
            connections: {
                newCharacterConnection: RBXScriptConnection
            }
        }>
    }
}