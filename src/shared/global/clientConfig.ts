import { tableUtils } from "shared/modules/utils"

interface clientSettings {
    general: {
        sightColor: Color3,
        sensitivity: number,
        adsSensitivity: number
    }
}

const defaultSettings: clientSettings = {
    general: {
        sightColor: new Color3(),
        sensitivity: .5,
        adsSensitivity: 1
    }
}

export default class clientConfig {
    settings: clientSettings = defaultSettings;
    constructor(providedSettings: Partial<clientSettings>) {
        this.settings = tableUtils.fillDefaults(providedSettings, defaultSettings);
    }
}