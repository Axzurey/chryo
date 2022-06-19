import { Workspace } from "@rbxts/services";
import entity from "./basic/entity";
import space from "./space";
import system from "./system";

interface rocastParams {
    from: Vector3,
    direction: Vector3,
    ignore: Instance[],
    maxDistance: number,
    ignoreNames: string[],
    debug: boolean
}

export interface castResult {
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

            if (this.params.ignoreNames.indexOf(result.Instance.Name) !== -1) {
                ignore.push(result.Instance);
                return this.loopCast(from, direction, distancePassed, ignore, castParams);
            }

            let r = castParams.canPierce(result);
            if (this.params.debug) {
                system.poly.drawLine(from, result.Position)
            }
            if (r) {
                ignore.push(result.Instance)
                return this.loopCast(result.Position, direction, distance + distancePassed, ignore, castParams);
            }
            else {
                return result;
            }
        }
        else {
            if (this.params.debug) {
                system.poly.drawLine(from, direction.mul(this.params.maxDistance - distancePassed))
            }
        }
        return undefined;
    }
    cast(params: castParams): castResult | undefined {
        let result = this.loopCast(this.params.from, this.params.direction, 0, this.params.ignore, params);
        if (result) {
            return {
                instance: result.Instance,
                normal: result.Normal,
                position: result.Position,
                material: result.Material
            }
        }
    }
}