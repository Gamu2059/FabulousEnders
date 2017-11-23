/**
 Processing内部で保持しているアフィン行列の管理をしやすくするためのマネージャ。
 */
public final class MatrixManager extends Abs_Manager {
    public final static int MAX_STACK = 32;

    private int _stackNum;
    public int GetStackNum() {
        return _stackNum;
    }

    public MatrixManager() {
        super();
        _stackNum = 0;
    }

    public boolean PushMatrix() {
        if (_stackNum < MAX_STACK) {
            _stackNum++;
            pushMatrix();
            return true;
        }
        return false;
    }

    public boolean PopMatrix() {
        if (_stackNum > 0) {
            _stackNum--;
            popMatrix();
            return true;
        }
        return false;
    }
}