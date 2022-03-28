import { ReplicatedStorage, RunService } from "@rbxts/services";
import tree, { castTree } from "shared/athena/tree";

namespace environment {
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

    /**
     * 
     * @returns it waits for the server to create the environment and then returns it
     */
    export async function getSharedEnvironment() {
        return new Promise<typeof both>((resolve, reject) => {
            while (!both) {
                task.wait();
            }
            resolve(both);
        });
    }
}

export = environment;