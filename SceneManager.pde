public class SceneManager {
    /**
    保持しているシーン。
    */
    private HashMap<String, Scene> _scenes;

    /**
    描画するシーン。
    シーンの優先度によって描画順が替わる。
    */
    private ArrayList<Scene> _drawScenes;

    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }
    private Scene _nextScene;

    private Collection<Scene> _collection;

    private boolean _loadFlag;

    public SceneManager () {
        _scenes = new HashMap<String, Scene>();
        _drawScenes = new ArrayList<Scene>();
        _collection = new Collection<Scene>();
        _InitSceneEvent();
    }

    private void _InitSceneEvent() {
        if (inputManager == null) {
            inputManager = new InputManager();
        }
        inputManager.GetMousePressedHandler().SetEvent("Scene Mouse Pressed", new IEvent() { 
            public void Event() {
                OnMousePressed();
            }
        }
        );
        inputManager.GetMouseReleasedHandler().SetEvent("Scene Mouse Released", new IEvent() {
            public void Event() {
                OnMouseReleased();
            }
        }
        );
        inputManager.GetMouseClickedHandler().SetEvent("Scene Mouse Clicked", new IEvent() {
            public void Event() {
                OnMouseClicked();
            }
        }
        );
        inputManager.GetKeyPressedHandler().SetEvent("Scene Key Pressed", new IEvent() {
            public void Event() {
                OnKeyPressed();
            }
        }
        );
        inputManager.GetKeyReleasedHandler().SetEvent("Scene Key Released", new IEvent() {
            public void Event() {
                OnKeyReleased();
            }
        }
        );
    }

    /**
     ゲームを開始するために一番最初に呼び出す処理。
     setup関数の一番最後に呼び出す必要がある。
     */
    public void Start(String sceneName) {
        _InitScenes();
        LoadScene(sceneName);
        Update();
    }

    /**
     シーンを読み込み、次のフレームからアクティブにさせる。
     */
    public void LoadScene(String sceneName) {
        Scene s = GetScene(sceneName);
        if (s == null) {
            return;
        }

        _nextScene = s;

        _loadFlag = true;
        _nextScene.SetEnabledFlag(true);

        if (_activeScene != null) {
            _activeScene.SetDisabledFlag(true);
        }
    }

    /**
     フレーム更新を行う。
     アクティブシーンのみ処理される。
     */
    public void Update() {
        if (_activeScene != null) {
            _activeScene.Update();
        }
        if (_loadFlag) {
            _ChangeScene();
        }
    }

    /**
     シーンを切り替える。
     シーンの終了処理と開始処理を呼び出す。
     */
    private void _ChangeScene() {
        _loadFlag = false;

        //if (_activeScene != null) {
        //    _activeScene.Disabled();
        //}
        //if (_nextScene != null) {
        //    _nextScene.Enabled();
        //}

        //_activeScene = _nextScene;
        //_nextScene = null;
    }

    /**
     シーンインスタンスを初期化する。
     主にシーン内のソーティングなどである。
     */
    private void _InitScenes() {
        if (_scenes == null) {
            return;
        }

        for (int i=0; i<_scenes.size(); i++) {
            _scenes.get(i).InitScene();
        }
    }

    private void OnMousePressed() {
    }

    private void OnMouseReleased() {
    }

    private void OnMouseClicked() {
    }

    private void OnMouseWheel() {
    }

    private void OnMouseMoved() {
    }

    private void OnMouseDragged() {
    }

    private void OnMouseEntered() {
    }

    private void OnMouseExited() {
    }

    private void OnKeyPressed() {
    }

    private void OnKeyReleased() {
    }

    /**
     自身のリストにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        //if (GetScene(scene.GetName()) != null) {
            return false;
        //}
        //return _scenes.add(scene);
    }

    /**
     自身のリストのindex番目のシーンを返す。
     負数を指定した場合、後ろからindex番目のシーンを返す。
     
     @return index番目のシーン 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene GetScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のシーンを返す。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene GetScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したシーンが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    //public boolean RemoveScene(Scene scene) {
        //return _scenes.remove(scene);
    //}

    /**
     自身のリストのindex番目のシーンを削除する。
     負数を指定した場合、後ろからindex番目のシーンを削除する。
     
     @return index番目のシーン 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene RemoveScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.remove(index);
    }

    /**
     自身のリストの中からnameと一致するシーンを削除する。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene RemoveScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return _scenes.remove(i);
            }
        }
        return null;
    }
}