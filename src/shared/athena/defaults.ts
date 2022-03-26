import { RunService } from "@rbxts/services";
import paths from "shared/constants/paths";
import path from "./path";

export default abstract class defaults {
    static getRoot() {
        let p = path.getInstance(path.join(paths.script_directory, paths.script_directory_name));
        if (p) {
            return p;
        }
        else {
            if (RunService.IsServer()) {
                p = new Instance("Folder");
                p.Name = paths.script_directory_name;
                p.Parent = path.getInstance(paths.script_directory);
                return p;
            }
            else {
                let t = path.getInstance(paths.script_directory);
                if (!t) throw `path ${paths.script_directory} does not exist in game!`
                return t.WaitForChild(paths.script_directory_name)
            }
        }
    }
}