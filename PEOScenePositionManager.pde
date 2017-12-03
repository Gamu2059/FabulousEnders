/**
 開発エンジン専用。
 */
public final class PEOScenePositionManager {
    public final float MENU_BAR_HEIGHT = 20;
    public final float OPERATION_BAR_HEIGHT = 32;
    
    public final float MIN_VIEW_WIDTH = 220;
    public final float MIN_VIEW_HEIGHT = 220;
    public final float MIN_PROJECT_HEIGHT = 120;
    public final float MIN_HIERARCHY_WIDTH = 220;
    public final float MIN_INSPECTOR_WIDTH = 280;

    private float _viewToHierarchy;
    public float GetVtoH() {
        return _viewToHierarchy;
    }

    private float _viewToProject;
    public float GetVtoP() {
        return _viewToProject;
    }

    private float _hierarchyToInspector;
    public float GetHtoI() {
        return _hierarchyToInspector;
    }

    public PEOScenePositionManager() {
        _viewToHierarchy = 0.6 * width;
        _viewToProject = 0.7 * height;
        _hierarchyToInspector = 0.8 * width;
    }

    /**
     ViewとHierarchyの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnVtoH(float pos) {
        if (_viewToHierarchy > pos) {
            if (MIN_VIEW_WIDTH <= pos) {
                _viewToHierarchy = pos;
                return true;
            }
            return false;
        } else {
            if (_hierarchyToInspector - pos >= MIN_HIERARCHY_WIDTH) {
                _viewToHierarchy = pos;
                return true;
            } else {
                // インスペクタも巻き込む場合
                if (SlideOnHtoI(pos + MIN_HIERARCHY_WIDTH)) {
                    _viewToHierarchy = pos;
                    return true;
                }
                return false;
            }
        }
    }

    /**
     HierarchyとInspectorの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnHtoI(float pos) {
        if (_hierarchyToInspector > pos) {
            if (pos - _viewToHierarchy >= MIN_HIERARCHY_WIDTH) {
                _hierarchyToInspector = pos;
                return true;
            } else {
                // ビューも巻き込む場合
                if (SlideOnVtoH(pos - MIN_HIERARCHY_WIDTH)) {
                    _hierarchyToInspector = pos;
                    return true;
                }
                return false;
            }
        } else {
            if (width - pos >= MIN_INSPECTOR_WIDTH) {
                _hierarchyToInspector = pos;
                return true;
            }
            return false;
        }
    }

    /**
     ViewとProjectの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnVtoP(float pos) {
        if (_viewToProject > pos) {
            if (MIN_VIEW_HEIGHT + MENU_BAR_HEIGHT + OPERATION_BAR_HEIGHT <= pos) {
                _viewToProject = pos;
                return true;
            }
            return false;
        } else {
            if (height - pos >= MIN_PROJECT_HEIGHT) {
                _viewToProject = pos;
                return true;
            }
            return false;
        }
    }
}