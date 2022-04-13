export default abstract class clientExposed {
    private static camera: Camera;
    private static baseWalkspeed: number;

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
}