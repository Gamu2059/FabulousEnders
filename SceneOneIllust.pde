/**
 背景に配置する一枚絵だけを表示するシーン。
 */
public final class SceneOneIllust extends Scene {
    private SceneObjectImage _backImage;
    public SceneObjectImage GetBackImage() {
        return _backImage;
    }

    public SceneOneIllust() {
        super(SceneID.SID_ILLUST);
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        SceneObject obj = new SceneObject("Background", this);
        _backImage = new SceneObjectImage(obj, null);
    }

    public void OnEnabled() {
        super.OnEnabled();
    }

    public void OnDisabled() {
        super.OnDisabled();
    }
}