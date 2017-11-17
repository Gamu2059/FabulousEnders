/**
 SceneObjectの基準位置を指定する情報のクラス。
 */
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

    public final static float LEFT = 0;
    public final static float CENTER = 0.5;
    public final static float RIGHT = 1;

    public final static float TOP = 0;
    public final static float MIDDLE = 0.5;
    public final static float BOTTOM = 1;

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
        return GetHorizontal() == LEFT;
    }

    public boolean IsCenter() {
        return GetHorizontal() == CENTER;
    }

    public boolean IsRight() {
        return GetHorizontal() == RIGHT;
    }

    public boolean IsTop() {
        return GetVertical() == TOP;
    }

    public boolean IsMiddle() {
        return GetVertical() == MIDDLE;
    }

    public boolean IsBottom() {
        return GetVertical() == BOTTOM;
    }
}