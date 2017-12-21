public class SceneObjectTimer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TIMER;
    }

    private HashMap<String, ATimer> _timers;
    public HashMap<String, ATimer> GetTimers() {
        return _timers;
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
        _timers = new HashMap<String, ATimer>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_timers == null) return;
        for (String label : _timers.keySet()) {
            _timers.get(label).Update();
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectTimer is destroyed");
        }
    }
}