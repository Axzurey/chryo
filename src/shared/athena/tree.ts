interface InstanceTree {
	$className?: keyof Instances;
    $properties?: Record<keyof WritableInstanceProperties<any>, any>;
	[Key: string]: keyof Instances | undefined | InstanceTree | Record<keyof WritableInstanceProperties<any>, any>;
}

type EvaluateInstanceTree<T extends InstanceTree, D = Instance> = (T extends {
	$className: keyof Instances;
    $properties: keyof WritableInstanceProperties<any>
}
	? Instances[T["$className"]]
	: D) &
	{
		[K in Exclude<Exclude<keyof T, "$className">, '$properties'>]: KeyExtendsPropertyName<
			T,
			K,
			T[K] extends keyof Instances
				? Instances[T[K]]
				: T[K] extends InstanceTree
				? EvaluateInstanceTree<T[K]>
				: never
		>;
};

type KeyExtendsPropertyName<T extends InstanceTree, K, V> = K extends "Changed"
	? true
	: T extends {
			$className: keyof Instances;
	  }
	? K extends keyof Instances[T["$className"]]
		? unknown
		: V
	: V;

const treex = {
    $className: 'Folder',
    $properties: {
        Name: 'helo!'
    },
    hello: {
        $className: 'Part',
        cookies: 'Folder',
        $properties: {
            Color: Color3.fromRGB(1, 1, 1)
        }
    }
} as const;

export type castTree<I extends Instance, T extends InstanceTree> = I & EvaluateInstanceTree<T, I>

export default abstract class tree {
    static createTree<I extends Instance, T extends InstanceTree>(
        container: I,
        tree: T,
    ) {
        let l = tree["$className"];
        let x: Instance | undefined
        if (l) {
            x = new Instance(l as keyof CreatableInstances)
        }
        for (const [i, v] of pairs(tree)) {
            if (i === '$properties' && x) {
                for (const [r, t] of pairs(v)) {
                    x[r as keyof WritableInstanceProperties<typeof x>] = t as never
                }
            }
            else if (typeOf(v) === 'table') {
                let n = this.createTree(container, v);
                n.Parent = x;
            }
            else if(typeOf(v) === 'string' && !container[i as keyof typeof container]) {
                let n = new Instance(v as keyof CreatableInstances);
                n.Parent = x;
            }
        }
        return container as I & EvaluateInstanceTree<T, I>
    }
    static createFolder(name: string, parent: Instance) {
        let l = new Instance("Folder");
        l.Name = name;
        return l;
    }
}