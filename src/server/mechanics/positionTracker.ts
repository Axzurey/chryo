namespace positionTracker {
	interface infoStructure {
		ignoreNext: boolean
		position: Vector3
	}
	const playerInfo: Record<number, infoStructure> = {}

	function addPlayer(player: Player) {
		playerInfo[player.UserId] = {
			ignoreNext: true,
			position: new Vector3()
		}
	}

	function removePlayer(player: Player) {
		delete playerInfo[player.UserId]
	}
}

export = positionTracker;