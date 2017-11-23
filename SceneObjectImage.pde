/**
 オブジェクトに画像描画処理を与えるビヘイビア。
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

    private DrawColor _imageColor;

    public SceneObjectImage(SceneObject obj) {
        super(obj);
    }
}