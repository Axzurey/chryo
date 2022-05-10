import { Players, RunService, Workspace } from "@rbxts/services";
import mathf from "shared/athena/mathf";
import { getCamera } from "shared/middleware/clientExposed";

namespace vault {
	const vaultDistance = 4;

	const characterHeight = 10;

	const normalUp = new Vector3(0, 1, 0)
	
	export function Vault(ignore: RaycastParams) {
		let character = Players.LocalPlayer.Character!;
	
		let cframe = character.GetPivot();

		let camera = getCamera();

		let [_, bounding] = character.GetBoundingBox();

		let look = cframe.LookVector;

		let pos = cframe.Position;

		let maxL = look.mul(vaultDistance);

		let cast = Workspace.Raycast(pos, maxL, ignore); //to ensure that they are actually looking at an object!

		if (cast) {
			//next check how tall the object is and if it is at a vaultable height!
			ignore.FilterDescendantsInstances.push(cast.Instance);

			let top = mathf.closestPointOnPart(cast.Instance, cast.Position.add(new Vector3(0, 100, 0)));
			let up = Workspace.Raycast(top, normalUp.mul(characterHeight), ignore); //to ensure that nothing above is obstructing this!
			if (up) {print('too small a gap to vault!'); return;};

			character.GetChildren().forEach((v) => {
				if (!v.IsA('BasePart')) return;
				v.Anchored = true;
				v.CanCollide = false;
				
			})

			let p0 = pos;
			let p2 = top.add(camera.CFrame.LookVector.mul(5)).add(new Vector3(0, bounding.Y / 2, 0));
			let p1 = mathf.lerpV3(p0, p2, .75).add(new Vector3(0, 2, 0));

			let t = 0;

			let c = RunService.RenderStepped.Connect((dt) => {
				t = math.clamp(t + 2 * dt, 0, 1);
				if (t === 1) {
					c.Disconnect();
					character.GetChildren().forEach((v) => {
						if (!v.IsA('BasePart')) return;
						v.Anchored = false;
						v.CanCollide = true;
					})
					return;
				}

				let bez = mathf.bezierQuadraticV3(t, p0, p1, p2);
				character.SetPrimaryPartCFrame(CFrame.lookAt(bez, character.GetPivot().Position));
			});
		}
		else {
			print('no cast!')
		}
	}
}

export = vault;