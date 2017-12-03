public class Scene_MenuBar extends Scene {
    public Scene_MenuBar() {
        super("Menu Bar");

        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 0);
        SceneObjectTransform t = GetTransform();
        t.SetSize(width, 20);
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(1, 0);
        t.GetPivot().SetPivot(0.5, 0);

        PMenuBar menuBarObj = new PMenuBar("Menu Bar");
        AddObject(menuBarObj);
        AddChild(menuBarObj);

        PMenu menuObj;
        menuObj = new PMenu("File Menu", "File");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PMenu("Edit Menu", "Edit");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PMenu("GameObject Menu", "GameObject");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PMenu("Behavior Menu", "Behavior");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PMenu("Window Menu", "Window");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
    }
}