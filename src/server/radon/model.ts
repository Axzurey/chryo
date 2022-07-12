import radonCode from "./errors";
import datastore from "./datastore";
import { schema, extractSchemaType } from "./schema";

export function model<S extends schema<any>>(key: string, schema: S) {
    class radonModel {
        constructor() {}//make key go here instead!
        /**
         * updates the properties of this class to be what was last retrieved from that datastore
         */
        public async get() {
            return new Promise((resolve, reject) => {
                let data = datastore.load(key, schema.databaseKey)
                if (data) {
                    let d = data as radonTypes.ExtendedProperties<extractSchemaType<S>>
                    for (const [i, v] of pairs(schema.params)) {
                        let t = this as radonModel & radonTypes.ExtendedProperties<extractSchemaType<typeof schema>>
                        t[i as keyof typeof t] = d[i as string] as typeof t[keyof typeof t];
                    }
                    resolve(radonCode.success);
                }
                else {
                    reject(radonCode.noData);
                }
            })
        }
        public async save() {
            return new Promise((resolve, reject) => {
                let save: radonTypes.ExtendedProperties<extractSchemaType<typeof schema>> | {} = {}
                
                for (const [i, v] of pairs(schema.params)) {
                    let t = this as radonModel & radonTypes.ExtendedProperties<extractSchemaType<typeof schema>>
                    save[i as keyof typeof save] = t[i as string] as typeof save[keyof typeof save];
                }
                save = save as radonTypes.ExtendedProperties<extractSchemaType<typeof schema>>
                
                let value = datastore.save(key, schema.databaseKey, save);
                if (value === radonCode.success) {
                    resolve(true);
                }
                else {
                    reject(value)
                }
            })
        }
    }
    return radonModel as typeof radonModel & {
        new(): radonModel & radonTypes.ExtendedProperties<extractSchemaType<typeof schema>>
    };
}