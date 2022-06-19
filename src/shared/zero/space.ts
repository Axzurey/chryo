import { propertyExistsInObject } from "shared/athena/utils";
import entity from "./basic/entity";
import { entityType } from "./define/zeroDefinitions";

namespace space {
    const entities: entity[] = [];
    export const ignoreInstances: Instance[] = [];

    export namespace life {
        export function create<T extends entity>(entityType: new (vessel?: Instance) => T): T {
            let e = new entityType();
            entities.push(e);
            return e;
        }
    }

    export namespace query {
        export function entityIsThatIfOfType<E extends entity>(entity: entity, entityType: entityType): entity is E {
            if (entityType === entity.entityType) {
                return true;
            }
            return false;
        }

        export function getAllWithProperty<K extends string>(property: K): (entity & Record<K, unknown>)[] {
            let selected: (entity & Record<K, any>)[] = [];
            entities.forEach((v) => {
                if (propertyExistsInObject(v, property)) {
                    selected.push(v)
                }
            })
            return selected;
        }
        /**
         * note: for value(parameter 2) remember to throw in 'as const' to the end or else it will end up as a broad type
         */
        export function getAllWithPropertyAs<K extends string, V>(property: K, value: V): (entity & Record<K, V>)[] {
            let selected: (entity & Record<K, V>)[] = [];
            entities.forEach((v) => {
                if (propertyExistsInObject(v, property) && v[property] === value) {
                    selected.push(v as typeof v & Record<K, V>)
                }
            })
            return selected;
        }

        export function entityHasPropertyOfType<E extends entity, K extends string, T extends keyof CheckableTypes>
        (entity: E, property: K, propertyType: T): entity is E & Record<K, CheckableTypes[T]> {
            if (propertyExistsInObject(entity, property) && typeOf(entity[property]) === propertyType) {
                return true;
            }
            return false;
        }
        export function findFirstEntityWithVessel(vessel: Model) {
            for (const [_, v] of pairs(entities)) {
                if (v.vessel && vessel === v.vessel) {
                    return v;
                }
            }
        }
        export function findFirstEntityWithVesselThatContainsInstance(instance: Instance) {
            for (const [_, v] of pairs(entities)) {
                if (v.vessel && instance.IsDescendantOf(v.vessel)) {
                    return v;
                }
            }
        }
    }
}

export = space;