public class TransformManager {
    public static final int MAX_DEPTH = 32;

    private int _depth;

    public TransformManager() {
        _depth = 0;
    }

    public boolean PushDepth() {
        if (_depth >= MAX_DEPTH) return false;
        _depth++;
        return true;
    }

    public boolean PopDepth() {
        if (_depth < 0) return false;
        _depth--;
        return true;
    }

    public void ResetDepth() {
        _depth = 0;
    }
}