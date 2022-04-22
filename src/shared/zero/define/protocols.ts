import remoteProtocol from "../signals/remoteProtocol";

const protocols = {
    updateMovement: {
        protocol: new remoteProtocol<(player: Player, cframe: CFrame) => void, () => void>('player_cframe'),
        verify: () => {
            //function takes args and verifies them using t
        }
    },
    equipItem: {
        protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_equip'),
        verify: () => {
            
        }
    }
}

export = protocols;