import { entityType } from "../define/zeroDefinitions";

export default class entity {
    entityType: entityType = entityType.unknown
    constructor(public vessel?: Instance) {
        
    }
}