/**
 UIManagerを含む、全てのUI系コンポーネントの基底クラス。
 完成はされているが、抽象クラスとして定義される。
 */
public  class UIBase {
    private UIBase _parent;
    public UIBase GetParent() { return _parent; }
    public void SetParent(UIBase parent) { _parent = parent; }
    
    private ArrayList<UIBase> _children;
    public ArrayList<UIBase> GetChildren() { return _children; }
    
    
    private String _name;
    public String GetName() { return _name; }

    public UIBase(String name) {
        _name = name;
    }
    
    protected void InitChildren() {
        _children = new ArrayList<UIBase>();
    }

    /**
     自身のリストにコンポーネントを追加する。
     ただし、既に追加されていた場合は追加できない。
     追加に成功した場合はtrueを返す。
     */
    public boolean AddComponent(UIBase comp) {
        if (!IsParentOf(comp)) {
            _children.add(comp);
            return true;
        }
        return false;
    }

    /**
     自身のリストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     存在しない場合はnullを返す。
     */
    public UIBase GetComponent(int index) {
        if (_children == null) {
            return null;
        }
        if (index >= _children.size() || -index > _children.size()) {
            return null;
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.get(index);
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを返す。
     同名のコンポーネントが存在した場合、リストの早い方を取得する。
     存在しない場合はnullを返す。
     */
    public UIBase GetComponent(String name) {
        if (_children == null) {
            return null;
        }
        UIBase comp;
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
     削除に成功した場合はtrueを返す。
     */
    public boolean RemoveComponent(UIBase comp) {
        if (_children == null) {
            return false;
        }
        return _children.remove(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     削除に成功した場合は削除したコンポーネントを返す。
     削除に失敗した場合はnullを返す。
     */
    public UIBase RemoveComponent(int index) {
        if (_children == null) {
            return null;
        }
        if (index >= _children.size() || -index > _children.size()) {
            return null;
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.remove(index);
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを削除する。
     同名のコンポーネントが存在した場合、リストの早い方を削除し、それを返す。
     存在しない場合はnullを返す。
     */
    public UIBase RemoveComponent(String name) {
        if (_children == null) {
            return null;
        }
        UIBase comp;
        for (int i=0; i<_children.size(); i++) {
            comp = _children.get(i);
            if (comp._name.equals(name)) {
                return _children.remove(i);
            }
        }
        return null;
    }


    /**
     自身が、指定したコンポーネントの親であればtrueを返す。
     */
    public boolean IsParentOf(UIBase comp) {
        return this == comp._parent;
    }

    /**
    自身が、指定したコンポーネントの子であればtrueを返す。
     */
    public boolean IsChildOf(UIBase comp) {
        return _parent == comp;
    }

    /**
    指定したコンポーネントが自身の再帰的な子の関係にあればtrueを返す。
     */
    public boolean Contains(UIBase comp) {
        if (comp == null) {
            return false;
        }
        while (comp._parent != null) {
            if (this == comp._parent) {
                return true;
            }
            comp = comp._parent;
        }
        return false;
    }

    /**
    名前が一致するならば、等価とする。
    */
    public boolean equals(Object o) {
        if (o == this) return true;
        if (o == null) return false;
        if (!(o instanceof UIBase)) return false;
        UIBase comp = (UIBase) o;
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