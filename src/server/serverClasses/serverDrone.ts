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
    update(v: Vector3) {
        print(v)
        let avy = this.model.PrimaryPart!.AssemblyLinearVelocity.Y;
        if (math.abs(avy) > .1) return;
        this.model.PrimaryPart!.AssemblyLinearVelocity = new Vector3(v.X, 0, v.Z);
    }
    jump() {
        this.model.PrimaryPart!.ApplyImpulse(new Vector3(0, 10, 0));
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