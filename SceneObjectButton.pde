public class SceneObjectButton extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_BUTTON;
    }
    
    private boolean _isActive;

    private ActionEvent _decideHandler;
    public ActionEvent GetDicideHandler() {
        return _decideHandler;
    }

    public SceneObjectButton() {
        super();

        _decideHandler = new ActionEvent();
    }

    public void OnEnabledActive() {
        super.OnEnabledActive();
        _isActive = true;
    }

    public void OnDisabledActive() {
        super.OnDisabledActive();
        _isActive = false;
    }

    public void Update() {
        if (_isActive) {
            if (inputManager.IsMouseUp()) {
                GetDicideHandler().InvokeAllEvents();
            }
        }
    }
}