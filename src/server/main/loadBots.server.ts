import { Workspace } from "@rbxts/services";
import human from "shared/entities/entityClasses/human";
import space from "shared/entities/space";

let bots = Workspace.WaitForChild('bots').GetChildren() as Model[];

bots.forEach((v) => {
    let entity = space.life.create(human);
    entity.vessel = v
    entity.health = 100;
})