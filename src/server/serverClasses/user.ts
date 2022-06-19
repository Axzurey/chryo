import human from "shared/zero/entities/human";

export type characterType = Model & {
    HumanoidRootPart: BasePart,
    Head: BasePart,
    Humanoid: Humanoid
}

export default class user extends human {
    character: characterType | undefined = undefined;

    client: Player | undefined = undefined;
    
    constructor() {
        super()
    }

    setClient(client: Player) {
        this.client = client
    }

    setCharacter(character: characterType | undefined) {
        this.character = character;
        this.vessel = character
    }
}