import entity from "../basic/entity";
import { entityType } from "../define/zeroDefinitions";
import connection from "../signals/connection";

export default class human extends entity {

    entityType: entityType = entityType.human;

    health: number = 0;
    maxHealth: number = 0;

    /**
     * 
     * @param damage in the event of an overkill, it returns the extra damage, else returns -1
     * @returns 
     */
    damaged = new connection<(oldHealth: number, newHealth: number, damageDealt: number, overkill: number) => void>()
    healed = new connection<(oldHealth: number, newHealth: number, clampedIncrease: number) => void>()
    /**
     * must be manually called if takeDamage returns a dead state
     */
    died = new connection<(by: entity | string, killed: human) => void>()
    takeDamage(damage: number, ...args: unknown[]) {
        if (this.health - damage < 0) {
            let diff = this.health - damage;
            this.damaged.fire(this.health, 0, damage, diff);
            this.health = 0;
        }
        else {
            this.damaged.fire(this.health, 0, this.health - damage, 0);
            this.health -= damage;
        }
    }
    heal(hp: number) {
        let increase = this.health + hp //misleading name, i know
        let og = increase
        if (increase > this.maxHealth) {
            increase = this.maxHealth
        }

        let diff = math.abs(og - increase);

        this.healed.fire(this.health, increase, diff)
        this.health = increase
    }
    alive() { return this.health > 0 }
}