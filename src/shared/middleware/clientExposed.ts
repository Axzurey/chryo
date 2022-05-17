import actionController from "shared/base/actionController";
import clientConfig from "shared/local/clientConfig";

namespace clientExposed {
    let camera: Camera;
    let baseWalkspeed: number;
    let actionController: actionController;
    let clientConfig: clientConfig;

    export function getCamera() {
        if (!camera) throw `camera has not been set!`
        return camera;
    }

    export function setCamera(_camera: Camera) {
        camera = _camera;
    }

    export function getBaseWalkSpeed() {
        return baseWalkspeed;
    }

    export function setBaseWalkSpeed(speed: number) {
        baseWalkspeed = speed;
    }

    export function getActionController() {
        return actionController;
    }
    
    export function setActionController(_actionController: actionController) {
        actionController = _actionController;
    }

    export function getClientConfig() {
        assert(clientConfig, 'clientConfig has not been set!');
        return clientConfig;
    }

    export function setClientConfig(_clientConfig: clientConfig) {
        clientConfig = _clientConfig;
    }
}

export = clientExposed;