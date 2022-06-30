import { Debris, Workspace } from "@rbxts/services";

namespace graphRBX {
    export function plotInWorld(point: Vector3, color: Color3 = new Color3(1, 1, 1), length?: number) {
        let p = new Instance("Part");
        p.Anchored = true;
        p.Shape = Enum.PartType.Ball;
        p.Color = color;
        p.Size = new Vector3(.5, .5, .5);
        p.CanCollide = false;
        p.CanQuery = false;
        p.CanTouch = false;
        p.Name = `point@${point}`;
        p.Position = point;
        p.Parent = Workspace;
        if (length) {
            Debris.AddItem(p, length)
        }
    }
}

export = graphRBX;