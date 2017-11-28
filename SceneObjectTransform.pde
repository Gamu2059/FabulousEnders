public final class SceneObjectTransform extends Abs_SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    /**
     親トランスフォーム。
     */
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
        if (GetObject() instanceof Scene) {
            return;
        }

        SceneObjectTransform t = GetScene().GetTransform();
        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        if (value == null) {
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
     子トランスフォームリスト。
     */
    private ArrayList<SceneObjectTransform> _children;
    public ArrayList<SceneObjectTransform> GetChildren() {
        return _children;
    }

    /**
     親へのアンカー。
     親のどの箇所を基準にするのかを定める。
     */
    private Anchor _parentAnchor;
    public Anchor GetParentAnchor() {
        return _parentAnchor;
    }
    public void SetParentAnchor(int value) {
        if (_parentAnchor != null) {
            _parentAnchor.SetAnchor(value);
        }
    }

    /**
     自身のアンカー。
     親の基準に対して、自身のどの箇所を基準にするのかを定める。
     */
    private Anchor _selfAnchor;
    public Anchor GetSelfAnchor() {
        return _selfAnchor;
    }
    public void SetSelfAnchor(int value) {
        if (_selfAnchor != null) {
            _selfAnchor.SetAnchor(value);
        }
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
            if (!(GetObject() instanceof Scene)) {
                GetScene().SetNeedSorting(true);
            }
        }
    }

    /**
     絶対変化量行列。
     これを変換行列としてから描画することで絶対変化量が表現する図形として描画される。
     */
    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }
    private void _PushMatrix() {
        getMatrix(_matrix);
    }

    /**
     平行移動量と回転量の表現しているものが、親トランスフォームの相対量なのか、シーンからの絶対量なのかを決める。
     trueの場合、相対量となる。
     */
    private boolean _isRelative;
    public boolean IsRelative() {
        return _isRelative;
    }
    public void SetRelative(boolean value) {
        _isRelative = value;
    }

    /**
     平行移動量。
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }
    public void SetPosition(PVector value) { 
        _position = value;
    }
    public void SetPosition(float x, float y) {
        _position.set(x, y);
    }

    /**
     回転量。
     */
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

    /**
     図形の描画領域。
     */
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

    public SceneObjectTransform(SceneObject obj) {
        super(obj);
        _position = new PVector();
        _rotate = 0;
        _size = new PVector();
        _parentAnchor = new Anchor();
        _selfAnchor = new Anchor();
        _priority = 1;
        _isRelative = true;

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

        // 相対量か絶対量かを指定
        SceneObjectTransform parent;
        if (_isRelative) {
            parent = _parent;
        } else {
            parent = GetScene().GetTransform();
            GetScene().TransformScene();
        }

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