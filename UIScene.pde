/**
 一つのシーンのコンポーネントを管理するためのクラス。
 */
public class UIScene extends UIBase {
    private UIComponent _moc, _mac;
    public UIComponent GetMOC() { 
        return _moc;
    }
    public UIComponent GetMAC() { 
        return _mac;
    }

    public UIScene(String name) {
        super(name);
        uiManager.AddComponent(this);
    }

    public boolean AddComponent(UIComponent comp) {
        if (comp == null) return false;
        if (!(comp instanceof UIComponent)) {
            println("シーンにコンポーネント以外のインスタンスが追加されようとしました。");
            println("シーンにはコンポーネント及びそのサブクラスのインスタンスしか格納することができません。");
            return false;
        }
        if (GetComponent(comp.GetName()) != null) {
            println("既に同名のシーンが存在するため、追加することができません。");
            println("UIManagerには同名のシーンインスタンスは格納することができません。");
            return false;
        }
        return super.AddComponent(comp);
    }

    public UIComponent GetComponent(int index) {
        return _CastToUIComponent(super.GetComponent(index));
    }

    public UIComponent GetComponent(String name) {
        return _CastToUIComponent(super.GetComponent(name));
    }

    public boolean RemoveComponent(UIComponent comp) {
        if (comp == null) return false;
        if (!(comp instanceof UIComponent)) return false;
        return super.RemoveComponent(comp);
    }

    public UIComponent RemoveComponent(int index) {
        return _CastToUIComponent(super.RemoveComponent(index));
    }

    public UIComponent RemoveComponent(String name) {
        return _CastToUIComponent(super.RemoveComponent(name));
    }

    /**
     引数に渡されたインスタンスをコンポーネントインスタンスにキャストして返す。
     キャストできない場合はnullが返される。
     */
    private UIComponent _CastToUIComponent(Object o) {
        if (!(o instanceof UIComponent)) return null;
        return (UIComponent) o;
    }

    /**
     MOCの判定を行う。
     スクリーン上にマウスが存在しない場合は、MOCはnullになる。
     */
    public void CheckMOC() {
        int x, y, w, h;
        x = mouseX;
        y = mouseY;
        w = width;
        h = height;

        if  (x < 0 || x >= w || y < 0 || y >= height) {
            _moc = null;
            return;
        }
        if (GetChildren() == null) {
            _moc = null;
            return;
        }

        UIComponent ui;
        for (int i=GetChildren().size()-1; i>=0; i--) {
            ui = GetComponent(i);
            if (ui == null) {
                continue;
            }
            
            //ui.IsOverlappedOf(x, y);
        }
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIScene : name = ").append(super.GetName()).append(", MOC = ").append(_moc).append(", MAC = ").append(_mac);
        return b.toString();
    }
}