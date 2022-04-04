import remoteProtocol from "../signals/remoteProtocol";

const protocols = {
    updateMovement: {
        protocol: new remoteProtocol<(player: Player, cookies: number, toes: number) => void, () => void>('player_movement'),
        verify: () => {
            //function takes args and verifies them using t
        }
    }
}

export = protocols;