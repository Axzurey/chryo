export {}

declare global {
    type ValueOf<T> = T[keyof T]

	type InferThis<T> = T extends (this: infer U, ...parameters: Array<any>) => any ? U : never;

	type Parameters2<T> = T extends (...args: infer P) => any ? P : never;
	type ReturnType2<T> = T extends (...args: Array<any>) => infer R ? R : never;

    type propertyExists<P extends string, T> = { [k in P]: T}

    type pathLike = string;

	interface TypedPropertyDescriptor<T> {
		value: (self: InferThis<T>, ...parameters: Parameters2<T>) => ReturnType2<T>;
	}
    namespace gunwork {
        enum itemTypeIdentifier {
            none, gun
        }
        
        enum fireMode {
            auto, semi, burst2, burst3, burst4, shotgun
        }
        
        type viewmodel = Model & {
            leftArm: MeshPart,
            rightArm: MeshPart,
            aimpart?: Part,
            rootPart?: Part,
        }
        
        type gunViewmodel = viewmodel & {
            muzzle: BasePart & {
                point: Attachment
            },
        }
    }
}