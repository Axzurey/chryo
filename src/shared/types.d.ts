export {}

declare global {
    namespace gunwork {
        enum itemTypeIdentifier {
            none, gun
        }
        
        enum fireMode {
            auto, semi, burst2, burst3, burst4, shotgun
        }
        
        type viewmodel = Model & {
            leftArm: MeshPart,
            rightArm: MeshPart,
            aimpart?: Part,
            rootPart?: Part,
        }
        
        type gunViewmodel = viewmodel & {
            muzzle: BasePart & {
                point: Attachment
            },
        }
    }
}