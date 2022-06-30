import { Workspace } from "@rbxts/services";
import path from "shared/modules/path";

type droneType = Model & {
    focus: Part,
}

export default class serverDrone {
    model: droneType

    cameraQueue: Player[] = [];

    internalAngle = new CFrame();

    constructor(public id: string, public owner: Player, private serverDataPointer: serverDataInterface, position: Vector3) {
        let model = path.getInstance('ReplicatedStorage//assets//drone&Model')!;
        model = model.Clone();
        this.model = model as droneType;

        this.model.SetPrimaryPartCFrame(new CFrame(position))

        this.model.Parent = Workspace;
    }
    getFirstAliveMemberFromQueue(): Player | undefined {
        for (const [_, v] of pairs(this.cameraQueue)) {
            if (this.serverDataPointer.playerConfiguration[v.UserId].characterClass.alive()) {
                return v; 
            }
        }
    }
    getController(): Player | undefined {
        let firstalivemember = this.getFirstAliveMemberFromQueue()
        return this.cameraQueue.indexOf(this.owner) !== -1 && this.serverDataPointer.playerConfiguration[this.owner.UserId].characterClass.alive() 
        ? this.owner : (firstalivemember ? firstalivemember: this.cameraQueue[0]);
    }
    update(dir: Vector3) {
        this.model.PrimaryPart!.ApplyImpulse(dir) //goes exponentially faster!
    }
    addToQueue(player: Player) {
        if (this.cameraQueue.indexOf(player) === -1) {
            this.cameraQueue.push(player)
        }
    }   
    removeFromQueue(player: Player) {
        let index = this.cameraQueue.indexOf(player)
        if (index !== -1) {
            this.cameraQueue.remove(index)
        }
    }
}