import { RunService } from "@rbxts/services";
import mathf from "shared/modules/mathf";

namespace anime {
    interface invocatable<T extends animatable[keyof animatable]> {
        target: T,
        origin: T,
        current: T,
        elapsedTime: number,
        time: number
    }

    interface animatable {
        'Vector3': Vector3,
        'Vector2': Vector2,
        'number': number,
        'CFrame': CFrame,
        'Color3': Color3,
        'UDim2': UDim2,
        'UDim': UDim
    }

    function lerp(v0: number, v1: number, t: number): number {
        return v0 + (v1 - v0) * t
    }

    const INTERPOLATIONS: Record<keyof animatable, (v0: any, v1: any, v2: any) => any> = { //type it to animatable
        "Vector3": (v0: Vector3, v1: Vector3, t: number) => {
            return v0.Lerp(v1, t);
        },
        "Vector2": (v0: Vector2, v1: Vector2, t: number) => {
            return v0.Lerp(v1, t);
        },
        "number": (v0: number, v1: number, t: number) => {
            return lerp(v0, v1, t);
        },
        "CFrame": (v0: CFrame, v1: CFrame, t: number) => {
            return v0.Lerp(v1, t);
        },
        "Color3": (v0: Color3, v1: Color3, t: number) => {
            return v0.Lerp(v1, t);
        },
        "UDim2": (v0: UDim2, v1: UDim2, t: number) => {
            return v0.Lerp(v1, t);
        },
        "UDim": (v0: UDim, v1: UDim, t: number) => {
            return new UDim(lerp(v0.Scale, v1.Scale, t), lerp(v0.Offset, v1.Offset, t));
        }
    } as const

    const loopType = RunService.Heartbeat

    const invocationList: invocatable<animatable[keyof animatable]>[] = []
    
    const mainLoop = loopType.Connect((dt) => {
        invocationList.forEach((invocation) => {
            task.spawn(() => {
                let now = invocation.elapsedTime + 1 * dt
                let t = math.clamp(1 - mathf.normalize(0, 1, invocation.time - now), 0, 1)
                let index = INTERPOLATIONS[typeOf(invocation.current) as keyof typeof INTERPOLATIONS];
                type indexParameters = Parameters<typeof index>
                
                invocation.current = index(invocation.origin as indexParameters[0], invocation.target, t);

                invocation.elapsedTime = now
            })
        })
    })

    type KeysWithValsOfType<T,V> = keyof { [ P in keyof T as T[P] extends V ? P : never ] : P };

    export class animeInstanceClass<I extends Instance, V extends animatable[keyof animatable]> {
        private propertyConnections: Partial<Record<KeysWithValsOfType<WritableInstanceProperties<I>, V>, RBXScriptConnection>> = {}
        constructor(public instance: I, private invocable: invocatable<V>) {

        }
        bindPropertyToValue(property: KeysWithValsOfType<WritableInstanceProperties<I>, V>) {
            if (this.propertyConnections[property]) {
                throw `property ${tostring(property)} is already bound.`
            }

            let connection = loopType.Connect((dt: number) => {

                this.instance[property as keyof I] = this.getCurrentValue() as any;
            })
            this.propertyConnections[property] = connection;
        }
        bindCallbackToValue(callback: (value: V) => void) {
            let connection = loopType.Connect((dt: number) => {

                callback(this.getCurrentValue())
            })

            return {
                unbind: () => {
                    connection.Disconnect()
                }
            }
        }
        getCurrentValue() {
            return this.invocable.current;
        }
    }

    export function animateModelPosition(model: Model, to: Vector3, time: number) {
        if (!model.PrimaryPart) {throw 'model can not be animated without a primarypart set'}

        let origin = model.GetPrimaryPartCFrame().Position

        let invoc: invocatable<Vector3> = {
            target: to,
            origin: origin,
            current: origin,
            time: time,
            elapsedTime: 0
        }

        const animationClass = new animeInstanceClass(model, invoc);

        invocationList.push(invoc);

        const vCallback = animationClass.bindCallbackToValue((value) => {
            let [xr, yr, zr] = model.GetPrimaryPartCFrame().ToOrientation()
            model.SetPrimaryPartCFrame(new CFrame(value).mul(CFrame.fromOrientation(xr, yr, zr)))
        })

        return {
            animation: animationClass,
            binding: vCallback,
            model: model
        };
    }
}

export = anime;