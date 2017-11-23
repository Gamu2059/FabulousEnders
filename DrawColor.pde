/**
 色情報をまとめて管理するクラス。
 */
public final class DrawColor {
    /**
     RGBモードでの赤色の最大値。
     */
    public static final int MAX_RED = 255;
    /**
     RGBモードでの緑色の最大値。
     */
    public static final int MAX_GREEN = 255;
    /**
     RGBモードでの青色の最大値。
     */
    public static final int MAX_BLUE = 255;
    /**
     HSBモードでの色相の最大値。
     */
    public static final int MAX_HUE = 360;
    /**
     HSBモードでの彩度の最大値。
     */
    public static final int MAX_SATURATION = 100;
    /**
     HSBモードでの明度の最大値。
     */
    public static final int MAX_BRIGHTNESS = 100;
    /**
     RGB, HSBモードでのアルファの最大値。
     */
    public static final int MAX_ALPHA = 255;

    private boolean _isRGB;
    public boolean IsRGB() {
        return _isRGB;
    }
    /**
     カラーモードを設定する。
     trueの場合はRGB表現、falseの場合はHSB表現にする。
     */
    public void SetColorMode(boolean value) {
        _isRGB = value;
    }

    private float _p1, _p2, _p3, _alpha;

    public float GetRedOrHue() {
        return _p1;
    }
    /**
     第一パラメータを設定する。
     値は最大値によって剰余を計算され、保持される。
     */
    public void SetRedOrHue(float value) {
        if (_isRGB && value > MAX_RED) {
            value %= MAX_RED;
        } else if (!_isRGB && value > MAX_HUE) {
            value %= MAX_HUE;
        }
        _p1 = value;
    }

    public float GetGreenOrSaturation() {
        return _p2;
    }
    /**
     第二パラメータを設定する。
     値は最大値によって剰余を計算され、保持される。
     */
    public void SetGreenOrSaturation(float value) {
        if (_isRGB && value > MAX_GREEN) {
            value %= MAX_GREEN;
        } else if (!_isRGB && value > MAX_SATURATION) {
            value %= MAX_SATURATION;
        }
        _p2 = value;
    }

    public float GetBlueOrBrightness() {
        return _p3;
    }
    /**
     第三パラメータを設定する。
     値は最大値によって剰余を計算され、保持される。
     */
    public void SetBlueOrBrightness(float value) {
        if (_isRGB && value > MAX_BLUE) {
            value %= MAX_BLUE;
        } else if (!_isRGB && value > MAX_BRIGHTNESS) {
            value %= MAX_BRIGHTNESS;
        }
        _p3 = value;
    }

    public float GetAlpha() {
        return _alpha;
    }
    /**
     アルファパラメータを設定する。
     値は最大値によって剰余を計算され、保持される。
     */
    public void SetAlpha(float value) {
        if (value > MAX_ALPHA) {
            value %= MAX_ALPHA;
        }
        _alpha = value;
    }

    /**
     モードにより返ってくる値が異なる可能性があります。
     */
    public color GetColor() {
        _ChangeColorMode();
        return color(_p1, _p2, _p3, _alpha);
    }
    public void SetColor(float p1, float p2, float p3) {
        SetRedOrHue(p1);
        SetGreenOrSaturation(p2);
        SetBlueOrBrightness(p3);
    }
    public void SetColor(float p1, float p2, float p3, float p4) {
        SetColor(p1, p2, p3);
        SetAlpha(p4);
    }

    public DrawColor() {
        _InitParameterOnConstructor(true, 0, 0, 0, MAX_ALPHA);
    }

    public DrawColor(boolean isRGB) {
        _InitParameterOnConstructor(_isRGB, 0, 0, 0, MAX_ALPHA);
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, MAX_ALPHA);
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3, float p4) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, p4);
    }

    private void _InitParameterOnConstructor(boolean isRGB, float p1, float p2, float p3, float p4) {
        _isRGB = isRGB;
        SetColor(p1, p2, p3, p4);
    }

    private void _ChangeColorMode() {
        if (_isRGB) {
            colorMode(RGB, MAX_RED, MAX_GREEN, MAX_BLUE, MAX_ALPHA);
        } else {
            colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
        }
    }
}