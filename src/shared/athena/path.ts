export default abstract class path {
    static getInstance(pathlike: string): Instance | undefined {
        let paths = pathlike.split('//');
        let inst: Instance = game;
        let error = false;
        for (const [i, v] of pairs(paths)) {
            let t = inst.FindFirstChild(v)
            if (t) {
                inst = t;
            }
            else {
                error = true;
                break;
            }
        }
        return error? undefined: inst;
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