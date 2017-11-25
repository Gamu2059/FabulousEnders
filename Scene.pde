public class Scene extends SceneObject {
    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    /**
     次のフレームからアクティブになる場合にtrueになる。
     */
    private boolean _enabledFlag;
    public final void SetEnabledFlag(boolean value) {
        _enabledFlag = value;
    }
    /**
     次のフレームからノンアクティブになる場合にtrueになる。
     */
    private boolean _disabledFlag;
    public final void SetDisabledFlag(boolean value) {
        _disabledFlag = value;
    }

    /**
     オブジェクトの優先度変更が発生している場合はtrueになる。
     これがtrueでなければソートはされない。
     */
    private boolean _isNeedSorting;
    public void SetNeedSorting(boolean value) {
        _isNeedSorting = value;
    }

    /**
     シーンにのみ特別にスケール値を与える。
     */
    private PVector _sceneScale;
    public PVector GetSceneScale() {
        return _sceneScale;
    }
    public void SetSceneScale(PVector value) {
        if (value != null) {
            _sceneScale = value;
        }
    }
    public void SetSceneScale(float value1, float value2) {
        _sceneScale.set(value1, value2);
    }

    public Scene (String name) {
        super(name);
        _objects = new ArrayList<SceneObject>();
        _sceneScale = new PVector(1, 1);
        sceneManager.AddScene(this);
    }


    /**
     シーンの初期化を行う。
     ゲーム開始時に呼び出される。
     */
    public void InitScene() {
        _isNeedSorting = true;
        _Sorting();
    }

    /**
     　アクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Enabled() {
        _enabledFlag = false;
    }

    /**
     ノンアクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Disabled() {
        _disabledFlag = false;
        _Stop();
    }


    /**
     毎フレームのシーン更新処理。
     */
    public void Update() {
        _ResetBackGround();
        _Start();
        _Update();
        _Animation();
        _ResetMatrix();
        _Transform();
        _Sorting();
        _CheckMAO();
        _Draw();
    }

    protected void _ResetBackGround() {
        background(0);
    }

    /**
     フレームの最初に呼び出される。
     _Stopと異なり、オブジェクトごとにタイミングが異なるのでフレーム毎に呼び出される。
     */
    protected void _Start() {
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
    protected void _Stop() {
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
    protected void _Update() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Update();
            }
        }
    }

    /**
     _Updateとは異なり、AnimationBehaviorによる高度なフレームアニメーションを行う。
     主に子オブジェクトのアニメーションや画像連番表示を処理するのに用いる。
     */
    protected void _Animation() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.GetBehavior(SceneObjectAnimationController.class) != null) {
                s.Animation();
            }
        }
    }

    /**
     アフィン行列を初期化する。
     */
    protected void _ResetMatrix() {
        while (matrixManager.PopMatrix());
        resetMatrix();
    }

    /**
     シーンの平行移動と回転を行う。
     */
    public void TransformScene() {
        PVector p = GetTransform().GetPosition();
        resetMatrix();
        scale(GetSceneScale().x, GetSceneScale().y);
        translate(p.x, p.y);
        rotate(GetTransform().GetRotate());
    }

    /**
     オブジェクトを移動させる。
     ここまでに指示されたトランスフォームの移動は、全てここで処理される。
     それ以降のトランスフォーム処理は無視される。
     */
    protected void _Transform() {
        TransformScene();

        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsChildOf(this)) {
                s.GetTransform().Transform();
            }
        }
    }

    /**
     オブジェクトのトランスフォームの優先度によってソートする。
     毎度処理していると重くなるのフラグが立っている時のみ処理する。
     */
    protected void _Sorting() {
        if (!_isNeedSorting) {
            return;
        }
        _isNeedSorting = false;
        Collections.sort(_objects);
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     ただし、マウス操作している時だけしか判定しない。
     */
    protected void _CheckMAO() {
        if (!inputManager.IsMouseMode()) {
            return;
        }

        SceneObject s;
        boolean f = false;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsAbleAO()) {
                if (s == _activeObject) {
                    // 現在のMAOが次のMAOになるならば、何もせずに処理を終わる。
                    return;
                }
                f = true;

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
    protected void _Draw() {
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
        fill(GetDrawBack().GetBackColorInfo().GetColor());
        TransformScene();
        PVector s = GetTransform().GetSize();
        rect(0, 0, s.x, s.y);
    }

    private boolean _CheckDisableMAO() {
        if (GetActiveObject() == null) {
            return true;
        }
        return !GetActiveObject().IsEnable();
    }

    public void OnMousePressed() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMousePressed();
    }

    public void OnMouseReleased() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMouseReleased();
    }

    public void OnMouseClicked() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMouseClicked();
    }

    public void OnKeyPressed() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnKeyPressed();
    }

    public void OnKeyReleased() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnKeyReleased();
    }

    /**
     自身のリストにオブジェクトを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) {
            return false;
        }
        object.GetTransform().SetParent(GetTransform(), true);
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
        }
        if (o == null) {
            return false;
        }
        if (!(o instanceof Scene)) {
            return false;
        }
        Scene s = (Scene) o;
        return GetName().equals(s.GetName());
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" \n");
        b.append("  name : ").append(GetName()).append(" \n");
        b.append("  objects :\n");
        b.append(_objects).append(" \n");

        return b.toString();
    }
}