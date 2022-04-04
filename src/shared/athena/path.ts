export default abstract class path {
    static getInstance(pathlike: string): Instance | undefined {
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
        let i = this.getInstance(pathlike) as Instance;
        if (!i) throw `${pathlike} is an invalid path`
        return i
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