/**
 UIコンポーネントをまとめて管理するためのクラス。
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

    /**
     名前を指定してシーンインスタンスを生成する。
     インスタンスは自動的にマネージャに追加される。
     */
    public UIScene(String name) {
        super(name);
        try {
            uiManager.AddComponent(this);
            super.InitChildren();
        }
        catch(Exception e) {
            println(this + e.toString());
        }
    }

    /**
     コンポーネントのアニメーション処理を呼び出す。
     アニメーションメソッドを持っていなれければ呼び出さない。
     */
    public void UpdateAnimation() {
    }

    /**
     シーンで保持しているコンポーネントを再帰的にトランスフォーム処理する。
     matrixスタックをオーバーしても例外は各コンポーネントで対処する。
     
     @throws Exception 子リストがNullか空であった場合
     */
    public void UpdateTransform() throws Exception {
        Abs_UIComponent ui;
        // シーン直下のコンポーネントだけ呼び出す
        for (int i=0; i<super.GetChildren().size(); i++) {
            try {
                ui = GetComponent(i);
                if (ui.IsChildOf(this)) {
                    ui.TransformComponent();
                }
            } 
            catch (Exception e) {
                println(this + e.toString());
            }
        }
    }

    public void SortingWithProprity() {
        
    }

    // 再帰的にシーンを描画する
    public void DrawScene() {
        try {
            for (int i=0; i<super.GetChildren().size(); i++) {
                GetComponent(i).DrawComponent();
            }
        } 
        catch(Exception e) {
        }
    }




    /**
     自身のリストにコンポーネントを追加する。
     ただし、既に子として追加されている場合は追加できない。yo
     
     @return 追加に成功した場合はtrueを返す
     @throws Exception 指定コンポーネントがコンポーネントインスタンスでない場合
     指定コンポーネントが既に追加されている場合
     @throws NullPointerException 子リストがNullの場合
     */
    public boolean AddComponent(Abs_UIComponent comp) throws NullPointerException, Exception {
        if (!(comp instanceof Abs_UIComponent)) {
            throw new Exception(this + "\nAbs_UIComponentインスタンスでないコンポーネントが指定されました。");
        }
        if (GetComponent(comp.GetName()) != null) {
            throw new Exception(this + "\n既に同名のコンポーネントインスタンスが存在するため追加することができません。 name = " + comp.GetName());
        }
        return super.AddComponent(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull 
     @throws ArrayIndexOutOfBoundsException indexが範囲外の場合
     @throws Exception 取得したインスタンスがコンポーネントインスタンスでなかった場合
     */
    public Abs_UIComponent GetComponent(int index) throws ArrayIndexOutOfBoundsException, NullPointerException, Exception {
        return _CastToUIComponent(super.GetComponent(index));
    }

    /**
     自身のリストの中からnameと一致する名前のコンポーネントを返す。
     同名のコンポーネントが存在した場合、リストの早い方を返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull
     @throws Exception 取得したインスタンスがコンポーネントインスタンスでなかった場合
     */
    public Abs_UIComponent GetComponent(String name) throws NullPointerException, Exception {
        return _CastToUIComponent(super.GetComponent(name));
    }

    /**
     自身のリストに指定したコンポーネントが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     @throws Exception 指定コンポーネントがUISceneインスタンスでない場合
     @throws NullPointerException 子リストがNullの場合
     */
    public boolean RemoveComponent(Abs_UIComponent comp) throws NullPointerException, Exception {
        if (!(comp instanceof Abs_UIComponent)) {
            throw new Exception(this + "\nAbs_UIComponentインスタンスでないコンポーネントが指定されました。");
        }
        return super.RemoveComponent(comp);
    }

    /**
     自身のリストのindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull 
     @throws ArrayIndexOutOfBoundsException indexが範囲外の場合
     @throws Exception 削除したインスタンスがコンポーネントインスタンスでなかった場合
     */
    public Abs_UIComponent RemoveComponent(int index) throws ArrayIndexOutOfBoundsException, NullPointerException, Exception {
        return _CastToUIComponent(super.RemoveComponent(index));
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを削除する。
     同名のコンポーネントが存在した場合、リストの早い方を削除し、それを返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     @throws NullPointerException 子リストがNull
     @throws Exception 削除したインスタンスがコンポーネントインスタンスでなかった場合
     */
    public Abs_UIComponent RemoveComponent(String name) throws NullPointerException, Exception {
        return _CastToUIComponent(super.RemoveComponent(name));
    }

    /**
     引数に渡されたインスタンスをコンポーネントインスタンスにキャストして返す。
     
     @throws Exception 指定コンポーネントがAbs_UIComponentインスタンスでない場合
     */
    private Abs_UIComponent _CastToUIComponent(Object o) throws Exception {
        if (!(o instanceof Abs_UIComponent)) {
            throw new Exception(this + "\nUISceneインスタンスでないコンポーネントが指定されました。");
        }
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
        try {
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
        catch(Exception e) {
        }
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nUIScene : name = ").append(super.GetName()).append(", MOC = ").append(_moc).append(", MAC = ").append(_mac);
        return b.toString();
    }
}