namespace utils {

    export function propertyExistsInObject<c extends any, p extends string, propType>(classlike: c, property: p): classlike is c & propertyExists<p, propType> {
        if (classlike[property as unknown as keyof typeof classlike]) return true;
        return false;
    }

    export namespace tableUtils {

        export function fillDefaults<T extends Record<any, any>>(passed: Partial<T>, fill: T): T {
            for (const [i, v] of pairs(fill)) {
                if (passed[i as keyof typeof passed]) {
                    continue;
                }
                else {
                    passed[i as keyof typeof passed] = v as any;
                }
            }
            return passed as T;
        }

        export function toArray<T extends Record<any, any>>(dictionary: T): ValueOf<T>[] {
            let a: ValueOf<T>[] = [];
    
            for (const [_, v] of pairs(dictionary)) {
                a.push(v as ValueOf<T>);
            }
            
            return a;
        }
    
        export function toKeysArray<T extends Record<any, any>>(dictionary: T): (keyof T)[] {
            let a: (keyof T)[] = [];
    
            for (const [v, _] of pairs(dictionary)) {
                a.push(v as keyof T);
            }
            
            return a;
        }

        export function partToPosition(parts: BasePart[]): Vector3[] {
            return parts.map((part) => {
                return part.Position
            });
        }
        
        export function firstKeyOfValue<V extends any, D extends Record<string, never>>(dictionary: D, value: V): keyof D | undefined {
            for (const [i, v] of pairs(dictionary)) {
                if (value === v) {
                    return i as keyof D;
                }
            }
            return;
        }
    }
}

export = utils;