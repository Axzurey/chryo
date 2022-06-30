import { Workspace } from "@rbxts/services";
import mathf from "shared/modules/mathf";
import { newThread } from "shared/modules/utils";
import { ignoreInstances } from "shared/entities/space";

namespace explosion {
    interface damageInfo {
        max: number,
        current: number
    }

    const damaged: Map<Instance, damageInfo> = new Map();

    export function explosionRange(centerPoint: Vector3) {
        let explosionFidelity = 20 * 1; //should be a good amount...
        let directions = mathf.pointsOnSphere(explosionFidelity);

        let ignore = new RaycastParams();
        ignore.FilterDescendantsInstances = [...ignoreInstances];

        let toCSG: Map<BasePart, BasePart[]> = new Map()

        directions.forEach((direction) => {
            
            newThread(() => {
                let result = Workspace.Raycast(centerPoint, direction.mul(100), ignore);

                if (result) {
                    let position = result.Position;
                    let hit = result.Instance;

                    let distance = (position.sub(centerPoint)).Magnitude;

                    let damage = 100

                    let mapped = damaged.get(hit);
                    if (mapped) {
                        mapped.current += damage
                        damaged.set(hit, mapped)
                    }
                    else {
                        mapped = {
                            max: 100,
                            current: damage
                        }
                        damaged.set(hit, mapped)
                    };
                    let p = new Instance("Part");
                    p.Color = new Color3(1, 0, 1)
                    p.Size = new Vector3(1, 1, 1)
                    p.Shape = Enum.PartType.Ball;
                    p.Anchored = true;
                    p.Position = position;
                    p.CanCollide = false;
                    p.CanQuery = false;

                    p.Parent = Workspace;
                    //maybe not use csg for everything unless u wanna crash
                    if (mapped.current >= mapped.max) {
                        toCSG.set(hit, toCSG.get(hit)? [...toCSG.get(hit) as BasePart[], p]: [p])
                    }
                }
            })
        })

        toCSG.forEach((v, k) => {
            let n = k.SubtractAsync(v);
            k.Destroy();
            n.Parent = Workspace;
            v.forEach((v) => {
                v.Destroy()
            })
        })
    }
    export function focusedExplosion(at: Vector3, direction: Vector3, length: number = 1) {
        
    }
}

export = explosion;