export {}

declare global {
    namespace radonTypes {

        export enum Types {
            String = 'String',
            Number = 'Number',
            Boolean = 'Boolean',
            Color3 = 'Color3',
            Undefined = 'Undefined',
            Instance = 'Instance',
        }
        
        export interface TypesMap {
            [Types.String]: string
            [Types.Number]: number
            [Types.Boolean]: boolean
            [Types.Color3]: Color3
            [Types.Undefined]: undefined
            [Types.Instance]: Instance
        }
        
        export type validKeyType = Types | readonly validKeyType[] | validKeyType[] | {readonly [key: string]: validKeyType} | {[key: string]: validKeyType}

        export interface schemaKey {
            type: validKeyType
        }
        
        export type schemaParams = Record<string, schemaKey>

        type TypesToTypeMappedDeep<T> = 
            T extends radonTypes.Types? radonTypes.TypesMap[T]:
            T extends any[]? {[P in keyof T]: TypesToTypeMappedDeep<P>}:
            T extends Record<any, any>? {[P in keyof T]: TypesToTypeMappedDeep<T[P]>}: never

        type ExtendedProperties<T extends radonTypes.schemaParams> = { [P in keyof T]: TypesToTypeMappedDeep<T[P]["type"]> };
    }
}