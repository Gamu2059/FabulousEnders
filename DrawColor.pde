public final class DrawColor {
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
    public void SetRedOrHue(float value) {
        if (_isRGB && value > PConst.MAX_RED) {
            value = PConst.MAX_RED;
        } else if (!_isRGB && value > PConst.MAX_HUE) {
            value = PConst.MAX_HUE;
        }
        _p1 = value;
    }

    public float GetGreenOrSaturation() {
        return _p2;
    }
    public void SetGreenOrSaturation(float value) {
        if (_isRGB && value > PConst.MAX_GREEN) {
            value = PConst.MAX_GREEN;
        } else if (!_isRGB && value > PConst.MAX_SATURATION) {
            value = PConst.MAX_SATURATION;
        }
        _p2 = value;
    }

    public float GetBlueOrBrightness() {
        return _p3;
    }
    public void SetBlueOrBrightness(float value) {
        if (_isRGB && value > PConst.MAX_BLUE) {
            value = PConst. MAX_BLUE;
        } else if (!_isRGB && value > PConst.MAX_BRIGHTNESS) {
            value = PConst.MAX_BRIGHTNESS;
        }
        _p3 = value;
    }

    public float GetAlpha() {
        return _alpha;
    }
    public void SetAlpha(float value) {
        if (value > PConst.MAX_ALPHA) {
            value = PConst.MAX_ALPHA;
        }
        _alpha = value;
    }

    /**
     モードにより返ってくる値が異なる可能性があります。
     */
    public color GetColor() {
        _ChangeColorMode();
        return color(GetRedOrHue(), GetGreenOrSaturation(), GetBlueOrBrightness(), GetAlpha());
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
        _InitParameterOnConstructor(true, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
    }

    public DrawColor(boolean isRGB) {
        if (_isRGB) {
            _InitParameterOnConstructor(_isRGB, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
        } else {
            _InitParameterOnConstructor(_isRGB, PConst.MAX_HUE, PConst.MAX_SATURATION, PConst.MAX_BRIGHTNESS, PConst.MAX_ALPHA);
        }
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, PConst.MAX_ALPHA);
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3, float p4) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, p4);
    }

    private void _InitParameterOnConstructor(boolean isRGB, float p1, float p2, float p3, float p4) {
        SetColorMode(isRGB);
        SetColor(p1, p2, p3, p4);
    }

    private void _ChangeColorMode() {
        if (_isRGB) {
            colorMode(RGB, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
        } else {
            colorMode(HSB, PConst.MAX_HUE, PConst.MAX_SATURATION, PConst.MAX_BRIGHTNESS, PConst.MAX_ALPHA);
        }
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (!(o instanceof DrawColor)) {
            return false;
        }
        DrawColor d = (DrawColor) o;
        return 
            IsRGB() == d.IsRGB() && 
            GetRedOrHue() == d.GetRedOrHue() && 
            GetGreenOrSaturation() == d.GetGreenOrSaturation() && 
            GetBlueOrBrightness() == d.GetBlueOrBrightness() && 
            GetAlpha() == d.GetAlpha();
    }
}