import { RunService, Workspace } from "@rbxts/services";
import fastcast, {ActiveCast} from '@rbxts/fastcast';
import entity from "./basic/entity";
import space from "./space";

//https://etithespir.it/FastCastAPIDocs/fastcast-objects/caster/

enum castType {
	hitscan, projectile
}

interface rocastParams {
    debug: boolean

	canPierce: (result: RaycastResult) => pierceType

	onHit: (result: RaycastResult) => void

	ignore: Instance[]

	origin: Vector3,
	direction: Vector3
	velocity: number
	maxDistance: number

    castType: castType
}

interface rocastResult {
	entity?: entity
	position: Vector3
	instance: BasePart
	normal: Vector3
	material: Enum.Material
	//the amount of times it was pierced
	timesPierced: number
	//how much it will end up being damped
	dampingScores: number[]
}

interface pierceType {pierce: number, damagePercentage: number}

export default class rocaster {
	caster = new fastcast()
	behavior = fastcast.newBehavior();
    constructor(private params: rocastParams) {

		fastcast.VisualizeCasts = params.debug;

		let behavior = this.behavior;

		behavior.MaxDistance = params.maxDistance
		behavior.CanPierceFunction = (_, result) => {
			return this.params.canPierce(result)? true: false
		}

        if (params.castType === castType.projectile) {
            this.caster.RayHit.Connect((caster, result, velocity, cosmetic) => {
                params.onHit(result);
            })
    
            this.caster.RayPierced.Connect((caster, result, velocity, cosmetic) => {
    
            })
            
            this.caster.CastTerminating.Connect((caster) => {
                
            })
        }
        else if (params.castType === castType.hitscan) {
            
        }
    }
	recastHitscan(from: Vector3, direction: Vector3, pierces: number, distanceTraveled: number): RaycastResult | undefined {
		let distanceLeft = this.params.maxDistance - distanceTraveled;
		let ignore = new RaycastParams();
		ignore.FilterDescendantsInstances = space.ignoreInstances;
		let result = Workspace.Raycast(from, direction.mul(distanceLeft), ignore);
		if (result) {
			let out = this.params.canPierce(result)
			//check if can reflect
			if (out) {
				let distance = (from.sub(result.Position)).Magnitude;
				if (distance > 0) {
					result = this.recastHitscan(result.Position, direction, 0, distance);
				}
			}
		}
		return result;
	}
    rayCast() {
        let cast = this.recastHitscan(this.params.origin, this.params.direction, 0, 0);
		if (cast) {
			
		}
    }
    cast() {
        let cast = this.caster.Fire(this.params.origin, this.params.direction, this.params.velocity, this.behavior)
    }
}

const softAliases: {[key: string]: pierceType} = {
	wood_wall: {pierce: 1, damagePercentage: .85},
	wood_floor:{pierce: 1, damagePercentage: .85},
	crate: {pierce: 1, damagePercentage: .85}
}

function canPierce(result: RaycastResult) {
	let alias = softAliases[result.Instance.Name];
	if (alias) {
		//keep track of the alias internally
		return alias;
	}
	else {
		return;
	}
}