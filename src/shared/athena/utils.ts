namespace utils {

    export function propertyExistsInObject<c extends any, p extends string, propType>(classlike: c, property: p): classlike is c & propertyExists<p, propType> {
        if (classlike[property as unknown as keyof typeof classlike]) return true;
        return false;
    }

    export function newThread(callback: () => void) {
        task.spawn(callback);
    }

    export namespace ease {
        export function repeatThis(callback: (iteration: number) => void, times: number) {
            for (let i = 0; i < times; i++) {
                callback(times);
            }
        }
        export function repeatThisThreadEach(callback: (iteration: number) => void, times: number) {
            for (let i = 0; i < times; i++) {
                task.spawn(callback, i);
            }
        }
    }

	export namespace stringify {
		export function randomString(length: number, includeNumbers?: boolean) {
			let s = ''
			for (let i = 0; i < length; i++) {
				s += includeNumbers && math.random() === 0? math.random(0, 9): string.char(math.random(97, 122))
			}
			return s;
 		}
	}

    export namespace dataTypeUtils {
        /**
         * returns a cframe position and orientation
         */
        export function cframeToCFrames(cframe: CFrame) {
            let o = cframe.ToOrientation()
            return [new CFrame(cframe.Position), CFrame.fromOrientation(o[0], o[1], o[2])];
        }
    }

    export namespace instanceUtils {
        /**
         * makes all children as if they aren't there(uninteractable)
         */
        export function nominalizeAllChildren(parent: Instance) {
            parent.GetChildren().forEach((v) => {
                if (v.IsA("BasePart")) {
                    v.CanCollide = false;
                    v.CanTouch = false;
                    v.CanQuery = false;
                }
            })
        }

        export function nominalizeAllDescendants(parent: Instance) {
            parent.GetDescendants().forEach((v) => {
                if (v.IsA("BasePart")) {
                    v.CanCollide = false;
                    v.CanTouch = false;
                    v.CanQuery = false;
                }
            })
        }

        export function unanchorAllChildren(parent: Instance) {
            parent.GetChildren().forEach((v) => {
                if (v.IsA("BasePart")) {
                    v.Anchored = false;
                }
            })
        }

        export function unanchorAllDescendants(parent: Instance) {
            parent.GetDescendants().forEach((v) => {
                if (v.IsA("BasePart")) {
                    v.Anchored = false;
                }
            })
        }
    }

    export namespace tableUtils {

		export function firstNumberRangeContainingNumber<T>(ranges: {[key: NumberRange]: T}) {
			
		}

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