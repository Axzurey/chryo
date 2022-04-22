import { Workspace } from "@rbxts/services";
import entity from "./basic/entity";
import space from "./space";

interface rocastParams {
    from: Vector3,
    direction: Vector3,
    ignore: Instance[],
    maxDistance: number
}

interface castResult {
    entity?: entity,
    position: Vector3,
    normal: Vector3,
    material: Enum.Material,
    instance: BasePart
}

interface castParams {
    canPierce: (result: RaycastResult) => {damageMultiplier: number, weight: number} | undefined
}

export default class rocaster {
    constructor(private params: rocastParams) {

    }
    loopCast(from: Vector3, direction: Vector3, distancePassed: number, ignore: Instance[], castParams: castParams): RaycastResult | undefined {
        let i = new RaycastParams()
        i.FilterDescendantsInstances = ignore;

        let result = Workspace.Raycast(from, direction.mul(this.params.maxDistance - distancePassed), i);
        if (result) {
            let distance = (result.Position.sub(from)).Magnitude;

            let r = castParams.canPierce(result);
            if (r) {
                return this.loopCast(result.Position, direction, distance + distancePassed, ignore, castParams);
            }
            else {
                return result;
            }
        }
        return undefined;
    }
    cast(params: castParams): castResult | undefined {
        let result = this.loopCast(this.params.from, this.params.direction, 0, this.params.ignore, params);
        if (result) {
            let entity = space.query.findFirstEntityWithVesselThatContainsInstance(result.Instance);
            return {
                entity: entity,
                instance: result.Instance,
                normal: result.Normal,
                position: result.Position,
                material: result.Material
            }
        }
    }
}