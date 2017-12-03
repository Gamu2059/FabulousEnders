public class PEOSceneBase extends Scene {
    public PEOSceneBase(String name, String titleText) {
        super(name);
        
        textFont(fontManager.GetFont("FFScala"));
        textSize(12);
        textAlign(CENTER, CENTER);
        float x = textWidth(titleText) + 20;
        
        SceneObject title;
        
        title = new SceneObject("Title L");
        AddObject(title);
        AddChild(title);
        title.GetDrawBack().SetEnable(false);
        title.GetTransform().InitTransform(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        new SceneObjectImage(title, PEOConst.EDITOR_GENERAL_PATH + "Title_L.png");
        
        title = new SceneObject("Title C");
        AddObject(title);
        AddChild(title);
        title.GetDrawBack().SetEnable(false);
        title.GetTransform().InitTransform(0, 0, 0, 0, 0, 0, PEOConst.TITLE_MERGIN_WIDTH, 0, 1, 1, 0, x, PEOConst.TITLE_HEIGHT);
        new SceneObjectImage(title, PEOConst.EDITOR_GENERAL_PATH + "Title_C.png");
        
        SceneObjectText _text = new SceneObjectText(title, titleText);
        _text.SetFontSize(12);
        _text.SetUsingFontName("FFScala");
        _text.SetAlign(CENTER, BASELINE);
        _text.GetColorInfo().SetColor(0, 0, 0);
        
        title = new SceneObject("Title R");
        AddObject(title);
        AddChild(title);
        title.GetDrawBack().SetEnable(false);
        title.GetTransform().InitTransform(0, 0, 0, 0, 0, 0, PEOConst.TITLE_MERGIN_WIDTH + x, 0, 1, 1, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        new SceneObjectImage(title, PEOConst.EDITOR_GENERAL_PATH + "Title_R.png");
    }
    
    protected void _SetDragHandler(SceneObject o, IEvent dragEvent) {
        if (o == null) return;
        SceneObjectDragHandler dh = new SceneObjectDragHandler(GetName() + o.GetName() + " DragHandler Label");
        o.AddBehavior(dh);

        dh.GetEnabledActiveHandler().SetEvent("mouse entered", new IEvent() {
            public void Event() {
                cursor(MOVE);
            }
        }
        );
        dh.GetDisabledActiveHandler().SetEvent("mouse exited", new IEvent() {
            public void Event() {
                cursor(ARROW);
            }
        }
        );
        dh.GetDraggedActionHandler().SetEvent("mouse dragged", dragEvent);
    }
}