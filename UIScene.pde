/**
 一つのシーンのコンポーネントを管理するためのクラス。
 */
public class UIScene extends Abs_UIBase {
    // Mouse Overlapped Component
    private Abs_UIComponent _moc;
    public Abs_UIComponent GetMOC() { 
        return _moc;
    }
    
    // Mouse Active Component
    private Abs_UIComponent _mac;
    public Abs_UIComponent GetMAC() { 
        return _mac;
    }


    public UIScene(String name) {
        super(name);
        super.InitChildren();
        uiManager.AddComponent(this);
    }

    /**
    シーンで保持しているコンポーネントを再帰的に変形させる。
    */
    public void UpdateTransform() {
        Abs_UIComponent ui;
        // シーン直下のコンポーネントだけ呼び出す
        for (int i=0;i<super.GetChildren().size();i++) {
            ui = GetComponent(i);
            if (ui.IsChildOf(this)) {
                ui.TransformComponent(sceneTransform);
            }
        }
    }

    // 再帰的にシーンを描画する
    public void DrawScene(){
        for (int i=0;i<super.GetChildren().size();i++) {
            GetComponent(i).DrawComponent();
        }
    }

    public boolean AddComponent(Abs_UIComponent comp) {
        if (comp == null) return false;
        if (!(comp instanceof Abs_UIComponent)) {
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

    public Abs_UIComponent GetComponent(int index) {
        return _CastToUIComponent(super.GetComponent(index));
    }

    public Abs_UIComponent GetComponent(String name) {
        return _CastToUIComponent(super.GetComponent(name));
    }

    public boolean RemoveComponent(Abs_UIComponent comp) {
        if (comp == null) return false;
        if (!(comp instanceof Abs_UIComponent)) return false;
        return super.RemoveComponent(comp);
    }

    public Abs_UIComponent RemoveComponent(int index) {
        return _CastToUIComponent(super.RemoveComponent(index));
    }

    public Abs_UIComponent RemoveComponent(String name) {
        return _CastToUIComponent(super.RemoveComponent(name));
    }

    /**
     引数に渡されたインスタンスをコンポーネントインスタンスにキャストして返す。
     キャストできない場合はnullが返される。
     */
    private Abs_UIComponent _CastToUIComponent(Object o) {
        if (!(o instanceof Abs_UIComponent)) return null;
        return (Abs_UIComponent) o;
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

        Abs_UIComponent ui;
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