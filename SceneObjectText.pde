public class SceneObjectText extends SceneObjectDrawBase {
    public int GetID() {
        return ClassID.CID_TEXT;
    }
    
    private String _text;
    public String GetText() {
        return _text;
    }
    public void SetText(String value) {
        _text = value == null ? "" : value;
    }

    private int _horizontalAlign;
    public int GetHorizontalAlign() {
        return _horizontalAlign;
    }
    public void SetHorizontalAlign(int value) {
        if (value == LEFT || value == CENTER || value == RIGHT) {
            _horizontalAlign = value;
        }
    }

    private int _verticalAlign;
    public int GetVerticalAlign() {
        return _verticalAlign;
    }
    public void SetVerticalAlign(int value) {
        if (value == TOP || value == CENTER || value == BOTTOM || value == BASELINE) {
            _verticalAlign = value;
        }
    }

    public void SetAlign(int value1, int value2) {
        SetHorizontalAlign(value1);
        SetVerticalAlign(value2);
    }

    /**
     フォントはマネージャから取得するので、参照を分散させないように文字列で対応する。
     */
    private String _usingFontName;
    public String GetUsingFontName() {
        return _usingFontName;
    }
    public void SetUsingFontName(String value) {
        _usingFontName = value;
    }

    private float _fontSize;
    public float GetFontSize() {
        return _fontSize;
    }
    public void SetFontSize(float value) {
        if (0 <= value && value <= 100) {
            _fontSize = value;
        }
    }

    private float _lineSpace;
    public float GetLineSpace() {
        return _lineSpace;
    }
    /**
     行間をピクセル単位で指定する。
     ただし、最初からフォントサイズと同じ大きさの行間が設定されている。
     */
    public void SetLineSpace(float value) {
        float space = _fontSize + value;
        if (0 <= space) {
            _lineSpace = space;
        }
    }

    /**
     文字列の描画モード。
     falseの場合、通常と同じように一斉に描画する。
     trueの場合、ゲームのセリフのように一文字ずつ描画する。
     ただし、trueの場合は、alignで設定されているのがLEFT TOP以外だと違和感のある描画になる。
     */
    private boolean _isDrawInOrder;
    public boolean IsDrawInOrder() {
        return _isDrawInOrder;
    }
    public void SetDrawInOrder(boolean value) {
        _isDrawInOrder = value;
    }

    private float _drawSpeed;
    public float GetDrawSpeed() {
        return _drawSpeed;
    }
    public void SetDrawSpeed(float value) {
        if (value <= 0 || value >= 60) {
            return;
        }
        _drawSpeed = value;
    }

    private float _deltaTime;
    private int _drawingIndex;
    private String _tempText;

    private PVector _objSize;


    public SceneObjectText() {
        super();
        _InitParameterOnConstructor("");
    }

    public SceneObjectText(String text) {
        super();
        _InitParameterOnConstructor(text);
    }

    private void _InitParameterOnConstructor(String text) {
        SetText(text);
        SetAlign(LEFT, TOP);
        SetFontSize(20);
        SetLineSpace(0);
        SetUsingFontName("MS Gothic");
    }

    public void Start() {
        super.Start();
        _objSize = GetObject().GetTransform().GetSize();
    }

    public void Update() {
        _deltaTime += 1/frameRate;
        if (_deltaTime >= 1/_drawSpeed) {
            _deltaTime = 0;
            if (_drawingIndex < GetText().length()) {
                _drawingIndex++;
            }
        }
    }

    public void Draw() {
        if (GetText() == null) return;
        fill(GetColorInfo().GetColor());
        textFont(fontManager.GetFont(GetUsingFontName()));
        textSize(GetFontSize());
        textAlign(GetHorizontalAlign(), GetVerticalAlign());
        textLeading(GetLineSpace());

        if (_isDrawInOrder) {
            _tempText = GetText().substring(0, _drawingIndex);
        } else {
            _tempText = GetText();
        }

        text(_tempText, 0, 0, _objSize.x, _objSize.y);
    }
}