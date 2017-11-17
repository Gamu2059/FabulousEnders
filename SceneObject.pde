/**
 シーンを構成するオブジェクトのクラス。
 */
public class SceneObject {
    private String _name;
    public String GetName() {
        return _name;
    }

    private ArrayList<Abs_SceneObjectBehavior> _behaviors;
    public ArrayList<Abs_SceneObjectBehavior> GetBehaviors() {
        return _behaviors;
    }

    private Scene _scene;
    public Scene GetScene() {
        return _scene;
    }

    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    /**
     Sceneインスタンス専用コンストラクタ。
     */
    protected SceneObject(String name) {
        _name = name;
        _scene = null;
        _behaviors = new ArrayList<Abs_SceneObjectBehavior>();

        _transform = new SceneObjectTransform(this);
        _transform.SetSize(width, height);

        AddBehavior(_transform);
    }

    /**
     通常のSceneObjectインスタンス用のコンストラクタ。
     */
    public SceneObject(String name, Scene scene) {
        _name = name;
        _behaviors = new ArrayList<Abs_SceneObjectBehavior>();
        _scene = scene;
        _transform = new SceneObjectTransform(this);
        AddBehavior(_transform);

        scene.AddObject(this);
    }

    /**
     自身のリストに振る舞いを追加する。
     ただし、既に同じ系統の振る舞いが追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddBehavior(Abs_SceneObjectBehavior behavior) {
        if (IsHaveBehavior(behavior)) {
            return false;
        }
        return _behaviors.add(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを返す。
     負数を指定した場合、後ろからindex番目の振る舞いを返す。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Abs_SceneObjectBehavior GetBehavior(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.get(index);
    }

    /**
     自身のリストの中からbehaviorに該当する振る舞いを返す。
     
     @return behaviorに該当する名前の振る舞い 存在しなければNull
     */
    public Abs_SceneObjectBehavior GetBehavior(String behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定した振る舞いが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveBehavior(Abs_SceneObjectBehavior behavior) {
        return _behaviors.remove(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを削除する。
     負数を指定した場合、後ろからindex番目の振る舞いを削除する。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Abs_SceneObjectBehavior RemoveBehavior(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.remove(index);
    }

    /**
     自身のリストの中からbehaviorに該当する振る舞いを削除する。
     
     @return behaviorに該当する名前の振る舞い 存在しなければNull
     */
    public Abs_SceneObjectBehavior RemoveBehavior(String behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return _behaviors.remove(i);
            }
        }
        return null;
    }

    /**
     自身の振る舞いと指定した振る舞いとの間に同系統のものが存在した場合、trueを返す。
     */
    public boolean IsHaveBehavior(Abs_SceneObjectBehavior behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return true;
            }
        }
        return false;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" :\n");
        b.append("  name : ").append(_name).append(" \n");
        b.append("  behaviors :\n");
        b.append(_behaviors).append(" \n");

        return b.toString();
    }
}