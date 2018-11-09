/**
 平面上のある領域の基準点を保持する責任を持つ。
 */
public class Pivot {
    private PVector _pivot;
    public PVector GetPivot() {
        return _pivot;
    }
    public void SetPivot(PVector value) {
        if (value == null) return;
        _pivot.set(value.x, value.y);
    }
    public void SetPivot(float x, float y) {
        if (x < 0 || 1 < x || y < 0 || 1 < y) return;
        _pivot.set(x, y);
    }

    public final static float P_LEFT = 0;
    public final static float P_CENTER = 0.5;
    public final static float P_RIGHT = 1;
    public final static float P_TOP = 0;
    public final static float P_BOTTOM = 1;

    public Pivot() {
        _InitParametersOnConstructor(null);
    }

    public Pivot(PVector value) {
        _InitParametersOnConstructor(value);
    }

    public Pivot(float x, float y) {
        _InitParametersOnConstructor(new PVector(x, y));
    }

    private void _InitParametersOnConstructor(PVector pivot) {
        _pivot = new PVector(P_LEFT, P_TOP);
        if (pivot == null) pivot = new PVector(P_LEFT, P_TOP);
        SetPivot(pivot);
    }

    public float GetX() {
        return GetPivot().x;
    }

    public float GetY() {
        return GetPivot().y;
    }

    public void SetX(float value) {
        SetPivot(value, GetY());
    }

    public void SetY(float value) {
        SetPivot(GetX(), value);
    }
}

/**
 平面上のある領域の基準点を二つ保持する責任を持つ。
 */
public class Anchor {
    private Pivot _min, _max;

    public PVector GetMin() {
        return _min.GetPivot();
    }
    public void SetMin(PVector value) {
        if (value == null) return;
        SetMin(value.x, value.y);
    }

    public void SetMin(float x, float y) {
        float temp;
        if (x > GetMax().x) {
            temp = GetMax().x;
            _max.SetX(x);
            x = temp;
        }
        if (y > GetMax().y) {
            temp = GetMax().y;
            _max.SetY(y);
            y = temp;
        }
        _min.SetPivot(x, y);
    }

    public PVector GetMax() {
        return _max.GetPivot();
    }
    public void SetMax(PVector value) {
        if (value == null) return;
        SetMax(value.x, value.y);
    }

    public void SetMax(float x, float y) {
        float temp;
        if (x < GetMin().x) {
            temp = GetMin().x;
            _min.SetX(x);
            x = temp;
        }
        if (y < GetMin().y) {
            temp = GetMin().y;
            _min.SetY(y);
            y = temp;
        }
        _max.SetPivot(x, y);
    }

    public Anchor() {
        _InitParametersOnConstructor(Pivot.P_LEFT, Pivot.P_TOP, Pivot.P_RIGHT, Pivot.P_BOTTOM);
    }

    public Anchor(float minX, float minY, float maxX, float maxY) {
        _InitParametersOnConstructor(minX, minY, maxX, maxY);
    }

    private void _InitParametersOnConstructor(float minX, float minY, float maxX, float maxY) {
        _min = new Pivot(minX, minY);
        _max = new Pivot(maxX, maxY);
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
    public void SetMinX(float value) {
        SetMin(value, GetMinY());
    }
    public void SetMinY(float value) {
        SetMin(GetMinX(), value);
    }
    public void SetMaxX(float value) {
        SetMax(value, GetMaxY());
    }
    public void SetMaxY(float value) {
        SetMax(GetMaxX(), value);
    }
}