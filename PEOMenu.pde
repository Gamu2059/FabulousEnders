/**
 メニューアイテムオブジェクト。
 */
public class PEOMenu extends SceneObject {
    private SceneObjectText _text;
    public SceneObjectText GetText() {
        return _text;
    }

    private SceneObjectButton _button;

    private DrawColor _dc;

    public PEOMenu(String name, String t) {
        super(name);
        
        _dc = GetDrawBack().GetBackColorInfo();
        GetDrawBack().SetEnableBorder(false);
        _dc.SetColor(204, 232, 255, 0);

        _text = new SceneObjectText();
        _text.SetText(t);
        _text.SetFontSize(12);
        _text.SetUsingFontName("FFScala");
        _text.SetAlign(CENTER, CENTER);
        _text.GetColorInfo().SetColor(0, 0, 0);
        AddBehavior(_text);

        _button = new SceneObjectButton(name + t + " PMenu Label");
        AddBehavior(_button);
        _button.GetEnabledActiveHandler().SetEvent("mouse entered", new IEvent() {
            public void Event() {
                _dc.SetAlpha(255);
            }
        }
        );
        _button.GetDisabledActiveHandler().SetEvent("mouse exited", new IEvent() {
            public void Event() {
                _dc.SetAlpha(0);
            }
        }
        );
    }
}