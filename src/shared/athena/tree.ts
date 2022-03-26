type treeArgs<T extends keyof CreatableInstances> = Partial<WritableInstanceProperties<CreatableInstances[T]>> & {
    Children?: treeParams<any>[],
    instanceName: T
}

type treeParams<T extends keyof CreatableInstances> = [instanceName: keyof CreatableInstances, params: Omit<treeArgs<T>, 'instanceName'>];

//eval<typeof tree[0], typeof tree[1]> 
export default abstract class tree {
    static generateInstance<T extends keyof CreatableInstances>(tree: treeParams<T>): CreatableInstances[T] {
        const instanceName = tree[0] as T;
        const args = tree[1];
        let x = new Instance(instanceName);
        for (const [i, v] of pairs(args)) {
            if (i === 'Children') {
                (v as treeParams<T>[]).forEach((r) => {
                    this.generateInstance(r).Parent = x;
                })
            }
            else {
                x[i as keyof WritableInstanceProperties<typeof x>] = v as never;
            }
        };
        return x;
    }
    //change to createinstance
    static createInstance<T extends keyof CreatableInstances>(instanceName: T, args: Omit<treeArgs<T>, 'instanceName'>): treeParams<T> {
        return [instanceName, args];
    }
}

let x = tree.createInstance('Folder', {
    Children: [
        tree.createInstance('Part', {
            Size: new Vector3()
        }),
        tree.createInstance('Folder', {
            Name: 'specialFolder',
            Children: [
                tree.createInstance('RemoteEvent', {
                    'Name': 'hello!'
                })
            ]
        })
    ]
})

let inst = tree.generateInstance(x);