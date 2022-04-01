type anyFunctionVoid = (...args: never[]) => void

interface protocolEars<T extends anyFunctionVoid> {
    callback?: T
	disconnect: () => void
	called?: true
	once?: true
	passedArgs?: Parameters<T>
	disconnected: boolean
}

export default class remoteProtocol<T extends anyFunctionVoid> {
	listeners: Record<string, protocolEars<T>[]> = {};

    private constructor(uniqueAlias: string) {

    }
	static createRemoteProtocol(uniqueAlias: string) {
        return new this(uniqueAlias);
    }

    private addListener(protocol: string, constructed: protocolEars<T>) {
        let list = this.listeners[protocol];
        if (list) {
            list.push(constructed);
        }
        else {
            let l = [constructed];
            this.listeners[protocol] = l
        }
    }

	on(protocol: string, callback: T) {
        
	}
    fire(protocol: string, args: Parameters<T>) {

    }
}