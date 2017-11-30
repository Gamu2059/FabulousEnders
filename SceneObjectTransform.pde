public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    private SceneObjectTransform _parent;
    public SceneObjectTransform GetParent() {
        return _parent;
    }
    /**
     親トランスフォームを設定する。
     自動的に前の親との親子関係は絶たれる。
     ただし、指定したトランスフォームがnullの場合は、シーンインスタンスが親になる。
     
     isPriorityChangeがtrueの場合、自動的に親の優先度より1だけ高い優先度がつけられる。
     */
    public void SetParent(SceneObjectTransform value, boolean isPriorityChange) {
        if (!_isSettableParent) return;

        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        if (value == null) {
            SceneObjectTransform t = GetScene().GetTransform();
            _parent = t;
            t._AddChild(this);
        } else {
            _parent = value;
            _parent._AddChild(this);
        }
        if (isPriorityChange) {
            SetPriority(GetParent().GetPriority() + 1);
        }
    }

    /**
     親トランスフォームを設定可能である場合は、trueとなる。
     */
    private boolean _isSettableParent;

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
            GetScene().SetNeedSorting(true);
        }
    }

    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }

    private Transform _transform;

    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(PVector value) {
        _size = value;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    public SceneObjectTransform() {
        super();

        _transform = new Transform();
        _size = new PVector();

        _priority = 1;
        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     */
    public void Transform() {
        if (!GetObject().IsEnable()) {
            return;
        }
        
        // 保存の限界でないかどうか
        if (!matrixManager.PushMatrix()) {
            return;
        }

        _matrix.reset();
        float par1, par2;
        // 親の基準へ移動
        par1 = _parentAnchor.GetX();
        par2 = _parentAnchor.GetY();
        translate(par1 * parent.GetSize().x, par2 * parent.GetSize().y);

        // 自身の基準での回転
        rotate(_rotate);

        // 自身の基準へ移動
        par1 = _selfAnchor.GetX();
        par2 = _selfAnchor.GetY();
        translate(-par1 * _size.x + _position.x, -par2 * _size.y + _position.y);

        // 再帰的に計算していく
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i).Transform();
            }
        }
        _PushMatrix();
        matrixManager.PopMatrix();
    }

    /**
     指定座標がトランスフォームの領域内であればtrueを返す。
     */
    public boolean IsInRegion(float y, float x) {
        PMatrix2D inv = GetMatrix().get();
        if (!inv.invert()) {
            println(this);
            println("逆アフィン変換ができません。");
            return false;
        }

        float[] in, out;
        in = new float[]{y, x};
        out = new float[2];
        inv.mult(in, out);
        return 0 <= out[0] && out[0] < _size.x && 0 <= out[1] && out[1] < _size.y;
    }

    /**
     自身が指定されたトランスフォームの親の場合、trueを返す。
     */
    public boolean IsParentOf(SceneObjectTransform t) {
        return this == t.GetParent();
    }

    /**
     自身が指定されたトランスフォームの子の場合、trueを返す。
     */
    public boolean IsChildOf(SceneObjectTransform t) {
        return _parent == t;
    }

    /**
     自身の子としてトランスフォームを追加する。
     ただし、既に子として存在している場合は追加できない。
     基本的に、親トランスフォームから親子関係を構築するのは禁止する。
     
     @return 追加に成功した場合はtrueを返す
     */
    private boolean _AddChild(SceneObjectTransform t) {
        if (GetChildren().contains(t)) {
            return false;
        }
        return _children.add(t);
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
        if (o == this) {
            return true;
        }
        return false;
    }

    /**
     優先度によって比較を行う。
     */
    public int compareTo(SceneObjectTransform t) {
        return _priority - t.GetPriority();
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(super.toString());

        return b.toString();
    }
}