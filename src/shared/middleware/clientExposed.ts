export default abstract class clientExposed {
    private static camera: Camera;

    static getCamera() {
        if (!this.camera) throw `camera has not been set!`
        return this.camera;
    }

    static setCamera(camera: Camera) {
        this.camera = camera;
    }
}