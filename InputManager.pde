/**
 キーやマウスの入力の低レベル処理を行うクラス。
 */
public final class InputManager extends Abs_Manager {
    private boolean[] _keys;


    public InputManager() {
        super();
        _keys = new boolean[Key.KEY_NUM];
    }

    // 何かしらのキーが押されたら呼ばれる。
    public void KeyPressed() {
        int code = KeyCode2Key();
        if (code >= 0) {
            _keys[code] = true;
        }
    }

    // 何かしらのキーが離されたら呼ばれる。
    public void KeyReleased() {
        int code = KeyCode2Key();
        if (code >= 0) {
            _keys[code] = false;
        }
    }

    public void MousePressed() {
    }

    public void MouseReleased() {
    }

    public void MouseClicked() {
    }

    public void MouseWheel() {
    }

    public void MouseMoved() {
    }

    public void MouseDragged() {
    }

    public void MouseEntered() {
    }

    public void MouseExited() {
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