/**
 
 */
public class UIPanel extends Abs_UIComponent {
    public UIPanel(String componentName, UIScene scene) {
        super(componentName, scene);
        try{
        super.InitChildren();
        } 
        catch(Exception e) {
        }
    }

    public void DrawComponent() {
        super.DrawBack();
    }

    public boolean AddComponent(Abs_UIComponent comp) throws Exception {
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

    public Abs_UIComponent GetComponent(int index) throws Exception {
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
}