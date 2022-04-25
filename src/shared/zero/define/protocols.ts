import remoteProtocol from "../signals/remoteProtocol";
import {t} from '@rbxts/t';

const protocols = {
    updateMovement: {
        protocol: new remoteProtocol<(player: Player, cframe: CFrame) => void, () => void>('update_client_cframe', [t.Instance, t.CFrame]),
    },
    equipContext: {
        protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_equip_context', [t.Instance, t.string]),
    },
	reloadContext: {
		protocol: new remoteProtocol<(player: Player, itemId: string) => void, () => void>('item_reload_context', [t.Instance, t.string]),
	}
}

export = protocols;