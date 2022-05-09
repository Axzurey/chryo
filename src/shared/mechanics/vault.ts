import { Players, Workspace } from "@rbxts/services";

namespace vault {
	const vaultDistance = 8;

	const characterHeight = 10;

	const normalUp = new Vector3(0, 1, 0)
	
	export function Vault(ignore: RaycastParams) {
		let character = Players.LocalPlayer.Character!;
	
		let cframe = character.GetPivot();

		let look = cframe.LookVector;

		let pos = cframe.Position;

		let maxL = look.mul(vaultDistance);

		let cast = Workspace.Raycast(pos, maxL, ignore); //to ensure that they are actually looking at an object!

		if (cast) {
			//next check how tall the object is and if it is at a vaultable height!
			let up = Workspace.Raycast(cast.Position, normalUp.mul(characterHeight), ignore); //to ensure that nothing above is obstructing this!
		}
	}
}

export = vault;