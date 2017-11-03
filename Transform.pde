/**
 汎用的な描画用トランスフォームクラス。
 */
public class Transform {
    private PVector _position;
    public PVector GetPosition() { 
        return _position;
    }
    public void SetPosition(PVector position) { 
        _position = position;
    }

    private PVector _rotate;
    public PVector GetRotate() { 
        return _rotate;
    }
    public void SetRotate(PVector rotate) { 
        _rotate = rotate;
    }

    private PVector _scale;
    public PVector GetScale() { 
        return _scale;
    }
    public void SetScale(PVector scale) { 
        _scale = scale;
    }

    public Transform() {
        _position = new PVector(0, 0);
        _rotate = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position) {
        _position = position;
        _rotate = new PVector(0, 0);
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position, PVector rotate) {
        _position = position;
        _rotate = rotate;
        _scale = new PVector(1, 1);
    }

    public Transform(PVector position, PVector rotate, PVector scale) {
        _position = position;
        _rotate = rotate;
        _scale = scale;
    }
}