public class SceneObjectTimer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TIMER;
    }
    
    private float _runSecond;
    
    private ActionEvent _event;
    public ActionEvent GetActionEvent() {
        return _event;
    }
    
    public SceneObjectTimer() {
        super();
        _InitParameterOnConstructor(null);
    }
    
    public SceneObjectTimer(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }
    
    private void _InitParameterOnConstructor(SceneObject obj) {
        _runSecond = 0;
        _event = new ActionEvent();
        if (obj == null) return;
        obj.AddBehavior(this);
    }
    
    public void Update() {
        super.Update();
        
        if (_runSecond <= 0) return;
        _runSecond -= 1/frameRate;
        if (_runSecond <= 0 && _event != null) {
            _event.InvokeAllEvents();
        }
    }
    
    public void ResetTimer(float runSecond) {
        _runSecond = runSecond;
    }
    
    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectTimer is destroyed");
        }
    }
}