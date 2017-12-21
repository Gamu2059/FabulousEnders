public class SceneObjectDuration extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DURATION;
    }

    private HashMap<String, ADuration> _durations;
    public HashMap<String, ADuration> GetDurations() {
        return _durations;
    }

    public SceneObjectDuration() {
        super();
        _InitParameterOnConstructor(null);
    }

    public SceneObjectDuration(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }

    private void _InitParameterOnConstructor(SceneObject obj) {
        _durations = new HashMap<String, ADuration>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_durations == null) return;
        for (String label : _durations.keySet()) {
            _durations.get(label).Update();
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDuration is destroyed");
        }
    }
}