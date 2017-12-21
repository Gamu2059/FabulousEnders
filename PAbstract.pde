public abstract class AEventActivator {    
    protected float _timer;
    protected boolean _isActive;
    protected boolean _isBeginning;
    
    public abstract void OnInit();
    public abstract void OnEnd();
    public abstract void Update();

    public void ResetTimer(float t) {
        _timer = t;
    }
    public void Start() {
        _isActive = true;
        if (!_isBeginning) {
            _isBeginning = true;
            OnInit();
        }
    }
    public void Stop() {
        _isActive = false;
    }
    protected void End() {
        _isActive = false;
        if (_isBeginning) {
            _isBeginning = false;
            OnEnd();
        }
    }
}

public abstract class ATimer extends AEventActivator {
    public void Update() {
        if (!_isActive || !_isBeginning) return;
        _timer -= 1/frameRate;
        if (_timer <= 0) {
            End();
        }
    }
}

public abstract class ADuration {
    protected float _timer;
    protected boolean _isActive;
    protected boolean _isBeginning;
    
    public abstract void OnInit();
    public abstract void OnEnd();

    public void ResetTimer(float t) {
        _timer = t;
    }
    public void Start() {
        _isActive = true;
        if (!_isBeginning) {
            _isBeginning = true;
            OnInit();
        }
    }
    public void Stop() {
        _isActive = false;
    }
    protected void End() {
        _isActive = false;
        if (_isBeginning) {
            _isBeginning = false;
            OnEnd();
        }
    }
    
    public abstract void OnUpdate();
    public abstract boolean IsContinue();
    
    public void Update() {
        if (!_isActive || !_isBeginning) return;
        _timer -= 1/frameRate;
        if (!IsContinue()) {
            End();
            return;
        }
        OnUpdate();
    }
}