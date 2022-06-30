import { entityType } from "shared/constants/zeroDefinitions";

export default class entity {
    entityType: entityType = entityType.unknown
    constructor(public vessel?: Instance) {
        
    }
    tick(dt: number) {}
}