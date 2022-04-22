import {UserInputService, RunService} from '@rbxts/services'

interface comboConfig {
	keys: (Enum.KeyCode | Enum.UserInputType)[]
	timeSpacing?: number
	cancelOnKeyChainBroken?: boolean
	cancelOnChainNotInitiatedAfter?: number
}

interface holdConfig {
	key: Enum.KeyCode | Enum.UserInputType
	cancelOnHoldNotInitiatedAfter?: number
    length: number
}

export enum comboOutcome {
	timeout = 'combo took too long to initialize',
	chainTimeout = 'combo chain took too long',
	success = 'combo was successful',
	chainBroken = 'combo chain was broken',
}

export enum holdOutcome {
    timeout = 'key hold took too long to initialize',
    success = 'key hold was successful',
    liftedEarly = 'key hold was lifted early'
}

export default abstract class key {
	static keyHold(config: holdConfig) {
		return new Promise((resolve, reject) => {
            let target = config.key;
            let started = false;
            let t = tick()
            if (config.cancelOnHoldNotInitiatedAfter) {
                let r = RunService.RenderStepped.Connect(() => {
                    if (started) {
                        r.Disconnect();
                        return;
                    }
                    if (tick() - t >= config.cancelOnHoldNotInitiatedAfter!) {
                        r.Disconnect();
                        c1.Disconnect();
                    }
                })
            }
			let c1 = UserInputService.InputBegan.Connect((input, gp) => {
				if (gp) return;
                started = true;
                if (target.EnumType === Enum.KeyCode && input.KeyCode === target ||
                    target.EnumType === Enum.UserInputType && input.UserInputType === target
                ) 
                {
                    let start = tick();
                    let c2 = UserInputService.InputEnded.Connect((input) => {
                        if (target.EnumType === Enum.KeyCode && input.KeyCode === target ||
                            target.EnumType === Enum.UserInputType && input.UserInputType === target
                        ) {
                            c2.Disconnect();
                            if (tick() - start < config.length) {
                                reject(holdOutcome.liftedEarly)
                            }
                        }
                    })
                    let rs = RunService.RenderStepped.Connect(() => {
                        if (tick() - start > config.length) {
                            c2.Disconnect();
                            rs.Disconnect();
                            resolve(holdOutcome.success);
                        }
                    })
                    c1.Disconnect();
                }
			})
		})
	}
	static keyCombo(config: comboConfig) {
		return new Promise<comboOutcome>((resolve, reject) => {
			let lastcall = tick();
			let currentIndex = 0;
			let step = RunService.RenderStepped.Connect(() => {
				if (config.cancelOnChainNotInitiatedAfter && currentIndex === 0 &&
				 tick() - lastcall > config.cancelOnChainNotInitiatedAfter) {
					connection.Disconnect();
					reject(comboOutcome.timeout);
				}//finish this, make it time out lastcall too 
			})
			let connection = UserInputService.InputBegan.Connect((input, gp) => {
				if (gp) return;
				if (tick() - lastcall < (config.timeSpacing || 1)) {
					let target = config.keys[currentIndex];
					if
					((target.EnumType === Enum.KeyCode && input.KeyCode === target) 
					|| 
					(target.EnumType === Enum.UserInputType && input.UserInputType === target)) {
						lastcall = tick()
						currentIndex ++
						if (currentIndex >= config.keys.size()) {
							connection.Disconnect();
							resolve(comboOutcome.success);
						}
					}
					else if (config.cancelOnKeyChainBroken) {
						reject(comboOutcome.chainBroken)
					}
				}
				else {
					reject(comboOutcome.chainTimeout);
				}
			})
		})
	}
}