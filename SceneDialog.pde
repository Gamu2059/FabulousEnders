/**
 ダイアログメッセージを表示するためだけのシーン。
 */
public class SceneDialog extends Scene {
    private SceneObject _back, _header, _contents, _buttonObj;
    private SceneObjectText _headerText, _contentsText;
    private SceneObjectButton _button;

    public SceneDialog() {
        super(SceneID.SID_DIALOG);

        SceneObjectTransform objT;
        SceneObjectDrawBack objD;

        _back = new SceneObject("Dialog Back", this);
        objT = _back.GetTransform();
        objT.SetAnchor(0.5, 0.5, 0.5, 0.5);
        objT.SetPivot(0.5, 0.5);
        objT.SetSize(320, 200);
        objD = _back.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(240, 240, 240);

        _header = new SceneObject("Header", this);
        objT = _header.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        objT.SetSize(0, 40);
        objD = _header.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(200, 200, 200);
        _headerText = new SceneObjectText();
        _header.AddBehavior(_headerText);
        _headerText.SetAlign(CENTER, CENTER);
        _headerText.SetFontSize(14);
        _headerText.GetColorInfo().SetColor(0, 0, 0);

        _contents = new SceneObject("Contents", this);
        objT = _contents.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetOffsetMin(0, 40);
        objT.SetOffsetMax(0, -40);
        objD = _contents.GetDrawBack();
        _contentsText = new SceneObjectText();
        _contents.AddBehavior(_contentsText);
        _contentsText.SetAlign(CENTER, CENTER);
        _contentsText.SetFontSize(14);
        _contentsText.GetColorInfo().SetColor(0, 0, 0);

        _buttonObj = new SceneObject("Button", this);
        objT = _buttonObj.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetAnchor(0.5, 1, 0.5, 1);
        objT.SetPivot(0.5, 1);
        objT.SetSize(60, 30);
        objT.SetTranslation(0, -10);
        objD = _buttonObj.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(255, 255, 255);
        SceneObjectText t = new SceneObjectText(_buttonObj, "ＯＫ");
        t.SetAlign(CENTER, CENTER);
        t.SetFontSize(12);
        t.GetColorInfo().SetColor(0, 0, 0);
        _button = new SceneObjectButton(_buttonObj, "System Dialog Button");
        _button.GetDecideHandler().GetEvents().Add("Hide", new IEvent() {
            public void Event() {
                Hide();
            }
        }
        );
    }

    public void OnEnabled() {
        super.OnEnabled();
        GetDrawBack().GetBackColorInfo().SetColor(200, 200, 200, 100);
        SetScenePriority(9999);
    }

    public void Show(String message) {
        Show("", message);
    }

    public void Show(String title, String message) {
        _headerText.SetText(title);
        _contentsText.SetText(message);
        sceneManager.LoadScene(SceneID.SID_DIALOG);
    }

    public void Hide() {
        sceneManager.ReleaseScene(SceneID.SID_DIALOG);
        if (!isProcessing) {
            resetMatrix();
            background(0);
        }
        exit();
    }
}