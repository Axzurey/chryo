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
    instance: BasePart,
    subHits: Omit<castResult, 'subHits'>[]
}

interface castParams {
    canPierce: (result: RaycastResult) => {damageMultiplier: number, weight: number} | undefined | boolean
}

export default class rocaster {
    constructor(private params: rocastParams) {

    }
    loopCast(
        from: Vector3, 
        direction: Vector3, 
        distancePassed: number, 
        ignore: Instance[], 
        castParams: castParams, 
        subHits: Omit<castResult, 'subHits'>[]
        ): [RaycastResult, Omit<castResult, 'subHits'>[]] | undefined {
        let i = new RaycastParams()
        i.FilterDescendantsInstances = ignore;

        let result = Workspace.Raycast(from, direction.mul(this.params.maxDistance - distancePassed), i);
        if (result) {
            let distance = (result.Position.sub(from)).Magnitude;

            if (this.params.ignoreNames.indexOf(result.Instance.Name) !== -1) {
                ignore.push(result.Instance);
                return this.loopCast(from, direction, distancePassed, ignore, castParams, subHits);
            }

            let r = castParams.canPierce(result);
            if (this.params.debug) {
                system.poly.drawLine(from, result.Position)
            }
            if (r) {
                ignore.push(result.Instance)
                subHits.push({
                    instance: result.Instance,
                    normal: result.Normal,
                    position: result.Position,
                    material: result.Material,
                })
                return this.loopCast(result.Position, direction, distance + distancePassed, ignore, castParams, subHits);
            }
            else {
                return [result, subHits];
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
        let result = this.loopCast(this.params.from, this.params.direction, 0, this.params.ignore, params, []);
        if (result) {
            return {
                instance: result[0].Instance,
                normal: result[0].Normal,
                position: result[0].Position,
                material: result[0].Material,
                subHits: result[1]
            }
        }
    }
}