import human from "shared/entities/entityClasses/human";
import connection from "shared/modules/connection";

export type characterType = Model & {
    HumanoidRootPart: BasePart,
    Head: BasePart,
    Humanoid: Humanoid
}

export enum characterState {
    alive,
    dead,
    dbno
}

const downDamageDifferenceFromZero = 20;

export default class user extends human {
    character: characterType | undefined = undefined;

    client: Player | undefined = undefined;

    state: characterState = characterState.alive;

    characterStateChanged = new connection<(from: characterState, to: characterState) => void>()
    
    constructor() {
        super()
    }

    override heal(hp: number): void {
        
    }
    //tag players, to confirm kill after they bleed out
    override takeDamage(damage: number, definiteDowns: boolean) {
        if (this.state === characterState.dead) return;
        let diff = this.health - damage;
        if (diff > downDamageDifferenceFromZero && this.state !== characterState.dbno && !definiteDowns) {
            this.state = characterState.alive;
        }
        else {
            //they can be downed
            this.characterStateChanged.fire(this.state, characterState.dbno)
            this.state = characterState.dbno;
            this.health = 10
        }
    }

    isAlive() {
        return this.state === characterState.alive
    }

    isDBNO() {
        return this.state === characterState.dbno
    }
    
    setClient(client: Player) {
        this.client = client
    }

    setCharacter(character: characterType | undefined) {
        this.character = character;
        this.vessel = character
    }

    override tick(dt: number) {
        if (this.state === characterState.dbno) {
            this.health -= 45 * dt
        }
        if (!this.character) return;
        this.character!.Humanoid.MaxHealth = this.maxHealth;
        this.character!.Humanoid.Health = this.health;
    }
}