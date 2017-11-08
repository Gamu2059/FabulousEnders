/**
 汎用計算処理クラス。
 */
public static class GeneralCalc {
    /**
     指定した座標同士のラジアン角を返す。
     座標2から座標1に向けての角度になるので注意。
     */
    public static float getRad(float x1, float y1, float x2, float y2) {
        float a = atan((y1 - y2)/(x1 - x2));
        if (x1 - x2 < 0) {
            // 左向きの時
            a = PI + a;
        }
        return a;
    }
}