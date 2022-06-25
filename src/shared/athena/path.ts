import pattern from "./pattern";

export default abstract class path {
    static exists(pathlike: string) {
        return this.getInstance(pathlike) ? true : false
    }
    static last(pathlike: string) {
        pathlike = pathlike.split('&')[0];

        let paths = pathlike.split('//');

        return paths[paths.size() - 1]
    }
    static getInstance(pathlike: string): Instance | undefined {
        pathlike = pathlike.split('&')[0];

        let paths = pathlike.split('//');
        let inst: Instance = game;
        let err = false;
        
        for (const [i, v] of pairs(paths)) {
            let t = inst.FindFirstChild(v)
            if (t) {
                inst = t;
            }
            else {
                err = true;
                break;
            }
        }
        return err? undefined: inst;
    }

    /**
     * use this if you're sure the path exists. if it doesn't, this method will throw an error
     */
    static sure(pathlike: string): Instance {
        //now make it accept args that tell like if it's of a certain class or smth
        let i = this.getInstance(pathlike) as Instance;
        if (!i) throw `${pathlike} is an invalid path`;

        let matches = pattern.match(pathlike, {
            'classMust': '&class:%a+'
        })

        if (matches.classMust && i.ClassName !== matches.classMust) throw `instance found does not match class ${matches.classMust}. it has class ${i.ClassName}`

        return i
    }

    static createIfMissing<T extends keyof CreatableInstances>(pathlike: string, classType: T): CreatableInstances[T] {
        pathlike = pathlike.split('&')[0];

        let paths = pathlike.split('//');
        let inst: Instance = game;
        
        for (const [i, v] of pairs(paths)) {
            let t = inst.FindFirstChild(v)
            if (t) {
                inst = t;
            }
            else {
                print(i, paths)
                if (i === paths.size()) {
                    print('last one!')
                    let n = new Instance(classType);
                    n.Name = v;
                    n.Parent = inst;
                    inst = n;
                }
                else {
                    throw `unable to create path ${pathlike}. ${paths[paths.size() - 1]} is too deeply nested in non-existing instances`;
                }
                break;
            }
        }
        return inst as CreatableInstances[T];
    }

    static join(...pathlike: string[]): string {
        let l = ''
        pathlike.forEach((v, i) => {
            if (i === 0) {
                l = v
            }
            else {
                l = `${l}//${v}`
            }
        })
        return l;
    }
}