import { Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import mathf, { closestPointOnPart } from "shared/athena/mathf";
import { peripherals } from "shared/athena/utils";
import { getActionController, getCamera } from "shared/middleware/clientExposed";
import { moveDirectionFromKeys } from "shared/util/userContext";

namespace rappel {
    const rappelDistance = 5;

    const rappelVelocity = 10;

    const maxHeightDiff = 20;

    const up = new Vector3(0, 1, 0)
    /**
     * RAPPEL STILL GOING ON EVEN AFTER EXITING!
     */

    export function check(ignore: RaycastParams) {
        const controller = getActionController()

        if (controller.rappelling) return;

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

            let topDiff = topSurface.Y - hitPos.Y;
            
            if (topDiff > maxHeightDiff) {
                return true;
            }
            else {
                return false;
            }
        }

        return false;
        
    }
    export function Rappel(ignore: RaycastParams) {

        const controller = getActionController()

        if (controller.rappelling) return;

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

            let starttime = tick()
            
            if (topDiff > maxHeightDiff) {

                controller.rappelling = true;

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

                    let checkDownForGround = Workspace.Raycast(charf.Position, new Vector3(0, halfCharacterHeight * 2, 0), ignore);

                    function exitUp() {
                        r.Disconnect()
                        let origincharcf = character.GetPivot();
                            
                        let start = origincharcf.Position;
                        let endTarget = closestPointOnPart(hit, start.add(new Vector3(0, 1000, 0))).add(
                            cast!.Normal.mul(-4) /**move it 4 studs inwards */
                        ).add(new Vector3(halfCharacterHeight));

                        let middle = mathf.lerpV3(start, endTarget, .75).add(new Vector3(0, 5, 0));

                        let i = 0;
                        let tip = RunService.RenderStepped.Connect((dt) => {
                            i = math.clamp(i + .5 * dt, 0, 1);
                            if (i === 1) {
                                tip.Disconnect();
                                controller.rappelling = false;
                            }
                            let now = mathf.bezierQuadraticV3(i, start, middle, endTarget);
                            character.SetPrimaryPartCFrame(new CFrame(now));
                        })
                    }

                    function exitDown() {
                        r.Disconnect()
                        let origincharcf = character.GetPivot();
                            
                        let start = origincharcf.Position;
                        let endTarget = closestPointOnPart(hit, start).add(
                            cast!.Normal.mul(4) /**move it 4 studs outwards */
                        );

                        let middle = mathf.lerpV3(start, endTarget, .2).add(new Vector3(0, 2, 0));

                        let i = 0;
                        let tip = RunService.RenderStepped.Connect((dt) => {
                            i = math.clamp(i + .5 * dt, 0, 1);
                            if (i === 1) {
                                tip.Disconnect();
                                controller.rappelling = false;
                            }
                            let now = mathf.bezierQuadraticV3(i, start, middle, endTarget);
                            character.SetPrimaryPartCFrame(new CFrame(now));
                        })
                    }
                    let origincharcf = character.GetPivot();

                    let s = origincharcf.Position;

                    let topBlock = closestPointOnPart(hit, s.add(new Vector3(0, 1000, 0))).Y
                    let bottomBlock = closestPointOnPart(hit, s.sub(new Vector3(0, 1000, 0))).Y

                    if (math.abs(topBlock - charf.Position.Y) < 4 && peripherals.isButtonDown(controller.getKey('rappel'))) {
                        //exit up
                        exitUp()
                    }
                    if (math.abs(bottomBlock - charf.Position.Y) < 4 && peripherals.isButtonDown(controller.getKey('rappel'))) {
                        if (tick() - starttime > 1) {
                            exitDown()
                        }
                    }

                    if (!checkDownForGround && !checkObscuring && checkIfStillOnPart && checkIfStillOnPart.Instance === cast!.Instance) {
                        character.SetPrimaryPartCFrame(targetCFrame);
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