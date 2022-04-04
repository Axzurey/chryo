import { RunService } from '@rbxts/services';
import protocols from './define/protocols';
import { GetGenericOfClassServer, GetGenericOfClassClient } from './signals/remoteProtocol';

namespace system {
    export namespace remote {
        export namespace server {
            export function on<T extends keyof typeof protocols>(protocol: T, callback: GetGenericOfClassServer<(typeof protocols[T])['protocol']>) {
                if (RunService.IsServer()) {
                    return protocols[protocol].protocol.listenServer(callback);
                }
                else {
                    throw `this method can not be called from the client`
                }
            }
        }
        export namespace client {
            export function on<T extends keyof typeof protocols>(protocol: T, callback: GetGenericOfClassClient<(typeof protocols[T])['protocol']>) {
                if (RunService.IsClient()) {
                    return protocols[protocol].protocol.listenClient(callback);
                }
                else {
                    throw `this method can not be called from the server`
                }
            }
        }
    }
}

export = system;