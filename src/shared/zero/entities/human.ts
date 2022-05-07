import entity from "../basic/entity";
import { entityType } from "../define/zeroDefinitions";
import connection from "../signals/connection";

export default class human extends entity {
    entityType: entityType = entityType.human;
    health: number = 0;
    /**
     * 
     * @param damage in the event of an overkill, it returns the extra damage, else returns -1
     * @returns 
     */
    damaged = new connection<(oldHealth: number, newHealth: number, damageDealt: number, overkill: number) => void>()
    takeDamage(damage: number) {
        if (this.health - damage < 0) {
            let diff = this.health - damage;
            this.damaged.fire(this.health, 0, damage, diff);
            this.health = 0;
            return diff;
        }
        else {
            this.damaged.fire(this.health, 0, this.health - damage, 0);
            this.health -= damage;
            return -1;
        }
    }
}