import { Workspace } from "@rbxts/services";
import human from "shared/zero/entities/human";
import space from "shared/zero/space";

let bots = Workspace.WaitForChild('bots').GetChildren() as Model[];

bots.forEach((v) => {
    let entity = space.life.create(v, human);
    entity.health = 100;
})