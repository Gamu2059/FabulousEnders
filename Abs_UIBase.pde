/**
 UIManagerを含む、全てのUIコンポーネントの基底クラス。
 抽象的な部分は存在しないが、これ自体でのインスタンス化を避けたいため、抽象クラスにしている。
 */
public abstract class Abs_UIBase {
    /**
     親コンポーネント
     */
    private Abs_UIBase _parent;
    public Abs_UIBase GetParent() { 
        return _parent;
    }
    public void SetParent(Abs_UIBase value) { 
        _parent = value;
    }

    /**
     子コンポーネントのリスト
     */
    private ArrayList<Abs_UIBase> _children;
    /**
     子リストを返す。
     @return 子リスト
     @throws Exception 子リストがNullか空の場合
     */
    public ArrayList<Abs_UIBase> GetChildren() throws Exception {
        if (IsNullOrEmptyChildren()) {
            throw new Exception(this + "\n子リストがNullか空です。");
        }
        return _children;
    }

    /**
     コンポーネントの名前
     一度決定したら変更はできない
     */
    private String _name;
    public String GetName() { 
        return _name;
    }

    /**
     コンポーネントの名前を指定して生成する。
     名前は一度決定したら変更することはできない。
     */
    public Abs_UIBase(String name) {
        _name = name;
    }

    /**
     子リストを初期化する。
     これを呼び出さない限り子リストの取得の度に例外が発生することになる。
     
     @throws Exception 既に子リストが存在する場合 
     */
    protected void InitChildren() throws Exception {
        if (_children != null) {
            throw new Exception(this + "\n既に子リストが存在しています。");
        }
        _children = new ArrayList<Abs_UIBase>();
    }

    /**
     子リストがNullかどうかをチェックする。
     Nullの場合は例外を発生させる。
     
     @throws Exception 子リストがNullの場合
     */
    protected void CheckChildren() throws Exception {
        if (_children == null) {
            throw new Exception(this + "\n子リストが存在しません。");
        }
    }

    /**
     子リストがNullか空かどうかを判定する。
     
     @return 子リストがNullか空の場合はtrueを返す。
     */
    public boolean IsNullOrEmptyChildren() {
        if (_children == null) {
            return true;
        }
        return _children.isEmpty();
    }

    /**
     自身のリストにコンポーネントを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     @throws Exception 子リストがNullの場合
     */
    public boolean AddComponent(Abs_UIBase comp) throws Exception {
        CheckChildren();

        if (!IsParentOf(comp)) {
            _children.add(comp);
            comp.SetParent(this);
            return true;
        }
        return false;
    }

    /**
     自身のリストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws Exception 子リストがNull もしくはindexが範囲外の場合
     */
    public Abs_UIBase GetComponent(int index) throws Exception {
        CheckChildren();

        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception(this + "indexが範囲外です。index = " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のコンポーネントを返す。
     同名のコンポーネントが存在した場合、リストの早い方を返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws Exception 子リストがNull
     */
    public Abs_UIBase GetComponent(String name) throws Exception {
        CheckChildren();
        
        Abs_UIBase comp;
        for (int i=0; i<_children.size(); i++) {
            comp = _children.get(i);
            if (comp._name.equals(name)) {
                return comp;
            }
        }
        return null;
    }


    /**
     自身のリストに指定したコンポーネントが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     @throws Exception 子リストがNullの場合
     */
    public boolean RemoveComponent(Abs_UIBase comp) throws Exception {
        CheckChildren();
        return _children.remove(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws Exception 子リストがNullの場合
     */
    public Abs_UIBase RemoveComponent(int index) throws Exception {
        CheckChildren();
        
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception(this + "indexが範囲外です。index = " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.remove(index);
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを削除する。
     同名のコンポーネントが存在した場合、リストの早い方を削除し、それを返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws Exception 子リストがNull
     */
    public Abs_UIBase RemoveComponent(String name) throws Exception {
        CheckChildren();
        
        Abs_UIBase comp;
        for (int i=0; i<_children.size(); i++) {
            comp = _children.get(i);
            if (comp._name.equals(name)) {
                return _children.remove(i);
            }
        }
        return null;
    }


    /**
     自身が、指定したコンポーネントの親であるかどうか判定する。
     
     @return 親である場合はtrueを返す。
     */
    public boolean IsParentOf(Abs_UIBase comp) {
        return this == comp._parent;
    }

    /**
     自身が、指定したコンポーネントの子であるかどうか判定する。
     
     @return 子である場合はtrueを返す。
     */
    public boolean IsChildOf(Abs_UIBase comp) {
        return _parent == comp;
    }

    /**
     指定したコンポーネントが自身の再帰的な子の関係にあるかどうか判定する。
     
     @return 指定したコンポーネントが自身の再帰的な親子関係にある場合はtrueを返す。
     */
    public boolean Contains(Abs_UIBase comp) {
        while (comp._parent != null) {
            if (this == comp._parent) {
                return true;
            }
            comp = comp._parent;
        }
        return false;
    }

    /**
     Abs_UIBaseのインスタンスであり、かつ同名であればtrueを返す。
     */
    public boolean equals(Object o) {
        if (o == this) return true;
        if (o == null) return false;
        if (!(o instanceof Abs_UIBase)) return false;
        Abs_UIBase comp = (Abs_UIBase) o;
        return _name.equals(comp._name);
    }

    public int hashCode() {
        int r = 37;
        r = r * 31 + _name.hashCode();
        // 自身の曖昧な等価判定のため、子リストのハッシュは使わない。
        return r;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIBase : name = ").append(_name).append(", children = ").append(_children);
        return b.toString();
    }
}