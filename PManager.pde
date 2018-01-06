public final class InputManager {
    private boolean[] _pressedKeys;
    private boolean[] GetPressedKeys() {
        return _pressedKeys;
    }

    private boolean[] _clickedKeys;
    private boolean[] GetClickedKeys() {
        return _clickedKeys;
    }


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

    private ActionEvent _keyClickedHandler;
    public ActionEvent GetKeyClickedHandler() {
        return _keyClickedHandler;
    }

    /**
     マウス操作を何かしら行った場合、trueになる。
     キー操作を何かしら行った場合、falseになる。
     */
    private boolean _isMouseMode;
    public boolean IsMouseMode() {
        return _isMouseMode;
    }
    private void SetMouseMode(boolean value) {
        _isMouseMode = value;
    }

    private boolean _isMousePressed, _preMousePressed;

    public InputManager() {
        _pressedKeys = new boolean[Key.KEY_NUM];
        _clickedKeys = new boolean[Key.KEY_NUM];

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
        _keyClickedHandler = new ActionEvent();

        _InitInputEvent();
    }

    private void _InitInputEvent() {
        GetMouseEnteredHandler().GetEvents().Add("Mouse Entered Window", new IEvent() { 
            public void Event() {
                if (isProcessing) {
                    println("Mouse Enterd on Window!");
                }
            }
        }
        );

        GetMouseExitedHandler().GetEvents().Add("Mouse Exited Window", new IEvent() {
            public void Event() {
                if (isProcessing) {
                    println("Mouse Exited from Window!");
                }
            }
        }
        );
    }

    /**
     シーンマネージャの後に呼び出される必要がある。
     */
    public void Update() {
        _preMousePressed = _isMousePressed;
    }

    public void KeyPressed() {
        SetMouseMode(false);
        int code = KeyCode2Key();
        if (code >= 0 && code < Key.KEY_NUM) {
            GetPressedKeys()[code] = true;
        }

        GetKeyPressedHandler().InvokeAllEvents();
    }

    public void KeyReleased() {
        SetMouseMode(false);
        int code = KeyCode2Key();
        if (code >= 0 && code < Key.KEY_NUM) {
            GetPressedKeys()[code] = false;
            GetClickedKeys()[code] = true;
        }

        GetKeyReleasedHandler().InvokeAllEvents();
        GetKeyClickedHandler().InvokeAllEvents();

        // クリックされたキーの判定は同フレームで消滅させる
        if (code >= 0 && code < Key.KEY_NUM) {
            GetClickedKeys()[code] = false;
        }
    }

    public void MousePressed() {
        _isMousePressed = true;
        SetMouseMode(true);
        GetMousePressedHandler().InvokeAllEvents();
    }

    public void MouseReleased() {
        _isMousePressed = false;
        SetMouseMode(true);
        GetMouseReleasedHandler().InvokeAllEvents();
    }

    public void MouseClicked() {
        SetMouseMode(true);
        GetMouseClickedHandler().InvokeAllEvents();
    }

    public void MouseWheel() {
        SetMouseMode(true);
        GetMouseWheelHandler().InvokeAllEvents();
    }

    public void MouseMoved() {
        SetMouseMode(true);
        GetMouseMovedHandler().InvokeAllEvents();
    }

    public void MouseDragged() {
        SetMouseMode(true);
        GetMouseDraggedHandler().InvokeAllEvents();
    }

    public void MouseEntered() {
        SetMouseMode(true);
        GetMouseEnteredHandler().InvokeAllEvents();
    }

    public void MouseExited() {
        SetMouseMode(true);
        GetMouseExitedHandler().InvokeAllEvents();
    }

    /**
     これを呼び出した時点で押されている最後のキーのキーコードをKey列挙定数に変換して返す。
     */
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

    private boolean _CheckOutOfKeyBounds(int i) {
        return i < 0 || i >= Key.KEY_NUM;
    }

    /**
     引数で与えられた列挙定数のキーが押されている状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsPressedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetPressedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーだけが押されている状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsPressedKeyOnly(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (i == input) {
                continue;
            } else if (GetPressedKeys()[i]) {
                return false;
            }
        }
        return GetPressedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーがクリックされた状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsClickedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetClickedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーだけがクリックされた状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsClickedKeyOnly(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (i == input) {
                continue;
            } else if (GetClickedKeys()[i]) {
                return false;
            }
        }
        return GetClickedKeys()[input];
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーが押されている状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsPressedKeys(int[] inputs) {
        if (inputs == null) {
            return false;
        }
        for (int i=0; i<inputs.length; i++) {
            if (_CheckOutOfKeyBounds(inputs[i])) {
                return false;
            } else if (!GetPressedKeys()[inputs[i]]) {
                return false;
            }
        }
        return true;
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーがクリックされた状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsClickedKeys(int[] inputs) {
        if (inputs == null) {
            return false;
        }
        for (int i=0; i<inputs.length; i++) {
            if (_CheckOutOfKeyBounds(inputs[i])) {
                return false;
            } else if (!GetClickedKeys()[inputs[i]]) {
                return false;
            }
        }
        return true;
    }

    public boolean IsMouseDown() {
        return _isMousePressed && !_preMousePressed;
    }

    public boolean IsMouseStay() {
        return _isMousePressed && _preMousePressed;
    }

    public boolean IsMouseUp() {
        return !_isMousePressed && _preMousePressed;
    }
}

public final class FontManager {
    private HashMap<String, PFont> _fonts;
    private HashMap<String, PFont> GetFontHash() {
        return _fonts;
    }

    public FontManager() {
        _fonts = new HashMap<String, PFont>();
    }

    public PFont GetFont(String path) {
        if (GetFontHash().containsKey(path)) {
            return GetFontHash().get(path);
        }
        PFont font =  createFont(path, 100, true);
        if (font != null) {
            GetFontHash().put(path, font);
        }
        return font;
    }
}

public final class ImageManager {
    private HashMap<String, PImage> _images;
    private HashMap<String, PImage> GetImageHash() {
        return _images;
    }

    public ImageManager() {
        _images = new HashMap<String, PImage>();
    }

    public PImage GetImage(String path) {
        path = PConst.IMAGE_PATH + path;
        if (GetImageHash().containsKey(path)) {
            return GetImageHash().get(path);
        }
        PImage image = requestImage(path);
        if (image != null) {
            GetImageHash().put(path, image);
        }
        return image;
    }
}

public class TransformManager {
    public static final int MAX_DEPTH = 32;

    private int _depth;

    public TransformManager() {
        _depth = 0;
    }

    public boolean PushDepth() {
        if (_depth >= MAX_DEPTH) return false;
        _depth++;
        return true;
    }

    public boolean PopDepth() {
        if (_depth < 0) return false;
        _depth--;
        return true;
    }

    public void ResetDepth() {
        _depth = 0;
    }
}

public class SceneManager {
    /**
     保持しているシーン。
     */
    private HashMap<String, Scene> _scenes;
    public HashMap<String, Scene> GetScenes() {
        return _scenes;
    }

    /**
     実際に描画するシーンのリスト。
     シーンの優先度によって描画順が替わる。
     */
    private ArrayList<Scene> _drawScenes;
    public ArrayList<Scene> GetDrawScenes() {
        return _drawScenes;
    }

    /**
     入力を受け付けることができるシーン。
     */
    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }

    /**
     ソートに用いる。
     */
    private Collection<Scene> _collection;

    private SceneObjectTransform _transform, _dummyTransform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    public SceneManager () {
        _scenes = new HashMap<String, Scene>();
        _drawScenes = new ArrayList<Scene>();
        _collection = new Collection<Scene>();

        _transform = new SceneObjectTransform();
        _transform.SetSize(width, height);
        _transform.SetPivot(0, 0);

        _dummyTransform = new SceneObjectTransform();
    }

    /**
     シーンマップから描画シーンリストにシーンを追加する。
     */
    public void LoadScene(String sceneName) {
        // シーンマップに存在しないなら何もしない
        if (!_scenes.containsKey(sceneName)) return;
        Scene s = _scenes.get(sceneName);

        // 既に描画リストに存在するなら何もしない
        if (_drawScenes.contains(s)) return;

        s.Load();
    }

    /**
     描画シーンリストからシーンを外す。
     */
    public void ReleaseScene(String sceneName) {
        // シーンマップに存在しないなら何もしない
        if (!_scenes.containsKey(sceneName)) return;
        Scene s = _scenes.get(sceneName);

        // 描画リストに存在しないなら何もしない
        if (!_drawScenes.contains(s)) return;        

        s.Release();
    }

    /**
     描画シーンを全て外す。
     */
    public void ReleaseAllScenes() {
        for (int i=0; i<_drawScenes.size(); i++) {
            ReleaseScene(_drawScenes.get(i).GetName());
        }
    }

    public void Start() {
        _InitScenes();
    }

    /**
     フレーム更新を行う。
     */
    public void Update() {
        _OnUpdate();
        _OnTransform();
        _OnSorting();
        _OnCheckMouseActiveScene();
        _OnDraw();
        _OnCheckScene();
    }

    private void _OnUpdate() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Update();
        }
    }

    private void _OnTransform() {

        GetTransform().TransformMatrixOnRoot();
    }

    private void _OnSorting() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Sorting();
        }
    }

    private void _OnCheckMouseActiveScene() {
        if (!inputManager.IsMouseMode()) return;
        if (_drawScenes == null) return;
        Scene s;
        boolean f = false;
        for (int i=_drawScenes.size()-1; i>=0; i--) {
            s = _drawScenes.get(i);
            if (s.IsAbleActiveScene()) {
                f = true;
                // 現在のASが次のASになるならば、何もせずに処理を終わる。
                if (s == _activeScene) break;

                if (_activeScene != null) {
                    _activeScene.OnDisabledActive();
                }
                _activeScene = s;
                _activeScene.OnEnabledActive();
                return;
            }
        }
        // 何もアクティブにならなければアクティブシーンも無効化する
        if (!f) {
            if (_activeScene != null) {
                _activeScene.OnDisabledActive();
                _activeScene = null;
            }
        }
        if (_activeScene != null) {
            _activeScene.CheckMouseActiveObject();
        }
    }

    private void _OnDraw() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Draw();
        }
    }

    /**
     シーンの読込と解放を処理する。
     */
    private void _OnCheckScene() {
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            if (!s.IsReleaseFlag()) continue;

            _drawScenes.remove(s);
            s.OnDisabled();
            s.GetTransform().SetParent(_dummyTransform, false);
        }
        boolean f = false;
        for (String n : _scenes.keySet()) {
            s = _scenes.get(n);
            if (!s.IsLoadFlag()) continue;

            _drawScenes.add(s);
            s.OnEnabled();
            s.GetTransform().SetParent(_transform, false);
            f = true;
        }
        if (f) {
            _collection.SortList(_drawScenes);
        }
    }

    /**
     シーンインスタンスを初期化する。
     主にシーンそのもののソーティングと、シーン内のソーティングなどである。
     */
    private void _InitScenes() {
        if (_scenes == null) return;
        Scene s;
        for (String name : _scenes.keySet()) {
            s = _scenes.get(name);
            s.InitScene();
        }

        if (_drawScenes == null) return;
        _collection.SortList(_drawScenes);
    }

    /**
     シーンマップにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        if (scene == null) return false;
        if (GetScene(scene.GetName()) != null) return false;
        _scenes.put(scene.GetName(), scene);
        scene.GetTransform().SetParent(_dummyTransform, false);
        return true;
    }

    /**
     シーンマップの中からnameと一致する名前のシーンを返す。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene GetScene(String name) {
        return _scenes.get(name);
    }

    /**
     シーンマップの中からnameと一致するシーンを削除する。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene RemoveScene(String name) {
        return _scenes.remove(name);
    }
}