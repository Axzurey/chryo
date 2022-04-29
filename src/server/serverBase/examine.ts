namespace examine {
    export enum hitLocation {
        head,
        body,
        limb
    }
    const headNames = ['head']
    const bodyNames = ['UpperTorso', 'LowerTorso', 'Torso'];
    const limbNames = ['LeftLowerLeg', 'LeftUpperLeg', 'LeftFoot', 'RightLowerLeg', 
        'RightUpperLeg', 'RightFoot', 'LeftLowerArm', 'LeftUpperArm', 'LeftHand',
        'RightLowerArm', 'RightUpperArm', 'RightHand']
    export function examineHitLocation(hit: BasePart): hitLocation {
        if (headNames.indexOf(hit.Name) !== -1) {
            return hitLocation.head;
        }
        else if (bodyNames.indexOf(hit.Name) !== -1) {
            return hitLocation.body;
        }
        else {
            return hitLocation.limb;
        }
    }
}

export = examine;