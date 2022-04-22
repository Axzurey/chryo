import serverGun from "server/serverExtended/serverGun"
import environment from "shared/constants/environment"
import protocols from "shared/zero/define/protocols";
import system from "shared/zero/system";

interface serverDataInterface {
    playerConfiguration: Record<number, {
        currentEquipped: serverGun | undefined
    }>
}

let serverData: serverDataInterface = {
    playerConfiguration: {}
};

const env = environment.getSharedEnvironment();

system.remote.server.on('updateMovement', () => {
    
})