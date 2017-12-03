public class PEOSceneOperationBar extends Scene {

    public PEOSceneOperationBar() {
        super("Operation Bar");

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);

        float selfH, menuH;
        selfH = PEOConst.OPERATION_BAR_HEIGHT;
        menuH = PEOConst.MENU_BAR_HEIGHT;
        GetTransform().InitTransform(0, 0, 1, 0, 0.5, 0, 0, menuH, 1, 1, 0, width, selfH);

        SceneObject opeObj;

        String[] paths = new String[]{
            "Hand", 
            "Translate", 
            "Rotate", 
            "Scale", 
            "Pivot", 
            "Play"
        };

        float x = 10;
        String basePath;
        for (int i=0; i<paths.length; i++, x+=32) {
            basePath = PEOConst.OPERATION_BAR_PATH + paths[i];

            opeObj = new SceneObject(paths[i]+" Ope");
            opeObj.GetDrawBack().SetEnable(false);
            AddObject(opeObj);
            AddChild(opeObj);
            if (i < paths.length - 1) {
                opeObj.GetTransform().InitTransform(0, 0.5, 0, 0.5, 0, 0.5, x, 0, 1, 1, 0, 32, 22);
            } else {
                opeObj.GetTransform().InitTransform(0.5, 0.5, 0.5, 0.5, 0, 0.5, 0, 0, 1, 1, 0, 32, 22);
            }
            new SceneObjectImage(opeObj, basePath +"_Off.png");
            new SceneObjectToggleButton(opeObj, opeObj.GetName() + " OperationBar Label", basePath +"_On.png", basePath +"_Off.png");
        }
    }
}