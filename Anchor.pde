public class Anchor {
    private PVector _anchor;
    public PVector GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(PVector value) {
        if (value == null) return;
        _anchor = value;
    }
    public void SetAnchor(float x, float y) {
        _anchor.set(x, y);
    }

    public final static float ANCHOR_LEFT = 0;
    public final static float ANCHOR_CENTER = 0.5;
    public final static float ANCHOR_RIGHT = 1;
    public final static float ANCHOR_TOP = 0;
    public final static float ANCHOR_BOTTOM = 1;

    public Anchor() {
        SetAnchor(new PVector(ANCHOR_LEFT, ANCHOR_TOP));
    }

    public Anchor(PVector value) {
        SetAnchor(value);
    }

    public Anchor(float x, float y) {
        SetAnchor(x, y);
    }

    public float GetHorizontal() {
        return GetAnchor().x;
    }

    public float GetVertical() {
        return GetAnchor().y;
    }
}