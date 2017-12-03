/**
 エンジン専用の定数を定義するクラス。
 */
public final class PEOConst {
    // 画像パス
    public static final String ENGINE = "Engine/";
    public static final String OPERATION_BAR_PATH = ENGINE + "OperationBar/";
    public static final String EDITOR_PATH = ENGINE + "Editor/";
    public static final String EDITOR_GENERAL_PATH = EDITOR_PATH + "General/";
    
    // エディタサイズ
    public static final float MENU_BAR_HEIGHT = 20;
    public static final float OPERATION_BAR_HEIGHT = 32;
    public static final float BAR_HEIGHT = MENU_BAR_HEIGHT + OPERATION_BAR_HEIGHT;
    
    public static final float MIN_VIEW_WIDTH = 220;
    public static final float MIN_VIEW_HEIGHT = 220;
    public static final float MIN_PROJECT_HEIGHT = 120;
    public static final float MIN_HIERARCHY_WIDTH = 220;
    public static final float MIN_INSPECTOR_WIDTH = 280;
    
    public static final float TITLE_HEIGHT = 16;
    public static final float TITLE_MERGIN_WIDTH = 6;
}