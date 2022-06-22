import { RunService } from "@rbxts/services";

namespace anime {
    interface invocatable<T extends animatable[keyof animatable]> {
        target: T,
        origin: T,
        current: T,
        elapsedTime: number,
        time: number
    }

    //type animatable = Vector3 & Vector2 & number & CFrame & Color3 & UDim2 & UDim

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

    const INTERPOLATIONS = {
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
    }

    const loopType = RunService.IsServer() ? RunService.Stepped : RunService.RenderStepped;

    const invocationList: invocatable<animatable[keyof animatable]>[] = []
    
    const mainLoop = loopType.Connect((dt) => {
        invocationList.forEach((invocation) => {
            task.spawn(() => {
                let t = invocation.elapsedTime + 1 * dt
                invocation.current = INTERPOLATIONS[typeOf(invocation.current) as keyof typeof INTERPOLATIONS](invocation.origin, invocation.target, t);

                invocation.elapsedTime = t
            })
        })
    })

    class animeInstanceClass<T extends Instance, Z extends animatable> {
        constructor(public instance: T, private invocable: invocatable<Z>) {

        }
        getCurrentValue() {
            return this.invocable.current;
        }
    }

    export function animateModel(model: Model, to: Vector3, time: number) {
        if (!model.PrimaryPart) {throw 'model can not be animated without a primarypart set'}

        let origin = model.GetPrimaryPartCFrame().Position

        let invoc: invocatable<Vector3> = {
            target: to,
            origin: origin,
            current: origin,
            time: time,
            elapsedTime: 0
        }

        invocationList.push(invoc);


    }
}

export = anime;