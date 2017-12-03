/**
 メインビューの基底クラス。
 */
public class PEOSceneViewBase extends PEOSceneBase {
    public PEOSceneViewBase(String name) {
        super(name);

        GetDrawBack().GetBackColorInfo().SetColor(0, 255, 0);
        SceneObjectTransform t = GetTransform();
        float h = peoScenePositionManager.MENU_BAR_HEIGHT + peoScenePositionManager.OPERATION_BAR_HEIGHT;
        t.SetTranslation(0, h);
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;

        slider = new SceneObject("View to Hierarchy Slider");
        //slider.GetDrawBack().SetEnable(false);
        slider.GetDrawBack().GetBackColorInfo().SetColor(200, 0, 0, 100);
        AddObject(slider);
        AddChild(slider);

        _SetTransform(slider, 1, 0, 1, 1, 1, 0.5, 4, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );
        
        slider = new SceneObject("View to Project Slider");
        //slider.GetDrawBack().SetEnable(false);
        slider.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200, 100);
        AddObject(slider);
        AddChild(slider);

        _SetTransform(slider, 0, 1, 1, 1, 0.5, 1, 0, 4);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dy = mouseY - pmouseY;
                peoScenePositionManager.SlideOnVtoP(mouseY + dy);
            }
        }
        );
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float v2h, v2p, h;
        h = peoScenePositionManager.MENU_BAR_HEIGHT + peoScenePositionManager.OPERATION_BAR_HEIGHT;
        v2h = peoScenePositionManager.GetVtoH();
        v2p = peoScenePositionManager.GetVtoP();
        
        GetTransform().SetSize(v2h, v2p - h);
    }
}