namespace gunwork {
    export enum bulletHoleLocation {
        normal = 'normal',
        metal = 'metal',
        glass = 'glass'
    }

    export interface imageItem {
        colorModifier?: Color3
        imageId: string
    }

    export enum itemTypeIdentifier {
        none, gun
    }
    
    export enum fireMode {
        auto="auto", semi="semi", burst2="burst2", burst3="burst3", burst4="burst4", shotgun="shotgun"
    }
    
    export type viewmodel = Model & {
        leftArm: MeshPart,
        rightArm: MeshPart,
        aimpart: Part,
        rootpart: Part,
        controller: AnimationController & {
            animator: Animator
        }
    }

    export interface sight {
        path: pathLike
        name: string
        zOffset: number
    }

    export type sightModel = Model & {
        display: BasePart
        base: BasePart
        focus: BasePart
        main: BasePart
    }
    export interface gunAttachmentConfig {
        sight?: sight
    }

    export interface gunAnimationsConfig {
        idle: string
    }

    export type basicCharacter = Model & {
        HumanoidRootPart: BasePart
        Humanoid: Humanoid & {
            Animator: Animator
        }
        Head: BasePart
    }
    
    export type gunViewmodel = viewmodel & {
        barrel: BasePart & {
            muzzle: Attachment
        }
        offsets: Folder & {
            idle: CFrameValue
        },
        sightNode: BasePart,
        audio: Folder & {
            boltback: Sound,
            boldforward: Sound,
            fire: Sound,
            magin: Sound,
            magout: Sound
        }
    }
}

export = gunwork;