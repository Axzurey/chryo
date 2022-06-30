import { Workspace } from "@rbxts/services"
import { newThread } from "shared/modules/utils"

namespace breach {
    export function shotgun(pos: Vector3, dir: Vector3) {
        let p = new Instance("Part")
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.Transparency = 1
        p.CFrame = CFrame.lookAt(pos, dir)
        p.Size = new Vector3(3, 3, 2)
        p.Parent = Workspace

        return p
    }

    let existingImpacts: BasePart[] = [];

    let originalMap: Map<BasePart, BasePart> = new Map()

    export function bulk(parts: BasePart[]) {
        let tod: BasePart[] = [];

        parts.forEach((v) => {
            let gett = Workspace.GetPartBoundsInBox(v.CFrame, v.Size) as BasePart[]

            gett.forEach((hit) => {
                if (hit.IsA('MeshPart')) return;
                if (hit.Name === 'Baseplate') return;

                if (tod.indexOf(hit) !== -1) return;

                tod.push(hit)
            })
            let c = v.Clone()
            c.Parent = v.Parent
            existingImpacts.push(c)
        });

        tod.forEach((hit) => {
            newThread(() => {
                let original = originalMap.get(hit);

                if (!original) {
                    let pz = hit.Clone()

                    let c = hit.SubtractAsync(parts, Enum.CollisionFidelity.PreciseConvexDecomposition)

                    originalMap.set(c, pz)

                    c.Name = hit.Name
                    c.Position = hit.Position
                    let p = hit.Parent

                    hit.Destroy()

                    c.Parent = p
                }
                else {

                    let c = original.SubtractAsync(existingImpacts, Enum.CollisionFidelity.PreciseConvexDecomposition);

                    c.Name = hit.Name
                    c.Position = hit.Position

                    let p = hit.Parent

                    hit.Destroy()

                    c.Parent = p
                }
            })
        })
    }
}

export = breach