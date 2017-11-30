public class SceneObject implements Comparable<SceneObject> {
    private String _name;
    public String GetName() {
        return _name;
    }

    private ArrayList<SceneObjectBehavior> _behaviors;
    public ArrayList<SceneObjectBehavior> GetBehaviors() {
        return _behaviors;
    }

    /**
     オブジェクトは一回だけシーンを設定することができる。
     */
    private Scene _scene;
    public Scene GetScene() {
        return _scene;
    }
    public void SetScene(Scene value) {
        if (_isSettedScene) return;
        if (value == null) return;
        _isSettedScene = true;
        _scene = value;
    }
    private boolean _isSettedScene;

    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    private SceneObjectDrawBack _drawBack;
    public SceneObjectDrawBack GetDrawBack() {
        return _drawBack;
    }

    /**
     オブジェクトとして有効かどうかを管理するフラグ。
     */
    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public void SetEnable(boolean value) {
        _enable = value;
        if (_enable) {
            _OnEnable();
        } else {
            _OnDisable();
        }
    }

    /**
     falseの場合、アクティブオブジェクトになり得ない。
     */
    private boolean _isActivatable;
    public boolean IsActivatable() {
        return _isActivatable;
    }
    public void SetActivatable(boolean value) {
        _isActivatable = value;
    }

    public SceneObject(String name) {
        _name = name;

        _behaviors = new ArrayList<SceneObjectBehavior>();
        _transform = new SceneObjectTransform(this);
        _drawBack = new SceneObjectDrawBack(this);

        // トランスフォームが設定されてからでないと例外を発生させてしまう
        SetEnable(true);
        SetActivatable(true);
    }

    public void Start() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Start();
            }
        }
    }

    public void Stop() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            b.Stop();
        }
    }

    public void Update() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Update();
            }
        }
    }

    public void Draw() {
        // 自身のトランスフォームをセットする
        setMatrix(GetTransform().GetMatrix());

        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Draw();
            }
        }
    }

    public boolean IsAbleAO() {
        return IsActivatable() && _transform.IsInRegion(mouseX, mouseY);
    }

    protected void _OnEnable() {
    }

    protected void _OnDisable() {
    }

    public void OnEnabledActive() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnEnabledActive();
            }
        }
    }

    public void OnDisabledActive() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnDisabledActive();
            }
        }
    }

    /**
     自身のリストに振る舞いを追加する。
     同じものが既に追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddBehavior(SceneObjectBehavior behavior) {
        if (IsHaveBehavior(behavior.GetID())) {
            return false;
        }
        behavior.SetObject(this);
        return _behaviors.add(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを返す。
     負数を指定した場合、後ろからindex番目の振る舞いを返す。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectBehavior GetBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.get(index);
    }

    /**
     自身のリストの中からIDに該当する振る舞いを返す。
     
     @return behaviorに該当するIDの振る舞い 存在しなければNull
     */
    public SceneObjectBehavior GetBehaviorOnID(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定した振る舞いが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveBehavior(SceneObjectBehavior behavior) {
        return _behaviors.remove(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを削除する。
     負数を指定した場合、後ろからindex番目の振る舞いを削除する。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectBehavior RemoveBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.remove(index);
    }

    /**
     自身のリストの中からIDに該当する振る舞いを削除する。
     
     @return behaviorに該当するIDの振る舞い 存在しなければNull
     */
    public SceneObjectBehavior RemoveBehaviorOnID(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return _behaviors.remove(i);
            }
        }
        return null;
    }

    public boolean IsHaveBehavior(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return true;
            }
        }
        return false;
    }

    /**
     自身が指定されたオブジェクトの親の場合、trueを返す。
     */
    public boolean IsParentOf(SceneObject s) {
        return _transform.IsParentOf(s.GetTransform());
    }

    /**
     自身が指定されたオブジェクトの子の場合、trueを返す。
     */
    public boolean IsChildOf(SceneObject s) {
        return _transform.IsChildOf(s.GetTransform());
    }

    /**
     自身の親のオブジェクトを取得する。
     ただし、有効フラグがfalseの場合、nullを返す。
     */
    public SceneObject GetParent() {
        SceneObject s = _transform.GetParent().GetObject();
        if (s == null) {
            return null;
        }
        return s;
    }

    public boolean equals(Object o) {
        if (o == this) return true;
        return false;
    }

    public int compareTo(SceneObject s) {
        return _transform.compareTo(s.GetTransform());
    }
}