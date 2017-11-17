/***/
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

    public Abs_SceneObjectBehavior(String name, SceneObject object) {
        _name = name;
        _object = object;

        // 自身も含めた継承しているクラスを全て列挙
        ArrayList<String> list = new ArrayList<String>();
        Class<?> c = getClass();
        while (c != null || c.getSimpleName().equals(_OldestClassName())) {
            list.add(c.getSimpleName());
            c = c.getSuperclass();
        }
        _classNames = new String[list.size()];
        list.toArray(_classNames);

        object.AddBehavior(this);
    }

    /**
     同じ系統の振る舞いであった場合、trueを返す。
     */
    public boolean IsSameBehavior(Abs_SceneObjectBehavior behavior) {
        String[] a, b;
        a = _classNames;
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
     ClassNames配列を生成する際に、"自身の振る舞いを特定できない最も古い振る舞い"を返す。
     基本的な振る舞いは、全て "Abs_SceneObjectBehavior" を返す。
     */
    protected String _OldestClassName() {
        return "Abs_SceneObjectBehavior";
    }

    /**
     指定した名前と一致する振る舞いであるか、もしくはそれを継承している場合、trueを返す。
     */
    public boolean IsBehaviorAs(String behavior) {
        String[] a = _classNames;
        for (int i=0; i<a.length; i++) {
            if (a[i].equals(behavior)) {
                return true;
            }
        }
        return false;
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
        }
        if (o == null) {
            return false;
        }
        if (o instanceof String) {
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
        b.append("\n").append(getClass().getSimpleName()).append(" :\n");
        b.append("  name : ").append(_name);
        b.append("  inhered class name : ").append(_classNames);
        b.append("  scene oject : ").append(_object);
        return b.toString();
    }
}