/**
 汎用判定処理クラス。
 */
public static class GeneralJudge {
    /**
    指定したクラスが指定したインターフェースを実装しているかどうか。
    */
    public static boolean isImplemented(Class<?> clazz, Class<?> intrfc) {
        if (clazz == null || intrfc == null) {
            return false;
        }
        // インターフェースを実装したクラスであるかどうかをチェック
        if (!clazz.isInterface() && intrfc.isAssignableFrom(clazz)
                && !Modifier.isAbstract(clazz.getModifiers())) {
            return true;
        }
        return false;
    }
}