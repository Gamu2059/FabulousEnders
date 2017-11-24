/**
 オブジェクトにボタンクリックイベントを与える振る舞い。
 */
public class SceneObjectButton extends Abs_SceneObjectBehavior {
    private ActionEvent _decideHandler;
    public ActionEvent GetDicideHandler() {
        return _decideHandler;
    }

    public SceneObjectButton(SceneObject obj) {
        super(obj);

        _decideHandler = new ActionEvent();
    }

    public void OnMouseClicked() {
        GetDicideHandler().InvokeAllEvents();
    }

    public void OnKeyReleased() {
        if (inputManager.IsClickedKey(Key._ENTER)) {
            GetDicideHandler().InvokeAllEvents();
        }
    }
}