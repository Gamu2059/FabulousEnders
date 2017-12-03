public class PEOSceneMenuBar extends Scene {
    public PEOSceneMenuBar() {
        super("Menu Bar");

        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 0);
        SceneObjectTransform t = GetTransform();
        t.SetSize(width, PEOConst.MENU_BAR_HEIGHT);
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(1, 0);
        t.GetPivot().SetPivot(0.5, 0);

        PEOMenuBar menuBarObj = new PEOMenuBar("Menu Bar");
        AddObject(menuBarObj);
        AddChild(menuBarObj);

        PEOMenu menuObj;
        menuObj = new PEOMenu("File Menu", "File");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Edit Menu", "Edit");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("GameObject Menu", "GameObject");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Behavior Menu", "Behavior");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Window Menu", "Window");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
    }
}