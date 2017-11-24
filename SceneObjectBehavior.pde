/**
 オブジェクトに任意の処理を提供する振る舞い。
 いくつでもオブジェクトに実装できる。
 */
public class SceneObjectBehavior extends Abs_SceneObjectBehavior {
    public SceneObjectBehavior(SceneObject obj) {
        super(obj);
    }

    protected String _OldestClassName() {
        return "SceneObjectBehavior";
    }
}