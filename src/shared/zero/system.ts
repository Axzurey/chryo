import { RunService } from '@rbxts/services';
import protocols from './define/protocols';
import { GetGenericOfClassServer, GetGenericOfClassClient } from './signals/remoteProtocol';

namespace system {
    export namespace remote {
        export namespace server {
            export function fireClient<T extends keyof typeof protocols>(protocol: T, client: Player, 
                ...args: Parameters<GetGenericOfClassClient<(typeof protocols)[T]["protocol"]>>) {
                if (RunService.IsServer()) {
                    protocols[protocol].protocol.fireClient(client, args as any);
                }
                else {
                    throw `this method can not be called from the client`;
                }
            }
            export function on<T extends keyof typeof protocols>(protocol: T, callback: GetGenericOfClassServer<(typeof protocols[T])['protocol']>) {
                if (RunService.IsServer()) {
                    return protocols[protocol].protocol.listenServer(callback as any);
                }
                else {
                    throw `this method can not be called from the client`;
                }
            }
        }
        export namespace client {
            export function fireServer<T extends keyof typeof protocols>(protocol: T, 
                ...args: omitFirstValueOfArray<Parameters<GetGenericOfClassServer<(typeof protocols)[T]["protocol"]>>>) {
                if (RunService.IsClient()) {
                    protocols[protocol].protocol.fireServer(args as any);
                }
                else {
                    throw `this method can not be called from the server`;
                }
            }
            export function on<T extends keyof typeof protocols>(protocol: T, callback: GetGenericOfClassClient<(typeof protocols[T])['protocol']>) {
                if (RunService.IsClient()) {
                    return protocols[protocol].protocol.listenClient(callback as any);
                }
                else {
                    throw `this method can not be called from the server`;
                }
            }
        }
    }
}

export = system;