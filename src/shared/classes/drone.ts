import { Players, RunService } from "@rbxts/services";
import path from "shared/modules/path";
import { getCamera } from "shared/global/clientExposed";
import system from "shared/entities/system";
import observable from "./observable";
import userContext from "shared/util/userContext";

type droneType = Model & {
    focus: Part,
}

export default class drone extends observable {
    observationConnection: RBXScriptConnection | undefined = undefined;

    model: droneType

    currentController: Player | undefined = undefined;

    constructor(id: string, owner: Player, model: Model) {
        super(id, owner, model as droneType)
        this.model = model as droneType;
    }

    override update() {
        let camera = getCamera();
        if (this.owner === Players.LocalPlayer) {
            system.remote.client.fireServer('updateDroneRotation', this.id, camera.CFrame);
        }
        let v = userContext.moveDirectionFromKeys();
        this.move(v)
    }

    move(direction: Vector3) {
        system.remote.client.fireServer('moveDrone', this.id, direction)
    }

    override observe(start: boolean) {
        system.remote.client.fireServer('observeCamera', this.id, start)
        if (this.observationConnection) {
            this.observationConnection.Disconnect();
        }
        if (start) {
            let camera = getCamera()

            this.observationConnection = RunService.RenderStepped.Connect((dt) => {
                camera.CFrame = this.model.focus.CFrame;
            })
        }
    }
}