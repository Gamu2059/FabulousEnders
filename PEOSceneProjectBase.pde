/**
 プロジェクトビューの基底クラス。
 */
public class PEOSceneProjectBase extends PEOSceneBase {
    public PEOSceneProjectBase(String name) {
        super(name);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 1);
        t.GetAnchor().SetMax(0, 1);
        t.GetPivot().SetPivot(0, 1);

        SceneObject slider;

        slider = new SceneObject("Project to Hierarchy Slider");
        //slider.GetDrawBack().SetEnable(false);
        slider.GetDrawBack().GetBackColorInfo().SetColor(0, 0, 200);
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
        slider.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        AddObject(slider);
        AddChild(slider);

        _SetTransform(slider, 0, 0, 1, 0, 0.5, 0, 0, 4);
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

        float v2h, v2p;
        v2h = peoScenePositionManager.GetVtoH();
        v2p = peoScenePositionManager.GetVtoP();
        
        GetTransform().SetSize(v2h, height - v2p);
    }
}