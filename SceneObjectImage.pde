/**
 オブジェクトに画像描画処理を与えるビヘイビア。
 */
public class SceneObjectImage extends Abs_SceneObjectBehavior {
    private PImage _image;
    public PImage GetImage() {
        return _image;
    }
    public void SetImage(PImage value) {
     _image = value;   
    }

    public SceneObjectImage(SceneObject obj) {
        super(obj);
    }
}