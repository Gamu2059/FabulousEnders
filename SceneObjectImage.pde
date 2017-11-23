/**
 オブジェクトに画像描画を提供する振る舞い。
 */
public class SceneObjectImage extends Abs_SceneObjectBehavior {
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

    private DrawColor _imageColorInfo;
    public DrawColor GetImageColorInfo() {
        return _imageColorInfo;
    }

    public SceneObjectImage(SceneObject obj) {
        super(obj);

        _imageColorInfo = new DrawColor(true, DrawColor.MAX_RED, DrawColor.MAX_GREEN, DrawColor.MAX_BLUE);
    }

    public SceneObjectImage(SceneObject obj, String imagePath) {
        super(obj);

        _imageColorInfo = new DrawColor(true, DrawColor.MAX_RED, DrawColor.MAX_GREEN, DrawColor.MAX_BLUE);
        SetImage(imagePath);
    }

    public void Draw() {
        if (GetImage() == null) {
            return;
        }
        PVector size = GetObject().GetTransform().GetSize();
        tint(GetImageColorInfo().GetColor());
        image(GetImage(), 0, 0, size.x, size.y);
    }
}