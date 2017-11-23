/**
 シーンを管理するためのマネージャクラス。
 */
public final class SceneManager extends Abs_Manager {
    private ArrayList<Scene> _scenes;
    public ArrayList<Scene> GetScenes() {
        return _scenes;
    }

    /**
     現在描画されているシーン。
     */
    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }
    /**
     次にアクティブになるシーン。
     */
    private Scene _nextScene;

    /**
     シーンの読込要求が出された場合にtrueになる。
     */
    private boolean _loadFlag;

    public SceneManager () {
        super();
        _scenes = new ArrayList<Scene>();
    }

    /**
     ゲームを開始するために一番最初に呼び出す処理。
     setup関数の一番最後に呼び出す必要がある。
     */
    public void Start(String sceneName) {
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

        if (_activeScene != null) {
            _activeScene.Disabled();
        }
        if (_nextScene != null) {
            _nextScene.Enabled();
        }

        _activeScene = _nextScene;
        _nextScene = null;
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

    /**
     自身のリストにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        if (GetScene(scene.GetName()) != null) {
            return false;
        }
        return _scenes.add(scene);
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
    public boolean RemoveScene(Scene scene) {
        return _scenes.remove(scene);
    }

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

    /**
     自分以外は全てfalseを返す。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\n").append(getClass().getSimpleName()).append(" :\n");
        b.append(_scenes);
        return b.toString();
    }
}