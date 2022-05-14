import { UserInputService } from "@rbxts/services";

namespace userContext {
    export function moveDirectionFromKeys() {
        let v = new Vector3();
        if (UserInputService.IsKeyDown(Enum.KeyCode.D)) {
            v = v.add(new Vector3(1, 0, 0))
        }
        if (UserInputService.IsKeyDown(Enum.KeyCode.W)) {
            v = v.add(new Vector3(0, 0, 1))
        }
        if (UserInputService.IsKeyDown(Enum.KeyCode.S)) {
            v = v.add(new Vector3(0, 0, -1))
        }
        if (UserInputService.IsKeyDown(Enum.KeyCode.A)) {
            v = v.add(new Vector3(-1, 0, 0))
        }
        return v;
    }
}

export = userContext;