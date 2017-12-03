public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> { //<>//
    public int GetID() {
        return ClassID.CID_TRANSFORM;
    }

    private SceneObjectTransform _parent;
    public SceneObjectTransform GetParent() {
        return _parent;
    }
    /**
     親トランスフォームを設定する。
     自動的に前の親との親子関係は絶たれる。
     
     isPriorityChangeがtrueの場合、自動的に親の優先度より1だけ高い優先度がつけられる。
     */
    public void SetParent(SceneObjectTransform value, boolean isPriorityChange) {
        if (value == null) return;

        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        _parent = value;
        _parent._AddChild(this);
        if (isPriorityChange) {
            SetPriority(GetParent().GetPriority() + 1);
        }
    }

    private ArrayList<SceneObjectTransform> _children;
    public ArrayList<SceneObjectTransform> GetChildren() {
        return _children;
    }

    private Anchor _anchor;
    public Anchor GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(PVector min, PVector max) {
        if (_anchor == null) return;
        _anchor.SetMin(min);
        _anchor.SetMax(max);
    }
    public void SetAnchor(float minX, float minY, float maxX, float maxY) {
        if (_anchor == null) return;
        _anchor.SetMin(minX, minY);
        _anchor.SetMax(maxX, maxY);
    }

    private Pivot _pivot;
    public Pivot GetPivot() {
        return _pivot;
    }
    public void SetPivot(PVector value) {
        if (_pivot == null) return;
        _pivot.SetPivot(value);
    }
    public void SetPivot(float x, float y) {
        if (_pivot == null) return;
        _pivot.SetPivot(x, y);
    }

    /**
     優先度。
     階層構造とは概念が異なる。
     主に描画や当たり判定の優先度として用いられる。
     */
    private int _priority;
    public int GetPriority() {
        return _priority;
    }
    public void SetPriority(int value) {
        if (value >= 0 && _priority != value) {
            _priority = value;
            if (GetScene() == null) return;
            GetScene().SetNeedSorting(true);
        }
    }

    private PMatrix2D _matrix, _inverse;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }

    private TransformProcessor _transformProcessor;
    public TransformProcessor GetTransformProcessor() {
        return _transformProcessor;
    }

    /**
     親空間での相対移動量、自空間での回転量、自空間でのスケール量を保持する。
     */
    private Transform _transform;
    public Transform GetTransform() {
        return _transform;
    }

    public PVector GetTranslation() {
        return _transform.GetTranslation();
    }
    public void SetTranslation(float x, float y) {
        _transform.SetTranslation(x, y);
    }

    public float GetRotate() {
        return _transform.GetRotate();
    }
    public void SetRotate(float rad) {
        _transform.SetRotate(rad);
    }

    public PVector GetScale() {
        return _transform.GetScale();
    }
    public void SetScale(float x, float y) {
        _transform.SetScale(x, y);
    }

    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    public SceneObjectTransform() {
        super();

        _transform = new Transform();
        _size = new PVector();

        _anchor = new Anchor();
        _pivot = new Pivot(0.5, 0.5);

        _priority = 1;
        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
        _transformProcessor = new TransformProcessor();
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     */
    public void TransformMatrixOnRoot() {
        transformManager.ResetDepth();

        // これ以上階層を辿れない場合は変形させない
        if (!transformManager.PushDepth()) return;

        _transformProcessor.Init();
        _matrix.reset();

        _TransformMatrix();
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     再帰的に呼び出される。
     */
    private void _TransformMatrixOnChild(TransformProcessor tp, PMatrix2D mat) {
        // これ以上階層を辿れない場合は変形させない
        if (!transformManager.PushDepth()) return;

        tp.CopyTo(_transformProcessor);
        _matrix = mat.get();

        _TransformMatrix();

        transformManager.PushDepth();
    }

    private void _TransformMatrix() {
        float x, y;
        x = GetTranslation().x;
        y = GetTranslation().y;
        if (GetParent() != null) {
            // アンカーの座標へ移動
            float aX, aY;
            aX = (GetAnchor().GetMaxX() + GetAnchor().GetMinX()) / 2 * GetParent().GetSize().x;
            aY = (GetAnchor().GetMaxY() + GetAnchor().GetMinY()) / 2 * GetParent().GetSize().y;

            _transformProcessor.AddTranslate(aX, aY);
            _matrix.translate(aX, aY);

            if (GetAnchor().GetMaxX() != GetAnchor().GetMinX()) {
                aX = (GetAnchor().GetMaxX() - GetAnchor().GetMinX()) * GetParent().GetSize().x;
                x = 0;
                SetSize(aX, GetSize().y);
            }
            if (GetAnchor().GetMaxY() != GetAnchor().GetMinY()) {
                aY = (GetAnchor().GetMaxY() - GetAnchor().GetMinY()) * GetParent().GetSize().y;
                y = 0;
                SetSize(GetSize().x, aY);
            }
        }

        // 親空間での相対座標へ移動
        _transformProcessor.AddTranslate(x, y);
        _matrix.translate(x, y);

        // トランスフォームプロセッサへ追加する箇所を変更
        if (!_transformProcessor.NewDepth()) return;

        // 自空間での回転
        _transformProcessor.AddRotate(GetRotate());
        _matrix.rotate(GetRotate());

        // 自空間でのスケーリング
        _transformProcessor.AddScale(GetScale().x, GetScale().y);
        _matrix.scale(GetScale().x, GetScale().y);

        // ピボットの座標へ移動
        x = -GetPivot().GetX() * GetSize().x;
        y = -GetPivot().GetY() * GetSize().y;
        _transformProcessor.AddTranslate(x, y);
        _matrix.translate(x, y);

        // 再帰的に計算していく
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i)._TransformMatrixOnChild(_transformProcessor, _matrix);
            }
        }
    }

    /**
     指定座標がトランスフォームの領域内であればtrueを返す。
     */
    public boolean IsInRegion(float y, float x) {
        _inverse = _matrix.get();
        if (!_inverse.invert()) {
            println("逆アフィン変換ができません。");
            return false;
        }

        float[] _in, _out;
        _in = new float[]{y, x};
        _out = new float[2];
        _inverse.mult(_in, _out);
        return 0 <= _out[0] && _out[0] < _size.x && 0 <= _out[1] && _out[1] < _size.y;
    }

    public boolean IsParentOf(SceneObjectTransform t) {
        return this == t.GetParent();
    }

    public boolean IsChildOf(SceneObjectTransform t) {
        return _parent == t;
    }

    /**
     自身の子としてトランスフォームを追加する。
     ただし、既に子として存在している場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    private boolean _AddChild(SceneObjectTransform t) {
        if (GetChildren().contains(t)) {
            return false;
        }
        return _children.add(t);
    }

    public void AddChild(SceneObjectTransform t, boolean isChangePriority) {
        if (t == null) return;
        t.SetParent(this, isChangePriority);
    }

    /**
     自身のリストのindex番目のトランスフォームを返す。
     負数を指定した場合、後ろからindex番目のトランスフォームを返す。
     
     @return index番目のトランスフォーム 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectTransform GetChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.get(index);
    }

    /**
     自身のリストに指定したトランスフォームが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveChild(SceneObjectTransform t) {
        return _children.remove(t);
    }

    /**
     自身のリストのindex番目のトランスフォームを削除する。
     負数を指定した場合、後ろからindex番目のトランスフォームを削除する。
     
     @return index番目のトランスフォーム 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectTransform RemoveChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.remove(index);
    }

    /**
     自分以外の場合、falseを返す。
     */
    public boolean equals(Object o) {
        return this == o;
    }

    /**
     優先度によって比較を行う。
     */
    public int compareTo(SceneObjectTransform o) {
        return GetPriority() - o.GetPriority();
    }
}