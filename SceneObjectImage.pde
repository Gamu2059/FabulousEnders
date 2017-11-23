/**
 オブジェクトに画像描画を提供する振る舞い。
 */
public class SceneObjectImage extends Abs_SceneObjectDrawBase {
    private PImage _image;
    public PImage GetImage() {
        return _image;
    }
    public void SetImage(String value) {
        PImage p = imageManager.GetImage(value);
        if (p != null) {
            _image = p;
        }
    }

    private PVector _objSize;

    public SceneObjectImage(SceneObject obj) {
        super(obj);
    }

    public SceneObjectImage(SceneObject obj, String imagePath) {
        super(obj);
        SetImage(imagePath);
    }

    public void Start() {
        _objSize = GetObject().GetTransform().GetSize();
    }

    public void Draw() {
        if (GetImage() == null) {
            return;
        }

        tint(GetColorInfo().GetColor());
        image(GetImage(), 0, 0, _objSize.x, _objSize.y);
    }
}