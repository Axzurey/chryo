export class schema<T extends radonTypes.schemaParams> {
    constructor(public databaseKey: string, public params: T) {
        
    }
}

export type extractSchemaType<T extends schema<any>> = T extends schema<infer A> ? A : never;