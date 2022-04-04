import { Players, RunService } from "@rbxts/services"
import { getSharedEnvironment } from "shared/constants/environment"

type anyFunctionVoid = (...args: any[]) => void
type playerFuncVoid = (player: Player, ...args: unknown[]) => void

interface protocolListener<T extends anyFunctionVoid> {
    callback?: T
	disconnect: () => void
	called?: true
	once?: true
	passedArgs?: Parameters<T>
	disconnected: boolean
}

export type GetGenericOfClassServer<T> = T extends remoteProtocol<infer A, infer B> ? A : never;
export type GetGenericOfClassClient<T> = T extends remoteProtocol<infer A, infer B> ? B : never;

/**
 * the parameters of the generic are what the component recieves: FireServer would send Parameters<Server>
 */
export default class remoteProtocol<Server extends (player: Player, ...args: any[]) => void, Client extends anyFunctionVoid> {
	private listeners: protocolListener<Server | Client>[] = [];
    private remote: RemoteEvent

    constructor(uniqueAlias: string) {
        if (RunService.IsServer()) {
            this.remote = new Instance('RemoteEvent');
            this.remote.Name = `protocol:${uniqueAlias}`;
            this.remote.Parent = getSharedEnvironment().Remotes;

            this.remote.OnServerEvent.Connect((client, ...args: unknown[]) => {
                this.listeners.forEach((v) => {
                    if (v.callback) {
                        let callback = v.callback as Server;
                        callback(client, ...args)
                    }
                })
            })
        }
        else {
            this.remote = getSharedEnvironment().Remotes.WaitForChild(`protocol:${uniqueAlias}`) as RemoteEvent;
            this.remote.OnClientEvent.Connect((...args: unknown[]) => {
                this.listeners.forEach((v) => {
                    if (v.callback) {
                        let callback = v.callback as Client;
                        callback(...args as unknown[])
                    }
                })
            })
        }
    }

    private disconnectSomething(d: protocolListener<Server | Client>) {
		let index = this.listeners.indexOf(d);
		if (d.disconnected) {
			throw `unable to disconnect a connection that has already been disconnected`
		}
		if (index !== -1) {
			d.disconnected = true;
			this.listeners.remove(index);
		}
	}

    private addListener(constructed: protocolListener<Server | Client>) {;
        this.listeners.push(constructed)
    }

	public listenServer(callback: Server) {
        let c: protocolListener<Server> = {
            callback: callback,
            disconnected: false,
            disconnect: () => {
                this.disconnectSomething(c)
            },
        }
        this.addListener(c);
        return c;
	}

    public listenClient(callback: Client) {
        let c: protocolListener<Client> = {
            callback: callback,
            disconnected: false,
            disconnect: () => {
                this.disconnectSomething(c)
            },
        }
        this.addListener(c);
        return c;
	}

    public fireClient(client: Player, args: Parameters<Client>) {
        if (RunService.IsClient()) throw `this method may not be called from the client!`;

        this.remote.FireClient(client, ...args as unknown[]);
    }
    public fireClients(clients: Player[], args: Parameters<Client>) {
        if (RunService.IsClient()) throw `this method may not be called from the client!`;

        clients.forEach((client) => {
            this.remote.FireClient(client, ...args as unknown[]);
        })
    }
    public fireAllClientsExcept(blacklist: Player[], args: Parameters<Client>) {
        if (RunService.IsClient()) throw `this method may not be called from the client!`;

        Players.GetPlayers().forEach((client) => {
            if (blacklist.indexOf(client) !== -1) return;
            this.remote.FireClient(client, ...args as unknown[]);
        })
    }
}