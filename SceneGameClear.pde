public class SceneGameClear extends Scene {
    public SceneGameClear() {
        super(SceneID.SID_GAMECLEAR);

        SceneObject obj = new SceneObject("back", this);
        new SceneObjectImage(obj, "gameclear/gameclear.png");
        SceneObjectButton btn = new SceneObjectButton(obj, "GameClear Scene Button");
        btn.GetDecideHandler().GetEvents().Add("On Click", new IEvent() {
            public void Event() {
                ((SceneTitle)sceneManager.GetScene(SceneID.SID_TITLE)).GoTitle();
            }
        }
        );

        obj = new SceneObject("text", this);
        SceneObjectTransform objT = obj.GetTransform();
        objT.SetAnchor(0.5, 1, 0.5, 1);
        objT.SetPivot(0.5, 1);
        objT.SetSize(300, 80);
        objT.SetTranslation(0, -120);
        SceneObjectText tex = new SceneObjectText(obj, "プレイしていただきありがとうございます。\nクリックするとタイトルに戻ることができます。");
        tex.SetFontSize(20);
        tex.SetAlign(CENTER, CENTER);
        tex.SetDrawInOrder(true);
        tex.SetDrawSpeed(8);
    }

    public void OnEnabled() {
        super.OnEnabled();
    }
}