/**
 プロジェクトビューの基底クラス。
 */
public class PEOSceneProjectBase extends PEOSceneBase {
    public PEOSceneProjectBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 1);
        t.GetAnchor().SetMax(0, 1);
        t.GetPivot().SetPivot(0, 1);
        t.SetTranslation(0, -PEOConst.EXPLAIN_BAR_HEIGHT);

        SceneObject slider;

        slider = new SceneObject("Project to Hierarchy Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(1, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );
        
        slider = new SceneObject("View to Project Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 0, 1, 0, 0.5, 0, 0, 0, 1, 1, 0, 0, PEOConst.SLIDE_SPACE);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dy = mouseY - pmouseY;
                peoScenePositionManager.SlideOnVtoP(mouseY + dy);
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

        float v2h, v2p;
        v2h = peoScenePositionManager.GetVtoH();
        v2p = peoScenePositionManager.GetVtoP();
        
        GetTransform().SetSize(v2h, height - v2p - PEOConst.EXPLAIN_BAR_HEIGHT);
    }
}