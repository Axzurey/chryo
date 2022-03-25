export default class event<ServerArgs, ClientArgs> {

    remote: RemoteEvent | RemoteFunction

    constructor(
        private uid: string,
        private remoteType: 'RemoteFunction' | 'RemoteEvent'
    ) {
        let r = new Instance(remoteType);
        r.Name = uid;

        this.remote = r;
    }
}