public final class TimerInfo {
    public float settedTime;
    public float currentTime;
    public boolean useTimer;
    public boolean haveBegun;
    public boolean isActive;
}

public class SceneObjectTimer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TIMER;
    }

    private PHash<ITimer> _timers;
    public PHash<ITimer> GetTimers() {
        return _timers;
    }
    private PHash<TimerInfo> _infos;

    public SceneObjectTimer() {
        super();
        _InitParameterOnConstructor(null);
    }

    public SceneObjectTimer(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }

    private void _InitParameterOnConstructor(SceneObject obj) {
        _timers = new PHash<ITimer>();
        _infos = new PHash<TimerInfo>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_timers == null) return;
        TimerInfo i;
        for (String label : _timers.GetElements().keySet()) {
            if (!_IsContainsKey(label)) continue;
            i = _infos.Get(label);
            if (!i.isActive || !i.haveBegun) continue;
            i.settedTime -= 1/frameRate;
            if (i.settedTime <= 0) {
                End(label);
            }
        }
    }

    public void Stop() {
        super.Stop();
        for (String label : _infos.GetElements().keySet()) {
            End(label);
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectTimer is destroyed");
        }
    }

    //////////////////////////////////////////
    // 以下、操作系メソッド
    //////////////////////////////////////////

    private boolean _IsContainsKey(String label) {
        return _timers.ContainsKey(label) && _infos.ContainsKey(label);
    }

    private TimerInfo _GetTimerInfo(String label) {
        TimerInfo i = _infos.Get(label);
        if (i == null) {
            i = new TimerInfo();
            _infos.Add(label, i);
        }
        return i;
    }

    public void ResetTimer(String label, float timer) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.settedTime = timer;
    }

    public void Start(String label) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = true;
        if (!i.haveBegun) {
            i.haveBegun = true;
            _timers.Get(label).OnInit();
        }
    }

    public void Stop(String label) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = false;
    }

    public void End(String label) {
        if (!_infos.ContainsKey(label)) return;
        TimerInfo i = _infos.Get(label);
        i.isActive = false;
        i.haveBegun = false;
        _timers.Get(label).OnTimeOut();
    }
}

public class SceneObjectDuration extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DURATION;
    }

    private PHash<IDuration> _durations;
    public PHash<IDuration> GetDurations() {
        return _durations;
    }
    private PHash<TimerInfo> _infos;

    public SceneObjectDuration() {
        super();
        _InitParameterOnConstructor(null);
    }

    public SceneObjectDuration(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }

    private void _InitParameterOnConstructor(SceneObject obj) {
        _durations = new PHash<IDuration>();
        _infos = new PHash<TimerInfo>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_durations == null) return;
        TimerInfo i;
        IDuration d;
        boolean f;
        for (String label : _durations.GetElements().keySet()) {
            if (!_IsContainsKey(label)) continue;
            i = _infos.Get(label);
            d = _durations.Get(label);
            if (!i.isActive || !i.haveBegun) continue;

            if (i.useTimer) {
                i.currentTime -= 1/frameRate;
                f = i.currentTime <= 0;
            } else {
                f = !d.IsContinue();
            }
            if (f) {
                End(label);
                return;
            }
            d.OnUpdate();
        }
    }

    public void Stop() {
        super.Stop();
        for (String label : _infos.GetElements().keySet()) {
            End(label);
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDuration is destroyed");
        }
    }

    //////////////////////////////////////////
    // 以下、操作系メソッド
    //////////////////////////////////////////

    private boolean _IsContainsKey(String label) {
        return _durations.ContainsKey(label) && _infos.ContainsKey(label);
    }

    private TimerInfo _GetTimerInfo(String label) {
        TimerInfo i = _infos.Get(label);
        if (i == null) {
            i = new TimerInfo();
            _infos.Add(label, i);
        }
        return i;
    }

    public void ResetTimer(String label, float timer) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.settedTime = timer;
        i.currentTime = timer;
        Stop(label);
    }

    public float GetSettedTimer(String label) {
        if (!_durations.ContainsKey(label)) return 0;
        TimerInfo i = _GetTimerInfo(label);
        return i.settedTime;
    }

    public void SetUseTimer(String label, boolean useTimer) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.useTimer = useTimer;
    }

    public void Start(String label) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = true;
        if (!i.haveBegun) {
            i.haveBegun = true;
            _durations.Get(label).OnInit();
        }
    }

    public void Stop(String label) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = false;
    }

    public void End(String label) {
        if (!_infos.ContainsKey(label)) return;
        TimerInfo i = _infos.Get(label);
        i.isActive = false;
        i.haveBegun = false;
        _durations.Get(label).OnEnd();
    }
}