import { Workspace } from "@rbxts/services";
import { plotInWorld } from "./graphRBX";

const SOFT_PADDING = .1

const GRAVITY_CONSTANT = -196.2

const TERMINAL_VELOCITY = 50

type hitboxType = Model & {
    hitbox: BasePart
}

type acceptableForms = BasePart | hitboxType

function isHitboxType(form: acceptableForms): form is hitboxType {
    if (form.IsA('Model')) return true;
    return false;
}

export function lerpV3(v0: Vector3, v1: Vector3, t: number): Vector3 {
    return v0.add(v1.sub(v0).mul(t));
}

let v3 = Vector3

function getCorners(position: Vector3, size: Vector3): [Vector3, Vector3, Vector3, Vector3, Vector3, Vector3, Vector3, Vector3] {
    const p = [
        position.add(new v3(-size.X / 2, size.Y / 2, size.Z / 2)), 
        position.add(new v3(size.X / 2, size.Y / 2, -size.Z / 2)), 
        position.add(new v3(-size.X / 2, size.Y / 2, -size.Z / 2)), 
        position.add(new v3(size.X / 2, size.Y / 2, size.Z / 2)),
        position.add(new v3(-size.X / 2, -size.Y / 2, size.Z / 2)), 
        position.add(new v3(size.X / 2, -size.Y / 2, -size.Z / 2)), 
        position.add(new v3(-size.X / 2, -size.Y / 2, -size.Z / 2)), 
        position.add(new v3(size.X / 2, -size.Y / 2, size.Z / 2)),
    ] as [Vector3, Vector3, Vector3, Vector3, Vector3, Vector3, Vector3, Vector3]
    return p
}

function reflect(vector: Vector3, normal: Vector3): Vector3 {
    return vector.sub(normal.mul(2).mul(vector.Dot(normal)))
}

export default class physicsObject<Form extends acceptableForms> {
    size: Vector3 = new Vector3();

    velocity: Vector3 = new Vector3();
    acceleration: Vector3 = new Vector3();

    mass: number = 1;
    restitution: number = 15;
    constructor(public form: Form, public position: Vector3) {
        if (isHitboxType(this.form)) {
            this.form.SetPrimaryPartCFrame(new CFrame(position))
        }
        else {
            this.form.Position = position;
        }
        this.size = isHitboxType(form) ? form.hitbox.Size : form.Size;
    }
    applyImpulse(v3: Vector3) {
        this.velocity = this.velocity.add(v3.div(this.mass));
    }
    update(dt: number) {
        this.velocity = new Vector3(
            math.clamp(this.velocity.X, -TERMINAL_VELOCITY, TERMINAL_VELOCITY),
            math.clamp(this.velocity.Y + GRAVITY_CONSTANT * dt, -TERMINAL_VELOCITY, TERMINAL_VELOCITY), 
            math.clamp(this.velocity.Z, -TERMINAL_VELOCITY, TERMINAL_VELOCITY)
        )

        let targetAddition = this.velocity.mul(dt).add(this.acceleration.mul(dt));
        this.acceleration = new Vector3()

        let targetPosition = this.position.add(targetAddition);

        let corners = getCorners(targetPosition, this.size);
        let originCorners = getCorners(this.position, this.size);

        const ignore = new RaycastParams();
        ignore.FilterDescendantsInstances = [this.form]

        let cVector = targetPosition;
        for (let i = 1; i <= originCorners.size(); i++) {
            let v = originCorners[i - 1]
            let nextP = corners[i - 1];
            let direction = nextP.sub(v);
            let unitDir = direction.Unit;
            let dirMag = direction.Magnitude;
            
            let result = Workspace.Raycast(v, unitDir.mul(dirMag), ignore);
            if (result) {
                cVector = this.position.add(direction.mul(result.Position.sub(v).Magnitude - SOFT_PADDING));

                plotInWorld(cVector, Color3.fromRGB(255, 0, 255))

                this.velocity = reflect(this.velocity.mul(this.restitution), result.Normal);

                this.position = cVector;
                
                targetAddition = this.velocity.mul(dt);
                
                targetPosition = this.position.add(targetAddition);

                corners = getCorners(targetPosition, this.size);
                originCorners = getCorners(this.position, this.size);

            }
            plotInWorld(targetPosition, Color3.fromRGB(0, 255, 0), 3)
            print(targetPosition)
        }

        this.position = cVector;

        if (isHitboxType(this.form)) {
            this.form.SetPrimaryPartCFrame(new CFrame(cVector))
        }
        else {
            this.form.Position = cVector;
        }
    }
}