public class SceneObjectDragHandler extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DRAG_HANDLER;
    }

    private boolean _isActive, _isDragging;
    private String _eventLabel;

    private ActionEvent _draggedActionHandler;
    public ActionEvent GetDraggedActionHandler() {
        return _draggedActionHandler;
    }

    private ActionEvent _enabledActiveHandler;
    public ActionEvent GetEnabledActiveHandler() {
        return _enabledActiveHandler;
    }

    private ActionEvent _disabledActiveHandler;
    public ActionEvent GetDisabledActiveHandler() {
        return _disabledActiveHandler;
    }

    public SceneObjectDragHandler(String eventLabel) {
        super();

        _eventLabel = eventLabel;
        _draggedActionHandler = new ActionEvent();
        _enabledActiveHandler = new ActionEvent();
        _disabledActiveHandler = new ActionEvent();
    }

    public void OnEnabledActive() {
        super.OnEnabledActive();
        _isActive = true;
        GetEnabledActiveHandler().InvokeAllEvents();
    }

    public void OnDisabledActive() {
        super.OnDisabledActive();
        _isActive = false;
        GetDisabledActiveHandler().InvokeAllEvents();
    }

    public void Start() {
        super.Start();
        inputManager.GetMouseDraggedHandler().AddEvent(_eventLabel, new IEvent() {
            public void Event() {
                if (!_isDragging) return;
                GetDraggedActionHandler().InvokeAllEvents();
            }
        }
        );
    }

    public void Update() {
        super.Update();

        if (_isActive) {
            if (inputManager.IsMouseDown()) {
                _isDragging = true;
            }
        }
        if (inputManager.IsMouseUp()) {
            _isDragging = false;
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDragHandler is destroyed");
        }
    }
}