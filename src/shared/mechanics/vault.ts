import { Players, RunService, Workspace } from "@rbxts/services";
import { interpolate } from "shared/athena/interpolations";
import mathf from "shared/athena/mathf";
import { plotInWorld } from "shared/athena/plot3d";
import { getActionController, getCamera } from "shared/middleware/clientExposed";

namespace vault {
	const vaultDistance = 4;

	const characterHeight = 10;

	const normalUp = new Vector3(0, 1, 0);

	const inset = 2;
	
	export function Vault(ignore: RaycastParams) {
		let character = Players.LocalPlayer.Character!;
	
		let cframe = character.GetPivot();

		let camera = getCamera();

		let [_, bounding] = character.GetBoundingBox();

		let look = cframe.LookVector;

		let pos = cframe.Position;

		let maxL = look.mul(vaultDistance);

		let cast = Workspace.Raycast(pos, maxL, ignore); //to ensure that they are actually looking at an object!

		const controller = getActionController()

		if (cast) {
			//next check how tall the object is and if it is at a vaultable height!
			ignore.FilterDescendantsInstances.push(cast.Instance);

			controller.vaulting = true;

			let distance = (pos.sub(cast.Position)).Magnitude;

			let top = mathf.closestPointOnPart(cast.Instance, cast.Position.add(new Vector3(0, 100, 0)));

			let up = Workspace.Raycast(top, normalUp.mul(characterHeight), ignore); //to ensure that nothing above is obstructing this!

			if (up) {print('too small a gap to vault!'); return;};

			let changed: Map<BasePart, boolean> = new Map()

			character.GetChildren().forEach((v) => {
				if (!v.IsA('BasePart')) return;

				changed.set(v, v.CanCollide);
				v.CanCollide = false;
			})

			let p0 = pos;
			let p2 = top.add(look.mul(inset + distance)).add(new Vector3(0, bounding.Y / 2 + 1, 0));
			let p1 = mathf.lerpV3(p0, p2, .25).add(new Vector3(0, 2, 0));

			let t = 0;

			controller.actionMap.crouch(controller.start);

			let c = RunService.RenderStepped.Connect((dt) => {

				t = math.clamp(t + 2 * dt, 0, 1);
				if (t === 1) {
					c.Disconnect();

					changed.forEach((v, k) => {
						k['CanCollide'] = v;
					})

					controller.vaulting = false;

					controller.actionMap.crouch(controller.start);
					task.wait(1)

					return;
				}

				let z = interpolate(t, 0, 1, 'quadInOut');
				let bez = mathf.bezierQuadraticV3(z, p0, p1, p2);
				
				let p = character.GetPivot()
				character.SetPrimaryPartCFrame(CFrame.lookAt(bez, new Vector3()));
			});
		}
		else {
			print('no cast!')
		}
	}
}

export = vault;