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
	}
}

export = protocols;