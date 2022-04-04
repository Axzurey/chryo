import { ReplicatedStorage, RunService } from "@rbxts/services";
import tree, { castTree } from "shared/athena/tree";

namespace environment {
    /**
     * 
     * @returns it waits for the server to create the environment and then returns it
     */
     export function getSharedEnvironment() {
        while (!both) {
            task.wait();
        }
        return both;
    }

    let bothType = {
        Remotes: {
            $className: 'Folder',
            $properties: {
                Name: 'Remotes'
            }
        }
    } as const;
    export const both = RunService.IsServer()? tree.createTree(tree.createFolder('sharedEnvironment', ReplicatedStorage), bothType) :
        ReplicatedStorage.WaitForChild('sharedEnvironment') as castTree<Folder, typeof bothType>;
}

export = environment;