public class SceneObjectCursor extends Abs_SceneObjectBehavior {
    /**
     漠然とカーソルが押された時にイベントを発生させる。
     何のキーなのかは問わない。
     */
    private ActionEvent _cursorHandler;
    public ActionEvent GetCursorHandler() {
        return _cursorHandler;
    }

    private ActionEvent _upCursorHandler;
    public ActionEvent GetUpCursorHandler() {
        return _upCursorHandler;
    }

    private ActionEvent _downCursorHandler;
    public ActionEvent GetDownCursorHandler() {
        return _downCursorHandler;
    }

    private ActionEvent _leftCursorHandler;
    public ActionEvent GetLeftCursorHandler() {
        return _leftCursorHandler;
    }

    private ActionEvent _rightCursorHandler;
    public ActionEvent GetRightCursorHandler() {
        return _rightCursorHandler;
    }

    public SceneObjectCursor(SceneObject obj) {
        super(obj);

        _cursorHandler = new ActionEvent();
        _upCursorHandler = new ActionEvent();
        _downCursorHandler = new ActionEvent();
        _leftCursorHandler = new ActionEvent();
        _rightCursorHandler = new ActionEvent();
    }

    public void OnKeyReleased() {
        boolean up, down, left, right;
        up = inputManager.IsClickedKey(Key._UP);
        down = inputManager.IsClickedKey(Key._DOWN);
        left = inputManager.IsClickedKey(Key._LEFT);
        right = inputManager.IsClickedKey(Key._RIGHT);

        if (up || down || left || right) {
            GetCursorHandler().InvokeAllEvents();
            if (up) {
                GetUpCursorHandler().InvokeAllEvents();
            }
            if (down) {
                GetDownCursorHandler().InvokeAllEvents();
            }
            if (left) {
                GetLeftCursorHandler().InvokeAllEvents();
            }
            if (right) {
                GetRightCursorHandler().InvokeAllEvents();
            }
        }
    }
}