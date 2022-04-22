import connection from "shared/zero/signals/connection"
import datastore from "./datastore"
import radonCode from "./errors"

namespace radon {
	export enum Types {
		String = 'String',
		Number = 'Number',
		Boolean = 'Boolean',
		Color3 = 'Color3',
		Undefined = 'Undefined'
	}

	interface TypesMap {
		[Types.String]: string,
		[Types.Number]: number,
		[Types.Boolean]: boolean,
		[Types.Color3]: Color3,
		[Types.Undefined]: undefined
	}

	export type validKeyType = Types | readonly validKeyType[] | validKeyType[] | {readonly [key: string]: validKeyType} | {[key: string]: validKeyType}

	export interface schemaKey {
		type: validKeyType
	}

	export type schemaParams = Record<string, schemaKey>

	export class schema<T extends schemaParams> {
		constructor(public databaseKey: string, public params: T) {
			
		}
	}

	type TypesToTypeMappedDeep<T> = 
		T extends Types? TypesMap[T]:
		T extends any[]? {[P in keyof T]: TypesToTypeMappedDeep<P>}:
		T extends Record<any, any>? {[P in keyof T]: TypesToTypeMappedDeep<T[P]>}: never

	type ExtendedProperties<T extends schemaParams> = { [P in keyof T]: TypesToTypeMappedDeep<T[P]["type"]> };

	type extractSchemaType<T extends schema<any>> = T extends schema<infer A> ? A : never;

	export function model<S extends schema<any>>(key: string, schema: S) {
		class radonModel {
			/**
			 * updates the properties of this class to be what was last retrieved from that datastore
			 */
			public async get() {
				return new Promise((resolve, reject) => {
					let data = datastore.load(key, schema.databaseKey)
					if (data) {
						let d = data as ExtendedProperties<extractSchemaType<S>>
						for (const [i, v] of pairs(schema.params)) {
							let t = this as radonModel & ExtendedProperties<extractSchemaType<typeof schema>>
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
					let save: ExtendedProperties<extractSchemaType<typeof schema>> | {} = {}
					
					for (const [i, v] of pairs(schema.params)) {
						let t = this as radonModel & ExtendedProperties<extractSchemaType<typeof schema>>
						save[i as keyof typeof save] = t[i as string] as typeof save[keyof typeof save];
					}
					save = save as ExtendedProperties<extractSchemaType<typeof schema>>
					
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
			new(): radonModel & ExtendedProperties<extractSchemaType<typeof schema>>
		};
	}
}

export = radon;