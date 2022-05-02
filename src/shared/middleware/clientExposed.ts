import actionController from "shared/base/actionController";

export default abstract class clientExposed {
    private static camera: Camera;
    private static baseWalkspeed: number;
    private static actionController: actionController;

    static getCamera() {
        if (!this.camera) throw `camera has not been set!`
        return this.camera;
    }

    static setCamera(camera: Camera) {
        this.camera = camera;
    }

    static getBaseWalkSpeed() {
        return this.baseWalkspeed;
    }

    static setBaseWalkSpeed(speed: number) {
        this.baseWalkspeed = speed;
    }

    static getActionController() {
        return this.actionController;
    }
    
    static setActionController(actionController: actionController) {
        this.actionController = actionController;
    }
}