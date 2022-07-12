import drone from "./drone"

type observableModel = Model & {
    focus: Part
}

enum observableType {drone, camera}

export default class observable {
    observableType: observableType = observableType.camera;
    constructor(public id: string, public owner: Player, public model: observableModel) {

    }
    observe(start: boolean) {}
    update() {}
    isADrone(): this is drone {
        return this.observableType === observableType.drone;
    }
    isACamera(): boolean {
        return this.observableType === observableType.camera;
    }
}