public class Transform {
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }
    public void SetPosition(PVector value) {
        if (value == null) return;
        _position = value;
    }
    public void SetPosition(float x, float y) {
        _position.set(x, y);
    }

    private PVector _scale;
    public PVector GetScale() {
        return _scale;
    }
    public void SetScale(PVector value) {
        if (value == null) return;
        _scale = value;
    }
    public void SetScale(float x, float y) {
        _scale.set(x, y);
    }

    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(PVector value) {
        if (value == null) return;
        _size = value;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    private float _rotate;
    public float GetRotate() {
        return _rotate;
    }
    public void SetRotate(float value) {
        _rotate = value;
    }

    public Transform() {
        _InitParametersOnConstructor(null, null, null, 0);
    }

    public Transform(PVector position, PVector scale, PVector size, float rotate) {
        _InitParametersOnConstructor(position, scale, size, rotate);
    }

    public Transform(float posX, float posY, float scaleX, float scaleY, float sizeX, float sizeY, float rotate) {
        _InitParametersOnConstructor(new PVector(posX, posY), new PVector(scaleX, scaleY), new PVector(sizeX, sizeY), rotate);
    }

    private void _InitParametersOnConstructor(PVector position, PVector scale, PVector size, float rotate) {
        if (position == null) {
            position = new PVector();
        }
        if (scale == null) {
            scale = new PVector(1, 1);
        }
        if (size == null) {
            size = new PVector();
        }

        SetPosition(position);
        SetScale(scale);
        SetSize(size);
        SetRotate(rotate);
    }
}