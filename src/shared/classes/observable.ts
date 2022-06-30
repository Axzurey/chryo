type observableModel = Model & {
    focus: Part
}

export default class observable {
    constructor(public id: string, public owner: Player, public model: observableModel) {

    }
    observe(start: boolean) {}
    update() {}
}