/** //<>//
 アフィン変換一回分の情報に責任を持つ。
 サイズは持たない。
 */
public class Transform implements Copyable<Transform> {
    private PVector _translation;
    public PVector GetTranslation() {
        return _translation;
    }
    public void SetTranslation(PVector value) {
        if (value == null) return;
        SetTranslation(value.x, value.y);
    }
    public void SetTranslation(float x, float y) {
        _translation.set(x, y);
    }

    private PVector _scale;
    public PVector GetScale() {
        return _scale;
    }
    public void SetScale(PVector value) {
        if (value == null) return;
        SetScale(value.x, value.y);
    }
    public void SetScale(float x, float y) {
        _scale.set(x, y);
    }

    private float _rotate;
    public float GetRotate() {
        return _rotate;
    }
    public void SetRotate(float value) {
        _rotate = value;
    }

    public Transform() {
        _InitParametersOnConstructor(null, null, 0);
    }

    public Transform(PVector position, PVector scale, float rotate) {
        _InitParametersOnConstructor(position, scale, rotate);
    }

    public Transform(float posX, float posY, float scaleX, float scaleY, float rotate) {
        _InitParametersOnConstructor(new PVector(posX, posY), new PVector(scaleX, scaleY), rotate);
    }

    private void _InitParametersOnConstructor(PVector position, PVector scale, float rotate) {
        if (position == null) {
            position = new PVector();
        }
        if (scale == null) {
            scale = new PVector(1, 1);
        }

        _translation = position;
        _scale = scale;
        _rotate = rotate;
    }

    public void Init() {
        SetTranslation(0, 0);
        SetRotate(0);
        SetScale(1, 1);
    }

    public void CopyTo(Transform t) {
        if (t == null) return;
        t.SetTranslation(GetTranslation());
        t.SetScale(GetScale());
        t.SetRotate(GetRotate());
    }

    public String toString() {
        return "translate : " + GetTranslation() + "\nrotate : " + GetRotate() + "\nscale : " + GetScale();
    }
}