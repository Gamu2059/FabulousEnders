/**
 インスペクターの基底クラス。
 */
public class PEOSceneInspectorBase extends PEOSceneBase {
    public PEOSceneInspectorBase(String name) {
        super(name);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;
        
        slider = new SceneObject("Hierarchy to Inspector Slider");
        //slider.GetDrawBack().SetEnable(false);
        slider.GetDrawBack().GetBackColorInfo().SetColor(200, 0, 200);
        AddObject(slider);
        AddChild(slider);

        _SetTransform(slider, 0, 0, 0, 1, 0, 0.5, 4, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnHtoI(mouseX + dx);
            }
        }
        );
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float h2i, h;
        h = PEOConst.BAR_HEIGHT;
        h2i = peoScenePositionManager.GetHtoI();
        
        GetTransform().SetTranslation(h2i, h);
        GetTransform().SetSize(width - h2i, height - h);
    }
}