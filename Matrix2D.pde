public static class Matrix2D {
    private static boolean _CheckInvalid(float[] e) {
        if (e == null) return true;
        if (e.length < 6) return true;
        return false;
    }

    public static void Reset(float[] e) {
        if (_CheckInvalid(e)) return;
        for (int i=0; i<6; i++) {
            if (i == 0 || i == 4) {
                e[i] = 1;
            } else {
                e[i] = 0;
            }
        }
    }

    public static void Translate(float[] e, float x, float y) {
        if (_CheckInvalid(e)) return;
        e[2] += e[0] * x + e[1] * y;
        e[5] += e[3] * x + e[4] * y;
    }

    public static void Rotate(float[] e, float rad) {
        if (_CheckInvalid(e)) return;
        float e0, e1, e3, e4, s, c;
        e0 = e[0];
        e1 = e[1];
        e3 = e[3];
        e4 = e[4];
        s = sin(rad);
        c = cos(rad);
        e[0] = e0 * c + e1 * s;
        e[1] = e0 * s - e1 * c;
        e[3] = e3 * c + e4 * s;
        e[4] = e3 * s - e4 * c;
    }

    public static void Scale(float[] e, float x, float y) {
        if (_CheckInvalid(e)) return;
        e[0] *= x;
        e[1] *= y;
        e[3] *= x;
        e[4] *= y;
    }

    public static void Get(float[] e, PMatrix2D matrix) {
        if (_CheckInvalid(e)) return;
        if (matrix == null) return;
        matrix.apply(
            e[0], e[1], e[2], 
            e[3], e[4], e[5]
            );
    }

    public static void Copy(float[] _in, float[] _out) {
        if (_CheckInvalid(_in) || _CheckInvalid(_out)) return;
        for (int i=0; i<6; i++) {
            _out[i] = _in[i];
        }
    }
}