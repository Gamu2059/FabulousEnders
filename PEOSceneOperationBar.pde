public class PEOSceneOperationBar extends Scene {

    public PEOSceneOperationBar() {
        super("Operation Bar");

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        
        float selfH, menuH;
        selfH = peoScenePositionManager.OPERATION_BAR_HEIGHT;
        menuH = peoScenePositionManager.MENU_BAR_HEIGHT;
        _SetTransform(GetTransform(), width, selfH, 0, menuH, 0, 0, 1, 0, 0.5, 0);

        SceneObject opeObj;

        String[] paths = new String[]{
            "Hand", 
            "Translate", 
            "Rotate", 
            "Scale", 
            "Pivot"
        };

        float x = 10;
        for (int i=0; i<paths.length; i++, x+=32) {
            opeObj = new SceneObject(paths[i]+" Ope");
            opeObj.GetDrawBack().SetEnable(false);
            AddObject(opeObj);
            AddChild(opeObj);
            _SetTransform(opeObj.GetTransform(), 32, 22, x, 0, 0, 0.5, 0, 0.5, 0, 0.5);
            _SetImage(opeObj, paths[i]+"_Off.png");
            _SetToggleButton(opeObj, paths[i]+"_On.png", paths[i]+"_Off.png");
        }

        opeObj = new SceneObject("Play Ope");
        opeObj.GetDrawBack().SetEnable(false);
        AddObject(opeObj);
        AddChild(opeObj);
        _SetTransform(opeObj.GetTransform(), 32, 22, 0, 0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5);
        _SetImage(opeObj, "Play_Off.png");
        _SetToggleButton(opeObj, "Play_On.png", "Play_Off.png");
    }

    private void _SetTransform(SceneObjectTransform t, float w, float h, float x, float y, float minAX, float minAY, float maxAX, float maxAY, float pX, float pY) {
        if (t == null) return;
        t.SetTranslation(x, y);
        t.SetSize(w, h);
        t.GetAnchor().SetMin(minAX, minAY);
        t.GetAnchor().SetMax(maxAX, maxAY);
        t.GetPivot().SetPivot(pX, pY);
    }

    private void _SetImage(SceneObject o, String fileName) {
        if (o == null) return;
        SceneObjectImage img = new SceneObjectImage();
        o.AddBehavior(img);
        img.SetUsingImageName(ImageManager.OPERATION_BAR_PATH + fileName);
    }

    private void _SetToggleButton(SceneObject o, String onFile, String offFile) {
        if (o == null) return;
        String path = ImageManager.OPERATION_BAR_PATH;
        SceneObjectToggleButton btn = new SceneObjectToggleButton(o.GetName() + " OperationBar Label" , path + onFile, path + offFile);
        o.AddBehavior(btn);
    }
}