import { RunService, Workspace } from "@rbxts/services";
import physicsObject from "shared/phantom/physicsObject";

let i = new Instance("Part");
i.Anchored = true;
i.Color = Color3.fromRGB(255, 0, 255)
i.Material = Enum.Material.Neon;
i.Name = 'hola'
i.Parent = Workspace;
i.CanCollide = false;

let obj = new physicsObject(i, new Vector3(0, 30, 0))

RunService.Stepped.Connect((_, dt) => {
    obj.update(dt)
})

while (true) {
    task.wait(2)

    obj.applyImpulse(new Vector3(
        math.random() * 1000 * (math.random() > .5 ? 1 : -1),
        math.random() * 1000, 
        math.random() * 1000 * (math.random() > .5 ? 1 : -1))
    )
}