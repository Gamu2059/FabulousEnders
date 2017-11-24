/**
 キーやマウスの入力の低レベル処理を行うクラス。
 */
public final class InputManager {
    private boolean[] _keys;

    private ActionEvent _mousePressedHandler;
    public ActionEvent GetMousePressedHandler() {
        return _mousePressedHandler;
    }

    private ActionEvent _mouseReleasedHandler;
    public ActionEvent GetMouseReleasedHandler() {
        return  _mouseReleasedHandler;
    }

    private ActionEvent _mouseClickedHandler;
    public ActionEvent GetMouseClickedHandler() {
        return _mouseClickedHandler;
    }

    private ActionEvent _mouseWheelHandler;
    public ActionEvent GetMouseWheelHandler() {
        return _mouseWheelHandler;
    }

    private ActionEvent _mouseMovedHandler;
    public ActionEvent GetMouseMovedHandler() {
        return _mouseMovedHandler;
    }

    private ActionEvent _mouseDraggedHandler;
    public ActionEvent GetMouseDraggedHandler() {
        return _mouseDraggedHandler;
    }

    private ActionEvent _mouseEnteredHandler;
    public ActionEvent GetMouseEnteredHandler() {
        return _mouseEnteredHandler;
    }

    private ActionEvent _mouseExitedHandler;
    public ActionEvent GetMouseExitedHandler() {
        return _mouseExitedHandler;
    }

    private ActionEvent _keyPressedHandler;
    public ActionEvent GetKeyPressedHandler() {
        return _keyPressedHandler;
    }

    private ActionEvent _keyReleasedHandler;
    public ActionEvent GetKeyReleasedHandler() {
        return _keyReleasedHandler;
    }

    public InputManager() {
        _keys = new boolean[Key.KEY_NUM];

        _mousePressedHandler = new ActionEvent();
        _mouseReleasedHandler = new ActionEvent();
        _mouseClickedHandler = new ActionEvent();
        _mouseWheelHandler = new ActionEvent();
        _mouseMovedHandler = new ActionEvent();
        _mouseDraggedHandler = new ActionEvent();
        _mouseEnteredHandler = new ActionEvent();
        _mouseExitedHandler = new ActionEvent();
        _keyPressedHandler = new ActionEvent();
        _keyReleasedHandler = new ActionEvent();

        GetMouseEnteredHandler().AddEvent("Mouse Entered Window", new Event() { 
            public void Event() {
                println("Mouse Enterd on Window!");
            }
        }
        );

        GetMouseExitedHandler().AddEvent("Mouse Exited Window", new Event() {
            public void Event() {
                println("Mouse Exited from Window!");
            }
        }
        );
    }

    // 何かしらのキーが押されたら呼ばれる。
    public void KeyPressed() {
        int code = KeyCode2Key();
        if (code >= 0) {
            _keys[code] = true;
        }

        GetKeyPressedHandler().InvokeAllEvents();
    }

    // 何かしらのキーが離されたら呼ばれる。
    public void KeyReleased() {
        int code = KeyCode2Key();
        if (code >= 0) {
            _keys[code] = false;
        }

        GetKeyReleasedHandler().InvokeAllEvents();
    }

    public void MousePressed() {
        GetMousePressedHandler().InvokeAllEvents();
    }

    public void MouseReleased() {
        GetMouseReleasedHandler().InvokeAllEvents();
    }

    public void MouseClicked() {
        GetMouseClickedHandler().InvokeAllEvents();
    }

    public void MouseWheel() {
        GetMouseWheelHandler().InvokeAllEvents();
    }

    public void MouseMoved() {
        GetMouseMovedHandler().InvokeAllEvents();
    }

    public void MouseDragged() {
        GetMouseDraggedHandler().InvokeAllEvents();
    }

    public void MouseEntered() {
        GetMouseEnteredHandler().InvokeAllEvents();
    }

    public void MouseExited() {
        GetMouseExitedHandler().InvokeAllEvents();
    }

    // これを呼び出した時点で押されている最後のキーのキーコードをKey列挙定数に変換して返す。
    public int KeyCode2Key() {
        switch(keyCode) {
        case UP:
            return Key._UP;
        case DOWN:
            return Key._DOWN;
        case RIGHT:
            return Key._RIGHT;
        case LEFT:
            return Key._LEFT;
        case ENTER:
            return Key._ENTER;
        case ESC:
            return Key._ESC;
        case BACKSPACE:
            return Key._BACK;
        case DELETE:
            return Key._DEL;
        case SHIFT:
            return Key._SHIFT;
        default:
            int k = keyCode;
            if (k >= Key.KEYCODE_0 && k < Key.KEYCODE_0 + 10) {
                // 数字
                return Key._0 + k - Key.KEYCODE_0;
            } else if (k >= Key.KEYCODE_A && k < Key.KEYCODE_A + 26) {
                // アルファベット
                return Key._A + k - Key.KEYCODE_A;
            } else {
                return -1;
            }
        }
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーが押されている状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsPressedKey(int... inputs) {
        for (int i=0; i<inputs.length; i++) {
            if (inputs[i] < 0 || inputs[i] >= Key.KEY_NUM) {
                return false;
            }
            if (!_keys[inputs[i]]) {
                return false;
            }
        }
        return true;
    }
}