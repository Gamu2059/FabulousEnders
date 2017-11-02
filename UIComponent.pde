/*
UIコンポーネントの基礎的な処理をサポートする。
 */
public class UIComponent implements Comparable<UIComponent> {
    private UIComponent parent;
    private ArrayList<UIComponent> children;

    private String name;
    private int depth;

    public UIComponent() {
        this.name = "untitled";
        this.depth = 0;
        this.children = new ArrayList<UIComponent>();
    }

    public UIComponent(String name) {
        this.name = name;
        this.depth = 0;
        this.children = new ArrayList<UIComponent>();
    }
    
    public UIComponent(String name, int depth) {
        this.name = name;
        this.depth = depth;
        this.children = new ArrayList<UIComponent>();
    }

    /*
     自身の子リストに指定したコンポーネントを追加する。
     */
    public void Add(UIComponent child) {
        child.Replace();
        child.parent = this;
        children.add(child);
        child.depth = depth + 1;
    }

    /*
    自身の子リストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     存在しない場合はnullを返す。
     */
    public UIComponent Get(int index) {
        if (index >= children.size() || -index > children.size()) {
            return null;
        }
        if (index < 0) {
            index += children.size();
        }
        return children.get(index);
    }

    /*
    自身の子リストの中からnameと一致するコンポーネントを返す。
     存在しない場合はnullを返す。
     */
    public UIComponent Get(String name) {
        UIComponent comp;
        for (int i=0; i<children.size(); i++) {
            comp = children.get(i);
            if (comp.name.equals(name)) {
                return comp;
            }
        }
        return null;
    }

    /*
     自身の子リストからindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     削除に成功した場合は削除したコンポーネントを返す。
     削除に失敗した場合はnullを返す。
     */
    public UIComponent Remove(int index) {
        if (index >= children.size() || -index > children.size()) {
            return null;
        }
        if (index < 0) {
            index += children.size();
        }
        return children.remove(index);
    }

    /*
     自身の子リストに指定したコンポーネントが存在すれば削除する。
     削除に成功した場合はtrueを返す。
     */
    public boolean Remove(UIComponent comp) {
        return children.remove(comp);
    }

    public void Replace() {
        if (parent != null) {
            parent.Remove(this);
        }
    }

    /*
    自身が指定したコンポーネントの親であればtrueを返す。
     */
    public boolean IsParent(UIComponent comp) {
        return comp.IsChild(this);
    }

    /*
    自身が指定したコンポーネントの子であればtrueを返す。
     */
    public boolean IsChild(UIComponent comp) {
        return parent == comp;
    }

    /*
    指定したコンポーネントが自身の再帰的な子の関係にあればtrueを返す。
     */
    public boolean IsContent(UIComponent comp) {
        UIComponent u = comp;
        while (comp.parent != null) {
            if (this == comp.parent) {
                return true;
            }
            comp = comp.parent;
        }
        return false;
    }

    /*
    x, y座標が自身の描画範囲内であればtrueを返す。
     */
    //public abstract boolean IsIn(int x, int y);

    // 自身がMOCになった時に自動的に呼び出される。
    public void MouseEntered() {
    }

    // 自身がMOCでなくなった時に自動的に呼び出される。
    public void MouseExited() {
    }

    // 自身がMOCかつ、マウスボタンが押された時に自動的に呼び出される。
    public void MousePressed() {
    }

    // 自身がMOCかつ、マウスボタンが離された時に自動的に呼び出される。
    public void MouseReleased() {
    }

    // 自身がMOCかつ、マウスボタンがクリックされた時に自動的に呼び出される。
    public void MouseClicked() {
    }

    // 自身がMOCかつ、マウスホイールが回転している間自動的に呼び出される。
    public void MouseWheel() {
    }

    // 自身がMOCかつ、マウスカーソルが移動している間自動的に呼び出される。
    public void MouseMoved() {
    }

    // 自身がMOCかつ、マウスドラッグしている間自動的に呼び出される。
    public void MouseDragged() {
    }

    // UIComponentレベルでは等価判定は等値かどうかとなる。
    public boolean equals(Object o) {
        return this == o;
    }

    public int hashCode() {
        int r = 37;
        r = r * 31 + name.hashCode();
        r = r * 31 + depth;
        // 自身の曖昧な等価判定のため、子リストのハッシュは使わない。
        return r;
    }

    public int compareTo(UIComponent u) {
        return depth - u.depth;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIComponent : name = ").append(name).append(", depth = ").append(depth).append(", children num = ").append(children.size());
        return b.toString();
    }
}