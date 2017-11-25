public abstract class Abs_SceneObjectBehavior {
    private String[] _classNames;
    protected String[] GetClassNames() {
        return _classNames;
    }

    private String _name;
    public String GetName() {
        return _name;
    }

    private SceneObject _object;
    public SceneObject GetObject() {
        return _object;
    }

    public Scene GetScene() {
        if (GetObject() == null) {
            return null;
        }
        return GetObject().GetScene();
    }

    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public void SetEnable(boolean value) {
        _enable = value;
        if (_enable) {
            OnEnabled();
        } else {
            OnDisabled();
        }
    }

    /**
     振る舞いとしてスタート関数が呼び出されたかどうか。
     既に呼び出された場合はtrueになる。
     */
    private boolean _isStart;
    public boolean IsStart() {
        return _isStart;
    }

    public Abs_SceneObjectBehavior(SceneObject object) {
        _name = getClass().getSimpleName();
        _object = object;
        SetEnable(true);

        // 自身も含めた継承しているクラスを全て列挙
        ArrayList<String> list = new ArrayList<String>();
        Class<?> c = getClass();
        while (c != null) {
            if (c.getSimpleName().equals(_OldestClassName())) {
                break;
            }
            list.add(c.getSimpleName());
            c = c.getSuperclass();
        }
        _classNames = new String[list.size()];
        list.toArray(_classNames);

        object.AddBehavior(this);
    }

    /**
     ClassNames配列を生成する際に、"自身の振る舞いを特定できない最も古い振る舞い"を返す。
     基本的な振る舞いは、全て "Abs_SceneObjectBehavior" を返す。
     
     返り値に指定したクラスを継承する振る舞いはオブジェクトに複数存在することが許可される。
     */
    protected String _OldestClassName() {
        return "Abs_SceneObjectBehavior";
    }

    /**
     同じ系統の振る舞いであった場合、trueを返す。
     */
    public final boolean IsSameBehavior(Abs_SceneObjectBehavior behavior) {
        String[] a, b;
        a = GetClassNames();
        b = behavior.GetClassNames();
        for (int i=0; i<a.length; i++) {
            for (int j=0; j<b.length; j++) {
                if (a[i].equals(b[j])) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     指定した名前と一致する振る舞いであるか、もしくはそれを継承している場合、trueを返す。
     */
    public final boolean IsBehaviorAs(String behavior) {
        String[] a = GetClassNames();
        for (int i=0; i<a.length; i++) {
            if (a[i].equals(behavior)) {
                return true;
            }
        }
        return false;
    }

    /**
     指定した振る舞いに該当する場合、trueを返す。
     */
    public final boolean IsBehaviorAs(Class<?> c) {
        return IsBehaviorAs(c.getSimpleName());
    }

    /**
     シーンがアクティブになってからの最初のフレームで呼び出される。
     これが呼び出される段階では、全てのオブジェクトが揃っているので、自身以外への参照の保持などを行える。
     */
    public void Start() {
        _isStart = true;
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     初回フレームでは、全ての振る舞いのStartが呼び出された後に呼び出される。
     アニメーションやキー判定などは、基本的にここで処理する。
     */
    public void Update() {
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     アニメーションコントローラ以外は基本的に何も処理しない。
     */
    public void Animation() {
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     ドロービヘイビア以外は基本的に何も処理しない。
     */
    public void Draw() {
    }

    /**
     シーンがノンアクティブになったフレームで呼び出される。
     Destroyとは異なり、オブジェクトの破壊などを行うためのメソッドではないので注意。
     */
    public void Stop() {
    }

    /**
     オブジェクトが有効化されたフレームで呼び出される。
     振る舞い単体でも呼び出される可能性はある。
     */
    public void OnEnabled() {
        _isStart = false;
    }

    /**
     オブジェクトが無効化されたフレームで呼び出される。
     振る舞い単体でも呼び出される可能性はある。
     */
    public void OnDisabled() {
    }

    public void OnEnabledActive() {
    }

    public void OnDisabledActive() {
    }

    public void OnMousePressed() {
    }

    public void OnMouseReleased() {
    }

    public void OnMouseClicked() {
    }

    public void OnKeyPressed() {
    }

    public void OnKeyReleased() {
    }

    /**
     指定したオブジェクトが次のいずれかの場合、trueを返す。
     ・自身そのもの。
     ・文字列であり、かつ自身の振る舞いのいづれかに該当する。
     ・振る舞いであり、かつ自身と同系統の振る舞い。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (o instanceof String) {
            String s = (String) o;
            return IsBehaviorAs(s);
        } else if (o instanceof Abs_SceneObjectBehavior) {
            Abs_SceneObjectBehavior b = (Abs_SceneObjectBehavior) o;
            return IsSameBehavior(b);
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" :\n");
        b.append("  name : ").append(_name).append(" \n");
        return b.toString();
    }
}