public class SceneObjectDrawBase extends SceneObjectBehavior {
    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public SceneObjectDrawBase() {
        _colorInfo = new DrawColor();
    }
}