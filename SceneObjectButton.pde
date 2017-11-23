/**
 オブジェクトにボタンクリックイベントを与える振る舞い。
 */
public class SceneObjectButton extends Abs_SceneObjectBehavior {
    private ActionEvent _clickHandler;
    public ActionEvent GetClickHandler() {
        return _clickHandler;
    }

    public SceneObjectButton(SceneObject obj) {
        super(obj);

        _clickHandler = new ActionEvent();
    }

    public void OnEnabledActive() {
        println("enabled");
    }

    public void OnDisabledActive() {
        println("disabled");
    }

    public void OnDecided() {
        println("clicked");
    }
}