/**
 ヒエラルキーの基底クラス。
 */
public class PEOSceneHeararchyBase extends PEOSceneBase {
    public PEOSceneHeararchyBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;

        slider = new SceneObject("View to Hierarchy Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 0, 0, 1, 0, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );
        
        slider = new SceneObject("Hierarchy to Inspector Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(1, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnHtoI(mouseX + dx);
            }
        }
        );
        
        SceneObject back = new SceneObject("BackGroung");
        back.GetDrawBack().GetBackColorInfo().SetColor(194, 194, 194);
        back.GetDrawBack().GetBorderColorInfo().SetColor(130, 130, 130);
        AddObject(back);
        AddChild(back);
        t = back.GetTransform();
        t.InitTransform(0, 0, 1, 1, 0.5, 0.5, 0, 0, 1, 1, 0, 0, 0);
        t.SetOffsetMin(PEOConst.SLIDE_SPACE+1, PEOConst.TITLE_HEIGHT+PEOConst.HEADER_HEIGHT);
        t.SetOffsetMax(-PEOConst.SLIDE_SPACE-1, -PEOConst.SLIDE_SPACE-3);
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float v2h, h2i, h;
        h = PEOConst.BAR_HEIGHT;
        v2h = peoScenePositionManager.GetVtoH();
        h2i = peoScenePositionManager.GetHtoI();
        
        GetTransform().SetTranslation(v2h, h);
        GetTransform().SetSize(h2i - v2h, height - h - PEOConst.EXPLAIN_BAR_HEIGHT);
    }
}