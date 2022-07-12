export default class velocityGraph {
    initialTime: number = tick();
    constructor(public velocityClamp: number = math.huge) {

    }
    reset() {
        this.initialTime = tick();
    }
    getVelocityNow(): number {
        return math.clamp((tick() - this.initialTime) ** 2, 0, this.velocityClamp);
    }
    static getVelocityAtPoint(t: number, velocityClamp: number = math.huge) {
        return math.clamp(t ** 2, 0, velocityClamp);
    }
}