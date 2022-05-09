namespace positionTracker {
	interface infoStructure {
		ignoreNext: boolean
		position: CFrame
		delta: number
	}

	const playerInfo: Record<number, infoStructure> = {}

	const maximum_distance_per_second = 20;

	export function addPlayer(player: Player) {
		playerInfo[player.UserId] = {
			ignoreNext: true,
			position: new CFrame(),
			delta: 0
		}
	};

	export function removePlayer(player: Player) {
		delete playerInfo[player.UserId]
	};

	export function setPosition(player: Player, cframe: CFrame) {
		let dir = playerInfo[player.UserId];

		let now = tick()

		let delta = dir.delta;
		let lastpos = dir.position;
		let ignorenext = dir.ignoreNext;

		if (ignorenext) {
			dir.ignoreNext = false;
			dir.position = cframe;
			dir.delta = now;
			return true;
		}

		let diff = now - delta;

		let posdiff = lastpos.Position.sub(cframe.Position);

		let diffASecond = posdiff.div(diff).Magnitude;

		if (diffASecond > maximum_distance_per_second) {
			print("too fast!")
			return false;
		}

		dir.delta = now;
		dir.position = cframe;

		return true;
	}
}

export = positionTracker;