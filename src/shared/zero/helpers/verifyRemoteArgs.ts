import {t} from '@rbxts/t'

export default function verifyRemoteArgs(args: unknown[], verify: t.check<any>[]) {
	let i = 0;
	for (let value of verify) {
		let against = args[i];
		if (!value(against)) {
			return false;
		}
		i ++;
	}
	return true;
}