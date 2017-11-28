/**
 平面上のある領域の基準点を保持する責任を持つ。
 */
public class Anchor {
    private PVector _anchor;
    public PVector GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(PVector value) {
        if (value == null) return;
        _anchor.set(value.x, value.y);
    }
    public void SetAnchor(float x, float y) {
        if (x < 0 || 1 < x || y < 0 || 1 < y) return;
        _anchor.set(x, y);
    }

    public final static float ANCHOR_LEFT = 0;
    public final static float ANCHOR_CENTER = 0.5;
    public final static float ANCHOR_RIGHT = 1;
    public final static float ANCHOR_TOP = 0;
    public final static float ANCHOR_BOTTOM = 1;

    public Anchor() {
        _InitParametersOnConstructor(null);
    }

    public Anchor(PVector value) {
        _InitParametersOnConstructor(value);
    }

    public Anchor(float x, float y) {
        _InitParametersOnConstructor(new PVector(x, y));
    }

    private void _InitParametersOnConstructor(PVector anchor) {
        _anchor = new PVector(ANCHOR_LEFT, ANCHOR_TOP);
        if (anchor == null) anchor = new PVector(ANCHOR_LEFT, ANCHOR_TOP);
        SetAnchor(anchor);
    }

    public float GetX() {
        return GetAnchor().x;
    }

    public float GetY() {
        return GetAnchor().y;
    }
}