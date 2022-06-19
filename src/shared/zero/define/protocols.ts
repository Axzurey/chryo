import remoteProtocol from "../signals/remoteProtocol";
import {t} from '@rbxts/t';

const protocols = {
    updateMovement: {
        protocol: new remoteProtocol<(player: Player, cframe: CFrame) => void, () => void>('update_client_cframe', [t.Instance, t.CFrame]),
    },
    equipContext: {
        protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_equip_context', [t.Instance, t.string]),
    },
	reloadStartContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_reload_start_context', [t.Instance, t.string]),
	},
    reloadEndContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_reload_end_context', [t.Instance, t.string]),
	},
    reloadCancelContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_reload_cancel_context', [t.Instance, t.string]),
	},
    fireContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string, cameraCFrame: CFrame) => void, () => void>('item_fire_context', 
        [t.Instance, t.string, t.CFrame]),
	},
	fireMultiContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string, directions: CFrame[]) => void, () => void>('item_fireMulti_context',
		[t.Instance, t.string, t.array(t.CFrame)])
	},
	nextFireModeContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('next_fire_mode_context', 
        [t.Instance, t.string]),
	},
	changeStanceContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string, stance: 1 | 0 | -1) => void, () => void>('change_stance_context', 
        [t.Instance, t.string, t.literal(-1, 0, 1)]),
	},
	clientFlingBasepart: {
		protocol: new remoteProtocol<() => void, (instance: BasePart, position: Vector3, direction: Vector3) => void>('client_fling_basepart_context', 
        [t.Instance, t.Instance, t.Vector3, t.Vector3]),
	},
}

export = protocols;