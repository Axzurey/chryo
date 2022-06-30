import { RunService, Workspace } from '@rbxts/services';
import protocols from '../constants/protocols';
import { GetGenericOfClassServer, GetGenericOfClassClient } from 'shared/modules/remoteProtocol';

namespace system {
    export namespace poly {
        export function drawLine(p1: Vector3, p2: Vector3) {
            let bin = Workspace.FindFirstChild('debug_system')!;
            if (!bin) {
                bin = new Instance("Folder");
                bin.Name = 'debug_system';
                bin.Parent = Workspace;
            }

            let p = new Instance("Beam");
            let a1 = new Instance("Attachment")
            let a2 = new Instance("Attachment")

            let a = new Instance("Part")
            a.CanCollide = false;
            a.Anchored = true;
            a.CanTouch = false;
            a.CanQuery = false;
            a.Transparency = 1;
            a.Parent = Workspace;

            p.Width0 = .005
            p.Width1 = .005
            p.Color = new ColorSequence(new Color3(1, 0, 0));
            p.Brightness = 60;
            p.Attachment0 = a1;
            p.Attachment1 = a2;

            a1.WorldPosition = p1;
            a2.WorldPosition = p2;

            p.Parent = a;
            a1.Parent = a;
            a2.Parent = a;
        }
    }
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
                    protocols[protocol].protocol.fireServer(args as never);
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