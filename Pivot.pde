/**
 平面上のある領域の二か所の基準点を保持する責任を持つ。
 */
public class Pivot {
    private Anchor _min;
    public PVector GetMin() {
        return _min.GetAnchor();
    }
    public void SetMin(PVector value) {
        if (value == null) return;
        SetMin(value.x, value.y);
    }
    public void SetMin(float x, float y) {
        if (x > GetMax().x || y > GetMax().y) return;
        _min.SetAnchor(x, y);
    }

    private Anchor _max;
    public PVector GetMax() {
        return _max.GetAnchor();
    }
    public void SetMax(PVector value) {
        if (value == null) return;
        SetMax(value.x, value.y);
    }
    public void SetMax(float x, float y) {
        if (x < GetMin().x || y < GetMin().y) return;
        _max.SetAnchor(x, y);
    }

    public Pivot() {
        _InitParametersOnConstructor(null, null);
    }

    public Pivot(PVector min, PVector max) {
        _InitParametersOnConstructor(min, max);
    }

    public Pivot(float minX, float minY, float maxX, float maxY) {
        _InitParametersOnConstructor(new PVector(minX, minY), new PVector(maxX, maxY));
    }

    private void _InitParametersOnConstructor(PVector min, PVector max) {
        _min = new Anchor(Anchor.ANCHOR_LEFT, Anchor.ANCHOR_TOP);
        _max = new Anchor(Anchor.ANCHOR_RIGHT, Anchor.ANCHOR_BOTTOM);
        if (min == null) min = new PVector(Anchor.ANCHOR_LEFT, Anchor.ANCHOR_TOP);
        if (max == null) max = new PVector(Anchor.ANCHOR_RIGHT, Anchor.ANCHOR_BOTTOM);
        SetMin(min);
        SetMax(max);
    }

    public float GetMinX() {
        return GetMin().x;
    }

    public float GetMinY() {
        return GetMin().y;
    }

    public float GetMaxX() {
        return GetMax().x;
    }

    public float GetMaxY() {
        return GetMax().y;
    }
}