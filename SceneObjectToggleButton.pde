public class SceneObjectToggleButton extends SceneObjectButton {
    public int GetID() {
        return ClassID.CID_TOGGLE_BUTTON;
    }

    private boolean _isOn;
    private String _offImg, _onImg;

    private SceneObjectImage _img;

    public SceneObjectToggleButton(String eventLabel, String offImg, String onImg) {
        super(eventLabel);
        _InitParametersOnConstructor(offImg, onImg);
    }
    
    public SceneObjectToggleButton(SceneObject o, String eventLabel, String offImg, String onImg) {
        super(eventLabel);
        _InitParametersOnConstructor(offImg, onImg);
        if (o == null) return;
        o.AddBehavior(this);
    }
    
    private void _InitParametersOnConstructor(String offImg, String onImg) {
        _isOn = true;
        _offImg = offImg;
        _onImg = onImg;
    }

    public void Start() {
        super.Start();
        
        SceneObjectBehavior beh = GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
        if (beh instanceof SceneObjectImage) {
            _img = (SceneObjectImage) beh;
        }

        GetDecideHandler().AddEvent("Toggle", new IEvent() {
            public void Event() {
                _isOn = !_isOn;

                if (_img == null) return;
                if (_isOn) {
                    _img.SetUsingImageName(_onImg);
                } else {
                    _img.SetUsingImageName(_offImg);
                }
            }
        }
        );
    }
}