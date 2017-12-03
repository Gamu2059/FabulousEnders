/**
 開発エンジン専用。
 */
public final class PEOScenePositionManager {
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
            if (PEOConst.MIN_VIEW_WIDTH <= pos) {
                _viewToHierarchy = pos;
                return true;
            }
            return false;
        } else {
            if (_hierarchyToInspector - pos >= PEOConst.MIN_HIERARCHY_WIDTH) {
                _viewToHierarchy = pos;
                return true;
            } else {
                // インスペクタも巻き込む場合
                if (SlideOnHtoI(pos + PEOConst.MIN_HIERARCHY_WIDTH)) {
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
            if (pos - _viewToHierarchy >= PEOConst.MIN_HIERARCHY_WIDTH) {
                _hierarchyToInspector = pos;
                return true;
            } else {
                // ビューも巻き込む場合
                if (SlideOnVtoH(pos - PEOConst.MIN_HIERARCHY_WIDTH)) {
                    _hierarchyToInspector = pos;
                    return true;
                }
                return false;
            }
        } else {
            if (width - pos >= PEOConst.MIN_INSPECTOR_WIDTH) {
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
            if (PEOConst.BAR_HEIGHT + PEOConst.OPERATION_BAR_HEIGHT <= pos) {
                _viewToProject = pos;
                return true;
            }
            return false;
        } else {
            if (height - pos >= PEOConst.MIN_PROJECT_HEIGHT) {
                _viewToProject = pos;
                return true;
            }
            return false;
        }
    }
}