import { propertyExistsInClass } from "shared/athena/utils";
import component from "./basic/component";
import entity from "./basic/entity";

namespace space {
    const entityMaps: Map<component[], entity[]> = new Map();

    export namespace query {
        export function findAllWithComponents(components: component[]): entity[] {
            let index = entityMaps.get(components);
            if (index) return index;
            return [];
        }
        export function filterAllWithPropertyAs<V>(property: string, value: V, components?: component[]) {
            if (components) {
                components.forEach((v) => {
                    if (propertyExistsInClass(v, property) && v[property] === value) {
                        
                    }
                })
            }
        }
    }
}

export = space;