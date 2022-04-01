type anyFunctionVoid = (...args: never[]) => void

interface signal<T extends anyFunctionVoid> {
	callback?: T
	disconnect: () => void
	called?: true
	once?: true
	passedArgs?: Parameters<T>
	disconnected: boolean
}

export default class connection<T extends anyFunctionVoid> {
	connections: signal<T>[] = [];
	constructor() {

	}
	fire(...args: Parameters<T>) {
		this.connections.forEach((v) => {
			coroutine.wrap(() => {
				if (v.callback) {
					v.callback(...args)
				}
				v.passedArgs = args;
				v.called = true;
				if (v.once) {
					v.disconnect()
				}
			})()
		})
	}

	private disconnectSomething(d: signal<T>) {
		let index = this.connections.indexOf(d);
		if (d.disconnected) {
			throw `unable to disconnect a connection that has already been disconnected`
		}
		if (index !== -1) {
			d.disconnected = true;
			this.connections.remove(index);
		}
	}

	connect(callback: T) {
		let l: signal<T> = {
			callback: callback,
			disconnect: () => {
				this.disconnectSomething(l)
			},
			disconnected: false
		}
		this.connections.push(l);
		return l;
	}
}