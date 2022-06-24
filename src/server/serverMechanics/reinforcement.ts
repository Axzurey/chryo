import { TweenService, Workspace } from "@rbxts/services";
import anime from "shared/anime";
import path from "shared/athena/path";
import { newThread } from "shared/athena/utils";
import rocaster from "shared/zero/rocast";

namespace reinforcement {

    const reinforceRange = 8;

    const pathVar = 'ReplicatedStorage//assets//reinforcement';

    const pathObject = path.getInstance(pathVar) as Model;

    export function reinforce(client: Player, cameraCFrame: CFrame) {

        let lookvector = cameraCFrame.LookVector.sub(new Vector3(0, cameraCFrame.LookVector.Y, 0)); //remove the y, it's a bother.

        let caster = new rocaster({
            from: cameraCFrame.Position,
            direction: lookvector,
            maxDistance: reinforceRange,
            ignore: [client.Character as Model],
            ignoreNames: ['HumanoidRootPart'],
            debug: false
        });

        let wallCast = caster.cast({
            canPierce: (result) => {
                return undefined
                /*return {
                    damageMultiplier: 1,
                    weight: 1
                }*/
            }
        });

        if (!wallCast) {
            print('there is no wall!')
            return
        }

        let attr = wallCast.instance.GetAttribute('reinforcable');
        if (!attr) return;

        const selectedWall = wallCast.instance;

        const selectedWallNormal = wallCast.normal;

        const wallPosition = selectedWall.Position;

        const bottomLeft = wallPosition.sub(selectedWall.Size.add(new Vector3(0, 0, -selectedWall.Size.Z * 2)).div(2));

        const backBottomLeft = wallPosition.sub(selectedWall.Size).div(2);

        const animations: (() => void)[] = []

        const i: Instance[] = []
        
        let canceled = false;

        for (let x = 0; x < 4; x ++) {
            let lastposition = bottomLeft.add(new Vector3(x * 2 + 1, 1, 0));
            newThread(() => {
                for (let y = 0; y < 5; y ++) {
                    if (canceled) break;
                    let calculatedPosition = bottomLeft.add(new Vector3(x * 2 + 1, y * 2 + 1, 0));
    
                    let clone = pathObject.Clone();
    
                    clone.SetPrimaryPartCFrame(CFrame.lookAt(lastposition, lastposition.add(selectedWallNormal)));
    
                    const animation = anime.animateModelPosition(clone, calculatedPosition, .4)

                    animations.push(animation.binding.unbind)

                    i.push(clone);
    
                    clone.Parent = Workspace;
    
                    task.wait(.5)
    
                    lastposition = calculatedPosition;
                }
            })
        }

        for (let x = 0; x < 4; x ++) {
            let lastposition = backBottomLeft.add(new Vector3(x * 2 + 1, 1, 0));
            newThread(() => {
                for (let y = 0; y < 5; y ++) {
                    if (canceled) break;
                    let calculatedPosition = backBottomLeft.add(new Vector3(x * 2 + 1, y * 2 + 1, 0));
    
                    let clone = pathObject.Clone();
    
                    clone.SetPrimaryPartCFrame(CFrame.lookAt(lastposition, lastposition.add(selectedWallNormal)));
    
                    const animation = anime.animateModelPosition(clone, calculatedPosition, .4)

                    animations.push(animation.binding.unbind)

                    i.push(clone);
    
                    clone.Parent = Workspace;
    
                    task.wait(.5)
    
                    lastposition = calculatedPosition;
                }
            })
        }

        return {
            cancel: () => {
                canceled = true
                animations.forEach((v) => {
                    v()
                })
                i.forEach((v) => {
                    v.Destroy()
                })
            }
        }
    }
}

export = reinforcement;