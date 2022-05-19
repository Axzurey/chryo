import { Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import mathf from "shared/athena/mathf";
import { peripherals } from "shared/athena/utils";
import { getActionController, getCamera } from "shared/middleware/clientExposed";
import { moveDirectionFromKeys } from "shared/util/userContext";

namespace rappel {
    const rappelDistance = 5;

    const rappelVelocity = 10;

    const up = new Vector3(0, 1, 0)
    
    export function Rappel(ignore: RaycastParams) {

        const controller = getActionController()

        controller.rappelling = true;

        let character = Players.LocalPlayer.Character!;
	
		let cframe = character.GetPivot();

		let camera = getCamera();

		let [_, bounding] = character.GetBoundingBox();

		let look = cframe.LookVector;

		let pos = cframe.Position;

		let maxL = look.mul(rappelDistance);

		let cast = Workspace.Raycast(pos, maxL, ignore); //to ensure that they are actually looking at an object!

        if (cast) {
            let topSurface = mathf.closestPointOnPart(cast.Instance, cast.Position.add(up.mul(1000)));

            const hitPos = cast.Position;

            const hit = cast.Instance;

            let topDiff = topSurface.Y - hitPos.Y;
            
            if (topDiff > 20) {
                let r = RunService.RenderStepped.Connect((dt) => {

                    let direction = moveDirectionFromKeys();
                    direction = new Vector3(direction.X, direction.Z, 0);

                    let charf = character.GetPrimaryPartCFrame()

                    let ign = new RaycastParams();
                    ign.FilterType = Enum.RaycastFilterType.Whitelist;
                    ign.FilterDescendantsInstances = [hit];

                    let result = Workspace.Raycast(charf.Position, cast!.Normal.mul(-5), ign);

                    if (!result) {
                        print("no result!!!!!");
                        return;
                    }

                    if (result.Normal !== cast!.Normal) {
                        print("incorrect normal! wrong face!");
                        return;
                    }

                    let constructed = CFrame.lookAt(result.Position, result.Position.add(result.Normal));

                    let ry = constructed.VectorToObjectSpace(direction);
                    let tochar = character.GetPrimaryPartCFrame().VectorToObjectSpace(ry);

                    let nextp = tochar.mul(rappelVelocity * dt)

                    let targetCFrame = character.GetPrimaryPartCFrame()
                        .mul(new CFrame(nextp));

                    //make sure targetcframe lies on the surface of the part!

                    let checkIfStillOnPart = Workspace.Raycast(targetCFrame.Position, cast!.Normal.mul(-5), ignore);
                    
                    let changeDirection = CFrame.lookAt(charf.Position, targetCFrame.Position).LookVector;

                    let changeMagnitude = (charf.Position.sub(targetCFrame.Position)).Magnitude;

                    let checkObscuring = Workspace.Raycast(charf.Position, changeDirection.mul(changeMagnitude), ignore);

                    let halfCharacterHeight = bounding.Y / 2

                    let checkDownForGround = Workspace.Raycast(charf.Position, new Vector3(0, halfCharacterHeight, 0), ignore);

                    if (!checkDownForGround && !checkObscuring && checkIfStillOnPart && checkIfStillOnPart.Instance === cast!.Instance) {
                        character.SetPrimaryPartCFrame(targetCFrame);
                    }
                    else {
                        let topBlock = hit.Position.add(hit.Size.div(2)).Y
                        if (checkDownForGround && peripherals.isButtonDown(controller.getKey('rappel'))) {
                            //exit down
                        }
                        else if (math.abs(topBlock - charf.Position.Y) < 2) {
                            //exit up
                        } 
                        print("they will not be on the wall after this move!")
                    }
                    
                });
            }
            else {
                print('too small to rappel on!')
            }
        }
        else {
            print('nothing to rappel on!')
        }
    }
}

export = rappel;