import { Workspace } from "@rbxts/services";

export default class animationCompile {
    private constructor(private animation: Animation) {
        
    }
    static create(animationId: string) {
        let a = new Instance("Animation");
        a.Parent = Workspace;
        a.AnimationId = animationId;

        return new this(a);
    }
    final() {
        return this.animation;
    }
    cleanUp() {
        this.animation.Destroy();
    }
}