/**
 トランスフォームコンポーネント。
 保持されている変化量は、回転の後に平行移動することを前提としています。
 絶対変化量は、絶対回転量によって回転した後、絶対平行移動量によって平行移動することにより表現されます。
 相対変化量は、相対回転量による回転、相対平行移動量による平行移動、回転、平行移動、、、を繰り返すことにより表現されます。
 */
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
     
     さらに、自身がシーンインスタンスのトランスフォームであった場合、この処理は無視される。
     */
    public void SetParent(SceneObjectTransform value) {
        Scene s = GetObject().GetScene();
        if (s == null) {
            // シーンインスタンスがnullになるのは、シーンインスタンスだけ
            return;
        }

        _parent.RemoveChild(this);
        if (value == null) {
            _parent = s.GetTransform();
            s.GetTransform()._AddChild(this);
        } else {
            _parent = value;
            _parent._AddChild(this);
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
    private SceneObjectAnchor _parentAnchor;
    public SceneObjectAnchor GetParentAnchor() {
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
    private SceneObjectAnchor _selfAnchor;
    public SceneObjectAnchor GetSelfAnchor() {
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
        if (value >= 0) {
            _priority = value;
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

    /**
     絶対平行移動量。
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
     相対平行移動量。
     */
    private PVector _localPosition;
    public PVector GetLocalPosition() { 
        return _localPosition;
    }
    public void SetLocalPosition(PVector value) { 
        _localPosition = value;
    }
    public void SetLocalPosition(float x, float y) {
        _localPosition.set(x, y);
    }

    /**
     絶対回転量。
     */
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

    /**
     相対回転量。
     */
    private float _localRotate;
    public float GetLocalRotate() { 
        return _localRotate;
    }
    public void SetLocalRotate(float value) { 
        _localRotate = value;
    }

    /**
     図形の描画領域。
     相対量という概念は無い。
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
        _localPosition = new PVector();
        _rotate = 0;
        _localRotate = 0;
        _size = new PVector();
        _parentAnchor = new SceneObjectAnchor();
        _selfAnchor = new SceneObjectAnchor();
        _priority = 1;

        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
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
        if (IsParentOf(t)) {
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