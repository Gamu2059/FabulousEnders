/**
 UIコンポーネントをまとめて管理するためのクラス。
 シーンを単位として画面を構成する。
 */
public final class UIManager extends Abs_UIBase {
    private UIScene _activeScene;
    public UIScene GetAcriveScene() { 
        return _activeScene;
    }

    /**
     UIマネージャを生成する。
     名前は自動的に"UIManager"になる。
     */
    public UIManager() {
        super("UIManager");
        try {
            InitChildren();
        } 
        catch(Exception e) {
            println(this + e.toString());
        }
    }

    /**
     自身のリストにコンポーネントを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     @throws Exception 指定コンポーネントがUISceneインスタンスでない場合
     指定コンポーネントが既に追加されている場合
     @throws NullPointerException 子リストがNullの場合
     */
    public boolean AddComponent(Abs_UIBase comp) throws Exception {
        if (!(comp instanceof UIScene)) {
            throw new Exception(this + "\nUISceneインスタンスでないコンポーネントが指定されました。");
        }
        if (GetComponent(comp.GetName()) != null) {
            throw new Exception(this + "\n既に同名のシーンインスタンスが存在するため追加することができません。 name = " + comp.GetName());
        }
        return super.AddComponent(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull 
     @throws ArrayIndexOutOfBoundsException indexが範囲外の場合
     @throws Exception 取得したインスタンスがシーンインスタンスでなかった場合
     */
    public UIScene GetComponent(int index) throws ArrayIndexOutOfBoundsException, NullPointerException, Exception {
        return _CastToUIScene(super.GetComponent(index));
    }

    /**
     自身のリストの中からnameと一致する名前のコンポーネントを返す。
     同名のコンポーネントが存在した場合、リストの早い方を返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull
     @throws Exception 取得したインスタンスがシーンインスタンスでなかった場合
     */
    public UIScene GetComponent(String name) throws NullPointerException, Exception {
        return _CastToUIScene(super.GetComponent(name));
    }

    /**
     自身のリストに指定したコンポーネントが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     @throws Exception 指定コンポーネントがUISceneインスタンスでない場合
     @throws NullPointerException 子リストがNullの場合
     */
    public boolean RemoveComponent(UIScene comp) throws NullPointerException, Exception {
        if (!(comp instanceof UIScene)) {
            throw new Exception(this + "\nUISceneインスタンスでないコンポーネントが指定されました。");
        }
        return super.RemoveComponent(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull 
     @throws ArrayIndexOutOfBoundsException indexが範囲外の場合
     @throws Exception 削除したインスタンスがシーンインスタンスでなかった場合
     */
    public UIScene RemoveComponent(int index) throws ArrayIndexOutOfBoundsException, NullPointerException, Exception {
        return _CastToUIScene(super.RemoveComponent(index));
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを削除する。
     同名のコンポーネントが存在した場合、リストの早い方を削除し、それを返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull
     @throws Exception 削除したインスタンスがシーンインスタンスでなかった場合
     */
    public UIScene RemoveComponent(String name) throws NullPointerException, Exception {
        return _CastToUIScene(super.RemoveComponent(name));
    }

    /**
     UIManagerは全てのコンポーネントの最上位に存在するため、子になることはない。
     */
    public boolean IsChildOf(Abs_UIBase comp) {
        if (super.IsChildOf(comp)) {
            println(this + "\n指定されたコンポーネントの子として存在しています！ component = " + comp);
        }
        return false;
    }

    /**
     引数に渡されたインスタンスをシーンインスタンスにキャストして返す。
     
     @throws Exception 指定コンポーネントがUISceneインスタンスでない場合
     */
    private UIScene _CastToUIScene(Object o) throws Exception {
        if (!(o instanceof UIScene)) {
            throw new Exception(this + "\nUISceneインスタンスでないコンポーネントが指定されました。");
        }
        return (UIScene) o;
    }

    /**
     指定された名前に該当するシーンインスタンスをアクティブシーンとする。
     これが呼び出された次のフレームから描画が切り替わる。
     
     @throws NullPointerException 子リストがNull
     @throws Exception シーンのロード失敗
     */
    public void LoadScene(String name) throws NullPointerException, Exception {
        UIScene scene = GetComponent(name);
        if (scene == null) {
            throw new Exception(this + "\nシーンのロードに失敗しました。");
        }
        _activeScene = scene;
    }

    /**
     シーンを更新する。
     厳密には更新されるのはアクティブシーンのみである。
     */
    public void UpdateScene() {
        background(255);
        if (_activeScene == null) return;

        // コンポーネントのアニメーション処理

        // コンポーネントのトランスフォーム処理
        
        // 描画優先順位の変更
        
        // MOC及びMACの判定
        
        // MOC切り替え
        
        // MAC切り替え
        
        // コンポーネントの描画
    }

    /**
     自分自身でない限り等価なインスタンスは存在しない。
     */
    public boolean equals(Object o) {
        if (o == this) return true; 
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIManager : scene num = ").append(super._children.size()).append(", scene = ").append(super._children);
        return b.toString();
    }
}