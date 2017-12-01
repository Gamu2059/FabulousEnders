public class SceneObjectImage extends SceneObjectDrawBase {
    private String _usingImageName;
    public String GetUsingImageName() {
        return _usingImageName;
    }
    public void SetUsingImageName(String value) {
        if (value != null) {
            _usingImageName = value;
        }
    }

    private PVector _objSize;

    public SceneObjectImage() {
        super();
    }

    public SceneObjectImage(String imagePath) {
        super();
        SetUsingImageName(imagePath);
    }

    public void Start() {
        _objSize = GetObject().GetTransform().GetSize();
    }

    public void Draw() {
        PImage img = imageManager.GetImage(GetUsingImageName());
        if (img == null) {
            return;
        }
        tint(GetColorInfo().GetColor());
        image(img, 0, 0, _objSize.x, _objSize.y);
    }
}