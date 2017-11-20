/**
 オブジェクトの背景色を管理するクラス。
 */
public class SceneObjectDrawBack extends Abs_SceneObjectBehavior {
    /**
     背景の色情報。
     */
    private DrawColor _backColorInfo;
    public DrawColor GetBackColorInfo() {
        return _backColorInfo;
    }

    /**
     ボーダの色情報。
     */
    private DrawColor _borderColorInfo;
    public DrawColor GetBorderColorInfo() {
        return _borderColorInfo;
    }

    /**
     背景の描画が有効かどうかを保持するフラグ。
     falseの場合、領域内部は透過される。
     */
    private boolean _enableBack;
    public boolean IsEnableBack() {
        return _enableBack;
    }
    public void SetEnableBack(boolean value) {
        _enableBack = value;
    }

    /**
     ボーダの描画が有効かどうかを保持するフラグ。
     falseの場合、領域周辺のボーダは描画されない。
     */
    private boolean _enableBorder;
    public boolean IsEnableBorder() {
        return _enableBorder;
    }
    public void SetEnableBorder(boolean value) {
        _enableBorder = value;
    }

    /**
     ボーダの直径。
     */
    private float _borderSize;
    public float GetBorderSize() {
        return _borderSize;
    }
    public void SetBorderSize(float value) {
        _borderSize = value;
    }

    /**
     ボーダの端の形。
     */
    private int _borderType;
    public int GetBorderType() {
        return _borderType;
    }
    public void SetBorderType(int value) {
        _borderType = value;
    }

    public SceneObjectDrawBack(SceneObject obj) {
        super(obj);

        DrawColor backInfo, borderInfo;
        backInfo = new DrawColor(true, 100, 100, 100, 255);
        borderInfo = new DrawColor(true, 0, 0, 0, 255);

        _InitParameterOnConstructor(true, backInfo, true, borderInfo, 1, ROUND);
    }

    public SceneObjectDrawBack(SceneObject obj, boolean enableBack, DrawColor backInfo, boolean enableBorder, DrawColor borderInfo, float borderSize, int borderType) {
        super(obj);
        _InitParameterOnConstructor(enableBack, backInfo, enableBorder, borderInfo, borderSize, borderType);
    }

    public SceneObjectDrawBack(SceneObject obj, boolean enableBack, boolean backColorMode, float ba1, float ba2, float ba3, float ba4, boolean enableBorder, boolean borderColorMode, float bo1, float bo2, float bo3, float bo4) {
        super(obj);

        DrawColor backInfo, borderInfo;
        backInfo = new DrawColor(backColorMode, ba1, ba2, ba3, ba4);
        borderInfo = new DrawColor(borderColorMode, bo1, bo2, bo3, bo4);

        _InitParameterOnConstructor(enableBack, backInfo, enableBorder, borderInfo, 1, ROUND);
    }

    private void _InitParameterOnConstructor(boolean enableBack, DrawColor backInfo, boolean enableBorder, DrawColor borderInfo, float borderSize, int borderType) {
        _enableBack = enableBack;
        _backColorInfo = backInfo;

        _enableBorder = enableBorder;
        _borderColorInfo = borderInfo;
        _borderSize = borderSize;
        _borderType = borderType;
    }

    public void Draw() {
        println(this);
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(super.toString());

        return b.toString();
    }
}