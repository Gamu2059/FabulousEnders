public class SceneObjectImage extends SceneObjectDrawBase {
    public int GetID() {
        return ClassID.CID_IMAGE;
    }
    
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
    
    public SceneObjectImage(SceneObject o, String imagePath) {
        super();
        SetUsingImageName(imagePath);
        if (o == null) return;
        o.AddBehavior(this);
    }

    public void Start() {
        super.Start();
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