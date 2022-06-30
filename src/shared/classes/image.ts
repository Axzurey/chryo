import path from "shared/modules/path";

const directory = path.createIfMissing('Workspace//imageSource', 'Folder');

export default class image {
    private constructor(private imageId: string, private size: Vector2, private explicitColor: Color3, private transparency: number = 0) {

    }
    static create(imageId: string, size: Vector2, explicitColor: Color3 = new Color3(1, 1, 1), transparency: number = 0) {
        return new image(imageId, size, explicitColor, transparency);
    }
    toLabel(at: Vector2, rotation: number, scale: number, parent: Instance) {

        let inst = new Instance("ImageLabel");
        inst.Name = 'image';
        inst.AnchorPoint = new Vector2(.5, .5);
        inst.Position = UDim2.fromOffset(at.X, at.Y);
        inst.Size = UDim2.fromOffset(this.size.X * scale, this.size.Y * scale);
        inst.Rotation = rotation;
        inst.Transparency = this.transparency;
        inst.Parent = parent;

        return {
            destroy: () => {
                inst.Destroy();
            },
            transform: (_at: Vector2, _rotation: number, _scale: number) => {
                if (_at) {
                    inst.Position = UDim2.fromOffset(_at.X, _at.Y);
                }
                if (_rotation) {
                    inst.Rotation = _rotation;
                }
                if (_scale) {
                    inst.Size = UDim2.fromOffset(this.size.X * _scale, this.size.Y * _scale);
                }
            },
            changeTransparency: (newTransparency: number) => {
                inst.Transparency = this.transparency;
            },
            getInstance: () => {
                return inst;
            }
        }

    }
    spawn(at: Vector3, direction: Vector3, scale: number) {

        let back = new Instance("Part");
        back.Name = 'imageBackdrop'
        back.CanCollide = false;
        back.CanTouch = false;
        back.CanQuery = false;
        back.Anchored = true;
        back.Transparency = 1;

        back.CFrame = CFrame.lookAt(at, at.add(direction));

        back.Size = new Vector3(this.size.X * scale, this.size.Y * scale, 0);

        back.Parent = directory;

        let inst = new Instance('Decal');
        inst.Name = 'image'
        inst.Color3 = this.explicitColor;
        inst.Texture = this.imageId;
        inst.Transparency = this.transparency;
        inst.Parent = back;

        return {
            destroy: () => {
                back.Destroy();
            },
            transform: (_at?: Vector3, _direction?: Vector3, _scale?: number) => {
                if (_at) {
                    back.CFrame = CFrame.lookAt(_at, at.add(back.CFrame.LookVector))
                }
                if (_direction) {
                    back.CFrame = CFrame.lookAt(back.Position, back.Position.add(_direction));
                }
                if (_scale) {
                    back.Size = new Vector3(this.size.X * _scale, this.size.Y * _scale, 0);
                }
            },
            changeTransparency: (newTransparency: number) => {
                inst.Transparency = newTransparency;
            },
            getInstance: () => {
                return back as Part & {
                    image: Decal
                }
            }
        }
    }
}