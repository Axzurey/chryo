import { propertyExistsInObject } from "shared/athena/utils";
import component from "./basic/component";
import entity from "./basic/entity";

namespace space {
    const entityMaps: Map<component[], entity[]> = new Map();
    export const ignoreInstances: Instance[] = [];

    export namespace query {
        export function findAllWithComponents(components: component[]): entity[] {
            let index = entityMaps.get(components);
            if (index) return index;
            return [];
        }
        /**
         * 
         * @param property 
         * @param value 
         * @param useComponents if this is not provided, it searches through every entity in the game
         * @returns 
         */
        export function filterAllWithPropertyAs<V>(property: string, value: V, useComponents?: component[]) {
            let selected: component[] = [];
            if (useComponents) {
                useComponents.forEach((v) => {
                    if (propertyExistsInObject(v, property) && v[property] === value) {
                        selected.push(v)
                    }
                })
            }
            else {
                entityMaps.forEach((comparr) => {
                    comparr.forEach((v) => {
                        if (propertyExistsInObject(v, property) && v[property] === value) {
                            selected.push(v)
                        }
                    })
                })
            }
            return selected;
        }
    }
}

export = space;