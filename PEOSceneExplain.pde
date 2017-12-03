public class PEOSceneExplain extends Scene {
    public PEOSceneExplain() {
        super("Explain");
        
        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.SetSize(0, PEOConst.MENU_BAR_HEIGHT);
        t.GetAnchor().SetMin(0, 1);
        t.GetAnchor().SetMax(1, 1);
        t.GetPivot().SetPivot(0.5, 1);
    }
}