/**
 トランスフォームの処理リストを順番に実行していくクラス。
 */
public class TransformProcessor implements Copyable<TransformProcessor> {
    private Transform[] _transforms;
    private int _selfDepth;

    public TransformProcessor() {
        _transforms = new Transform[TransformManager.MAX_DEPTH + 1];
        _selfDepth = 0;
        _transforms[0] = new Transform();
    }

    public void Init() {
        _selfDepth = 0;
    }

    public void AddTranslate(float x, float y) {
        PVector t = _transforms[_selfDepth].GetTranslation();
        _transforms[_selfDepth].SetTranslation(t.x + x, t.y + y);
    }

    public void AddRotate(float rad) {
        float r = _transforms[_selfDepth].GetRotate();
        _transforms[_selfDepth].SetRotate(r + rad);
    }

    public void AddScale(float x, float y) {
        PVector s = _transforms[_selfDepth].GetScale();
        _transforms[_selfDepth].SetScale(s.x * x, s.y * y);
    }

    public boolean NewDepth() {
        if (_selfDepth >= TransformManager.MAX_DEPTH + 1) {
            return false;
        }
        _selfDepth++;
        if (_transforms[_selfDepth] == null) {
            _transforms[_selfDepth] = new Transform();
        } else {
            _transforms[_selfDepth].Init();
        }
        return true;
    }

    public void TransformProcessing() {
        resetMatrix();
        Transform t;
        for (int i=0; i<=_selfDepth; i++) {
            t = _transforms[i];
            rotate(t.GetRotate());
            scale(t.GetScale().x, t.GetScale().y);
            translate(t.GetTranslation().x, t.GetTranslation().y);
        }
    }

    public void CopyTo(TransformProcessor tp) {
        if (tp == null) return;

        tp._selfDepth = _selfDepth;
        for (int i=0; i<=_selfDepth; i++) {
            if (tp._transforms[i] == null) {
                tp._transforms[i] = new Transform();
            }
            _transforms[i].CopyTo(tp._transforms[i]);
        }
    }
}