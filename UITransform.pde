/**
 汎用的な描画用トランスフォームクラス。
 */
public class UITransform implements Cloneable {
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

    // 2Dでは回転は１つの軸でしか行えない。
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

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

    private PVector _scale;
    public PVector GetScale() { 
        return _scale;
    }
    public void SetScale(PVector value) { 
        _scale = value;
    }
    public void SetScale(float x, float y) {
        _scale.set(x, y);
    }

    public UITransform() {
        _position = new PVector(0, 0);
        _rotate = 0;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public UITransform(PVector position) {
        _position = position;
        _rotate = 0;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public UITransform(PVector position, float rotate) {
        _position = position;
        _rotate = rotate;
        _size = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public UITransform(PVector position, float rotate, PVector size) {
        _position = position;
        _rotate = rotate;
        _size = size;
        _scale = new PVector(1, 1);
    }

    public UITransform(PVector position, float rotate, PVector size, PVector scale) {
        _position = position;
        _rotate = rotate;
        _size = size;
        _scale = scale;
    }

    public UITransform clone() {
        return new UITransform(GetPosition(), GetRotate());
    }
    
    public void CopyTo(UITransform copy) {
        float a, b;
        copy.SetPosition(GetPosition().x, GetPosition().y);
        copy.SetRotate(GetRotate());
        copy.SetScale(GetScale().x, GetScale().y);
        copy.SetSize(GetSize().x, GetSize().y);
    }
}