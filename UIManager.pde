/**
 UIコンポーネントを一元管理するためのクラス。
 格納単位はUIScene。
 */
public final class UIManager extends UIBase {
    private UIScene _activeScene;
    public UIScene GetAcriveScene() { return _activeScene; }
    
    private UIScene _preScene;
    public UIScene GetPreScene() { return _preScene; }

    public UIManager() {
        super("UIManager");
        InitChildren();
    }

    public boolean AddComponent(UIBase comp) {
        if (comp == null) return false;
        if (!(comp instanceof UIScene)) {
            println("UIマネージャにシーン以外のインスタンスが追加されようとしました。");
            println("UIマネージャにはシーン及びそのサブクラスのインスタンスしか格納することができません。");
            return false;
        }
        if (GetComponent(comp.GetName()) != null) {
            println("既に同名のシーンが存在するため、追加することができません。");
            println("UIマネージャには同名のシーンインスタンスは格納することができません。");
            return false;
        }
        return super.AddComponent(comp);
    }

    public UIScene GetComponent(int index) {
        return _CastToUIScene(super.GetComponent(index));
    }

    public UIScene GetComponent(String name) {
        return _CastToUIScene(super.GetComponent(name));
    }

    public boolean RemoveComponent(UIScene comp) {
        if (comp == null) return false;
        if (!(comp instanceof UIScene)) return false;
        return super.RemoveComponent(comp);
    }

    public UIScene RemoveComponent(int index) {
        return _CastToUIScene(super.RemoveComponent(index));
    }

    public UIScene RemoveComponent(String name) {
        return _CastToUIScene(super.RemoveComponent(name));
    }

    /**
     UIManagerは全てのコンポーネントの最上位に存在するため、子になることはない。
     */
    public boolean IsChildOf(UIBase comp) {
        return false;
    }

    /**
     引数に渡されたインスタンスをシーンインスタンスにキャストして返す。
     キャストできない場合はnullが返される。
     */
    private UIScene _CastToUIScene(Object o) {
        if (!(o instanceof UIScene)) return null;
        return (UIScene) o;
    }

    /*
    指定された名前に該当するシーンインスタンスをアクティブシーンとして、描画を開始する。
     **/
    public void LoadScene(String name) {
        UIScene scene = GetComponent(name);
        if (scene == null) {
            println("シーンのロードでエラーが発生しました。");
            println(name + "に該当する名前のシーンが存在しないかシーンでないインスタンスが返ってきた可能性があります。");
            return;
        }
        _preScene = _activeScene;
        _activeScene = scene;
        
        // TODO:シーントランジションアニメーションを作成できるならば、作る。
        DrawScene();
    }

    /**
     アクティブシーンを描画する。
     */
    public void DrawScene() {
        if (_activeScene == null) return;
        background(255);
        
        // TODO:シーンの描画処理を呼び出す。
    }
    
    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIManager : scene num = ").append(super._children.size()).append(", scene = ").append(super._children);
        return b.toString();
    }
}