public class PEOSceneBase extends Scene {
    public PEOSceneBase(String name, String titleText) {
        super(name);
        
        textFont(fontManager.GetFont("FFScala"));
        textSize(12);
        textAlign(CENTER, CENTER);
        float x = textWidth(titleText) + 20;
        float xMergin = PEOConst.SLIDE_SPACE + PEOConst.TITLE_MERGIN_WIDTH;
        
        SceneObject title;
        
        _SetHeaderObject("Title L", "Title_L.png", 0, 0, PEOConst.SLIDE_SPACE, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        _SetHeaderObject("Title R", "Title_R.png", 0, 0, xMergin + x, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        title = _SetHeaderObject("Title C", "Title_C.png", 0, 0, xMergin, 0, x, PEOConst.TITLE_HEIGHT);
        
        SceneObjectText _text = new SceneObjectText(title, titleText);
        _text.SetFontSize(12);
        _text.SetUsingFontName("FFScala");
        _text.SetAlign(CENTER, BASELINE);
        _text.GetColorInfo().SetColor(0, 0, 0);
        
        _SetHeaderObject("Header L", "Header_L.png", 0, 0, PEOConst.SLIDE_SPACE, PEOConst.TITLE_HEIGHT, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.HEADER_HEIGHT);
        _SetHeaderObject("Header R", "Header_R.png", 1, 0, -PEOConst.SLIDE_SPACE, PEOConst.TITLE_HEIGHT, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.HEADER_HEIGHT);
        title = _SetHeaderObject("Header C", "Header_C.png", 0, 0, 0, PEOConst.TITLE_HEIGHT, 0, PEOConst.HEADER_HEIGHT);
        SceneObjectTransform t = title.GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(1, 0);
        t.GetPivot().SetPivot(0.5, 0);
        t.SetOffsetMin(PEOConst.TITLE_MERGIN_WIDTH, 0);
        t.SetOffsetMax(-PEOConst.TITLE_MERGIN_WIDTH, 0);
    }
    
    private SceneObject _SetHeaderObject(String name, String imagePath, float aX, float aY, float x, float y, float w, float h) {
        SceneObject o = new SceneObject(name);
        o.GetTransform().InitTransform(aX, aY, aX, aY, aX, aY, x, y, 1, 1, 0, w, h);
        o.GetDrawBack().SetEnable(false);
        AddObject(o);
        AddChild(o);
        new SceneObjectImage(o, PEOConst.EDITOR_GENERAL_PATH + imagePath);
        return o;
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