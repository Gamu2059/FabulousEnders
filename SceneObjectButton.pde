public class SceneObjectButton extends SceneObjectBehavior {
    private ActionEvent _decideHandler;
    public ActionEvent GetDicideHandler() {
        return _decideHandler;
    }

    public SceneObjectButton() {
        super();

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