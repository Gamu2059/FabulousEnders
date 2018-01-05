public class Scene implements Comparable<Scene> {
    private String _name;
    public String GetName() {
        return _name;
    }

    /**
     ソートするのに用いる。
     */
    private Collection<SceneObject> _collection;

    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    private SceneObjectDrawBack _drawBack;
    public SceneObjectDrawBack GetDrawBack() {
        return _drawBack;
    }

    /**
     描画優先度。
     トランスフォームのものとは使用用途が異なるので分けている。
     */
    private int _scenePriority;
    public int GetScenePriority() {
        return _scenePriority;
    }
    public void SetScenePriority(int value) {
        _scenePriority = value;
    }

    /**
     読込待ちの場合、trueを返す。
     */
    private boolean _isLoadFlag;
    public final boolean IsLoadFlag() {
        return _isLoadFlag;
    }
    public final void Load() {
        _isLoadFlag = true;
    }

    /**
     解放待ちの場合、trueを返す。
     */
    private boolean _isReleaseFlag;
    public final boolean IsReleaseFlag() {
        return _isReleaseFlag;
    }
    public final void Release() {
        _isReleaseFlag = true;
    }

    /**
     オブジェクトの優先度変更が発生している場合はtrueになる。
     これがtrueでなければソートはされない。
     */
    private boolean _isNeedSorting;
    public void SetNeedSorting(boolean value) {
        _isNeedSorting = value;
    }

    public Scene (String name) {
        _name = name;
        _collection = new Collection<SceneObject>();
        _objects = new ArrayList<SceneObject>();

        _transform = new SceneObjectTransform();
        _drawBack = new SceneObjectDrawBack();
    }

    /**
     シーンの初期化を行う。
     ゲーム開始時に呼び出される。
     */
    public void InitScene() {
        _isNeedSorting = true;
        Sorting();
    }

    /**
     シーンマネージャの描画リストに追加された時に呼び出される。
     */
    public void OnEnabled() {
        _isLoadFlag = false;
        _OnStart();
    }

    /**
     シーンマネージャの描画リストから外された時に呼び出される。
     */
    public void OnDisabled() {
        _isReleaseFlag = false;
        _OnStop();
    }

    /**
     シーンマネージャのアクティブシーンになった時に呼び出される。
     */
    public void OnEnabledActive() {
        CheckMouseActiveObject();
    }

    /**
     シーンマネージャのノンアクティブシーンになった時に呼び出される。
     */
    public void OnDisabledActive() {
        if (_activeObject != null) {
            _activeObject.OnDisabledActive();
            _activeObject = null;
        }
    }

    public boolean IsAbleActiveScene() {
        return _transform.IsInRegion(mouseX, mouseY);
    }

    public void Update() {
        _OnStart();
        _OnUpdate();
    }

    /**
     フレームの最初に呼び出される。
     Stopと異なり、オブジェクトごとにタイミングが異なるのでフレーム毎に呼び出される。
     */
    protected void _OnStart() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Start();
            }
        }
    }

    /**
     フレームの最後に呼び出される。
     一度しか呼び出されない。
     オブジェクトの有効フラグに関わらず必ず呼び出す。
     */
    protected void _OnStop() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            s.Stop();
        }
    }

    /**
     毎フレーム呼び出される。
     入力待ちやオブジェクトのアニメーション処理を行う。
     */
    protected void _OnUpdate() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Update();
            }
        }
    }

    /**
     オブジェクトのトランスフォームの優先度によってソートする。
     毎度処理していると重くなるのフラグが立っている時のみ処理する。
     */
    public void Sorting() {
        if (!_isNeedSorting) return;
        _isNeedSorting = false;
        _collection.SortList(GetObjects());
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     ただし、マウス操作している時だけしか判定しない。
     */
    public void CheckMouseActiveObject() {
        if (!inputManager.IsMouseMode()) return;
        SceneObject s;
        boolean f = false;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsAbleActiveObject()) {
                f = true;
                // 現在のMAOが次のMAOになるならば、何もせずに処理を終わる。
                if (s == _activeObject) return;

                if (_activeObject != null) {
                    _activeObject.OnDisabledActive();
                }
                _activeObject = s;
                _activeObject.OnEnabledActive();
                return;
            }
        }
        // 何もアクティブにならなければアクティブオブジェクトも無効化する
        if (!f) {
            if (_activeObject != null) {
                _activeObject.OnDisabledActive();
            }
            _activeObject = null;
        }
    }

    /**
     ドローバックとイメージ系の振る舞いを持つオブジェクトの描画を行う。
     */
    public void Draw() {
        _DrawScene();

        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Draw();
            }
        }
    }

    /**
     シーン背景を描画する。
     */
    private void _DrawScene() {
        noStroke();
        fill(GetDrawBack().GetBackColorInfo().GetColor());
        GetTransform().GetTransformProcessor().TransformProcessing();
        PVector s = GetTransform().GetSize();
        rect(0, 0, s.x, s.y);
    }

    /**
     毎回オブジェクトのSetParentを呼び出すのが面倒なので省略のために用意。
     */
    public final void AddChild(SceneObject o) {
        if (o == null) return;

        o.GetTransform().SetParent(GetTransform(), true);
    }

    /**
     自身のリストにオブジェクトを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) return false;
        object.SetScene(this);
        return _objects.add(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを返す。
     負数を指定した場合、後ろからindex番目のオブジェクトを返す。
     
     @return index番目のオブジェクト 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject GetObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のオブジェクトを返す。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject GetObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したオブジェクトが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public final boolean RemoveObject(SceneObject object) {
        return _objects.remove(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを削除する。
     負数を指定した場合、後ろからindex番目のオブジェクトを削除する。
     
     @return index番目のオブジェクト 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject RemoveObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.remove(index);
    }

    /**
     自身のリストの中からnameと一致するオブジェクトを削除する。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject RemoveObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return _objects.remove(i);
            }
        }
        return null;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (!(o instanceof Scene)) {
            return false;
        }
        Scene s = (Scene) o;
        return GetName().equals(s.GetName());
    }

    public int compareTo(Scene o) {
        return GetScenePriority() - o.GetScenePriority();
    }
}