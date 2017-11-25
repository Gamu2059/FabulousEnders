public final class SceneObjectAnchor {
    public final static int LEFT_TOP = 0; 
    public final static int LEFT_MIDDLE = 1; 
    public final static int LEFT_BOTTOM = 2;
    public final static int CENTER_TOP = 3;
    public final static int CENTER_MIDDLE = 4; 
    public final static int CENTER_BOTTOM = 5;
    public final static int RIGHT_TOP = 6;
    public final static int RIGHT_MIDDLE = 7; 
    public final static int RIGHT_BOTTOM = 8;

    private final static float _LEFT = 0;
    private final static float _CENTER = 0.5;
    private final static float _RIGHT = 1;

    private final static float _TOP = 0;
    private final static float _MIDDLE = 0.5;
    private final static float _BOTTOM = 1;

    private int _anchor;
    public int GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(int value) {
        if (0 <= value && value < 9) {
            _anchor = value;
        }
    }

    public SceneObjectAnchor() {
        SetAnchor(LEFT_TOP);
    }

    public SceneObjectAnchor(int anchor) {
        SetAnchor(anchor);
    }

    public float GetHorizontal() {
        return (_anchor / 3) / 2f;
    }

    public float GetVertical() {
        return (_anchor % 3) / 2f;
    }

    public boolean IsLeft() {
        return GetHorizontal() == _LEFT;
    }

    public boolean IsCenter() {
        return GetHorizontal() == _CENTER;
    }

    public boolean IsRight() {
        return GetHorizontal() == _RIGHT;
    }

    public boolean IsTop() {
        return GetVertical() == _TOP;
    }

    public boolean IsMiddle() {
        return GetVertical() == _MIDDLE;
    }

    public boolean IsBottom() {
        return GetVertical() == _BOTTOM;
    }
}