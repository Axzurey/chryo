namespace gunwork {
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
        muzzle: BasePart & {
            point: Attachment
        }
        offsets: Folder & {
            idle: CFrameValue
        },
        sightNode: BasePart
    }
}

export = gunwork;