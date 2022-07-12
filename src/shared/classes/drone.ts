import { Players, RunService, UserInputService } from "@rbxts/services";
import path from "shared/modules/path";
import { getCamera } from "shared/global/clientExposed";
import system from "shared/entities/system";
import observable from "./observable";
import userContext from "shared/util/userContext";
import velocityGraph from "shared/util/velocitygraph";

type droneType = Model & {
    focus: Part,
}

export default class drone extends observable {
    observationConnection: RBXScriptConnection | undefined = undefined;

    model: droneType;

    currentController: Player | undefined = undefined;

    localVelocity: Vector3 = new Vector3();

    graph = new velocityGraph(3);

    jumpConnection: RBXScriptConnection;

    constructor(id: string, owner: Player, model: Model) {
        super(id, owner, model as droneType)
        this.model = model as droneType;

        this.jumpConnection = UserInputService.InputBegan.Connect((key, gp) => {
            if (gp) return;
            if (key.KeyCode === Enum.KeyCode.Space) {
                system.remote.client.fireServer('jumpDrone', this.id);
            }
        })
    }

    override update() {
        let camera = getCamera();

        if (this.owner === Players.LocalPlayer) {
            system.remote.client.fireServer('updateDroneRotation', this.id, camera.CFrame);
        }

        let v = userContext.moveDirectionFromKeys();

        if (v.Magnitude === 0) {
            this.graph.reset();
        }

        this.localVelocity = v.mul(this.graph.getVelocityNow());
        system.remote.client.fireServer('moveDrone', this.id, this.localVelocity);
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