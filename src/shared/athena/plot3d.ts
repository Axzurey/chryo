import path from "./path";

const bin = path.createIfMissing('Workspace//plot3d#env', 'Folder');

namespace plot3d {

    let plotId = 0;
    export function plotInWorld(position: Vector3, color: Color3 = new Color3(0, 1, 1)) {

        let p = new Instance("Part");

        p.Shape = Enum.PartType.Ball;
        p.Name = plotId as unknown as string; //it doesn't know number to string conversion happens automatically

        p.CastShadow = false;
        p.CanCollide = false;
        p.CanQuery = false;
        p.CanTouch = false;
        p.Anchored = true;

        p.Size = new Vector3(1, 1, 1);
        p.Material = Enum.Material.Neon;

        p.Color = color;
        p.Position = position;
        p.Parent = bin;

        plotId ++;

        return p;
    }
}

export = plot3d;