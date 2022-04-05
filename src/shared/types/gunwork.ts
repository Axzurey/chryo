namespace gunwork {
    export enum itemTypeIdentifier {
        none, gun
    }
    
    export enum fireMode {
        auto, semi, burst2, burst3, burst4, shotgun
    }
    
    export type viewmodel = Model & {
        leftArm: MeshPart,
        rightArm: MeshPart,
        aimpart?: Part,
        rootPart?: Part,
    }
    
    export type gunViewmodel = viewmodel & {
        muzzle: BasePart & {
            point: Attachment
        },
        offsets: Folder & {
            idle: CFrameValue
        }
    }
}

export = gunwork;