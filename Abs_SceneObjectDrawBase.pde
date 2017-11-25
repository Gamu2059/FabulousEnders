public abstract class Abs_SceneObjectDrawBase extends Abs_SceneObjectBehavior {
    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public Abs_SceneObjectDrawBase(SceneObject obj) {
        super(obj);

        _colorInfo = new DrawColor();
    }
}