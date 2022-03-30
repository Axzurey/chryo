import { RunService } from "@rbxts/services";

interface rocastParams {
    maxDistance: number,
    originDirection: Vector3,
    originPosition: Vector3,
    mass: number,
    gravityOnObject: number,
    hitscan: boolean,
    velocity: number
}

export default class rocast {
    constructor(private params: rocastParams) {

    }
    cast() {
        let t = 0;
        RunService.Heartbeat.Connect((dt))
    }
}

class cl {
    constructor(public instance: Model) {}
}

namespace classes {
    const classes: cl[] = [];

    const blacklist = [];
    classes.forEach((v) => {
        blacklist.push(v)
    })
}