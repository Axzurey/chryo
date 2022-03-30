namespace utils {

    export type propertyExists<P extends string, T> = { [k in P]: T}

    export type valueof<T, P extends keyof T> = T[P];

    export function propertyExistsInObject<c extends any, p extends string, propType>(classlike: c, property: p): classlike is c & propertyExists<p, propType> {
        if (classlike[property as unknown as keyof typeof classlike]) return true;
        return false;
    }

    export namespace array {
        export function partition<T>(arr: T[], start: number, end: number){
            // Taking the last element as the pivot
            const pivotValue = arr[end];
            let pivotIndex = start; 
            for (let i = start; i < end; i++) {
                if (arr[i] < pivotValue) {
                // Swapping elements
                [arr[i], arr[pivotIndex]] = [arr[pivotIndex], arr[i]];
                // Moving to next element
                pivotIndex++;
                }
            }
            
            // Putting the pivot value in the middle
            [arr[pivotIndex], arr[end]] = [arr[end], arr[pivotIndex]] 
            return pivotIndex;
        };
    }
}

export = utils;