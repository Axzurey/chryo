namespace utils {
    interface classDef<T> {
        new(...args: any[]): T;
      }

    export function propertyExistsInClass<c extends classDef<any>, p extends string>(classlike: c, property: p): classlike is c & {property: any} {
        if (classlike[property as unknown as keyof typeof classlike]) return true;
        return false;
    }
}

export = utils;