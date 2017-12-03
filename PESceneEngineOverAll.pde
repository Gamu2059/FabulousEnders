public class PESceneEngineOverAll extends Scene {
    public PESceneEngineOverAll() {
        super("Engine Over All");
        
        GetDrawBack().GetBackColorInfo().SetColor(0, 150, 255);
        SceneObjectTransform t = GetTransform();
        t.SetSize(width, 0);
        // 上部のメニューバーと操作部の分だけ下げる
        t.GetAnchor().SetMin(0, 52f/height);
        t.GetAnchor().SetMax(1, 1);
        
        PESceneTest test = new PESceneTest();
        test.GetDrawBack().GetBackColorInfo().SetColor(0, 150, 200);
        SceneObjectTransform objT = test.GetTransform();
        objT.GetAnchor().SetMin(0, 0);
        objT.GetAnchor().SetMax(0.7, 1);
        AddChild(test.GetTransform());
    }
}