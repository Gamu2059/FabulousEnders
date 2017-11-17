/**
 トランスフォームコンポーネント。
 保持されている変化量は、回転の後に平行移動することを前提としています。
 絶対変化量は、絶対回転量によって回転した後、絶対平行移動量によって平行移動することにより表現されます。
 相対変化量は、相対回転量による回転、相対平行移動量による平行移動、回転、平行移動、、、を繰り返すことにより表現されます。
 */
public class Transform extends Abs_SceneObjectBehavior {
    /**
     親オブジェクト。
     シーンインスタンスも親となる可能性はある。
     */
    private SceneObject _parent;
    public SceneObject GetParent() {
        return _parent;
    }
    public void SetParent(SceneObject value) {
        _parent = value;
    }

    /**
     子オブジェクト。
     */
    private ArrayList<SceneObject> _children;
    public ArrayList<SceneObject> GetChildren() {
        return _children;
    }

    /**
     絶対変化量行列。
     これを変換行列としてから描画することで絶対変化量が表現する図形として描画される。
     */
    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }

    /**
     絶対平行移動量。
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }
    public void SetPosition(PVector value) { 
        _position = value;
    }
    public void SetPosition(float x, float y) {
        _position.set(x, y);
    }

    /**
     相対平行移動量。
     */
    private PVector _localPosition;
    public PVector GetLocalPosition() { 
        return _localPosition;
    }
    public void SetLocalPosition(PVector value) { 
        _localPosition = value;
    }
    public void SetLocalPosition(float x, float y) {
        _localPosition.set(x, y);
    }

    /**
     絶対回転量。
     */
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

    /**
     相対回転量。
     */
    private float _localRotate;
    public float GetLocalRotate() { 
        return _localRotate;
    }
    public void SetLocalRotate(float value) { 
        _localRotate = value;
    }

    /**
     図形の描画領域。
     相対量という概念は無い。
     */
    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(PVector value) {
        _size = value;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    public Transform() {
        super();
        _position = new PVector(0, 0);
        _rotate = 0;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position) {
        _position = position;
        _rotate = 0;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position, float rotate) {
        _position = position;
        _rotate = rotate;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position, float rotate, PVector size) {
        _position = position;
        _rotate = rotate;
        _size = size;
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position, float rotate, PVector size, PVector scale) {
        _position = position;
        _rotate = rotate;
        _size = size;
        _scale = scale;
    }

    public final String GetBehavior() {
        return getClass().getSimpleName();
    }
}