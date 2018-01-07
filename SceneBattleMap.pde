/**
 戦闘マップ及びマップイベントを描画するシーン。
 */
public class FESceneBattleMap extends Scene {
    private SceneObject mapImageObj, hazardAreaObj, actionRangeObj, terrainImageObj, mapElementObj, unitViewObj, terrainViewObj, cursorObj;

    private SceneObjectImage mapImage;

    private FEMapMouseCursor mapCursor;
    public FEMapMouseCursor GetMapCursor() {
        return mapCursor;
    }

    public FESceneBattleMap() {
        super(SceneID.SID_FE_BATTLE_MAP);

        SceneObjectTransform objT;

        mapImageObj = new SceneObject("Map Image Object", this);
        mapImage = new SceneObjectImage(mapImageObj, null);
        objT = mapImageObj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        mapCursor = new FEMapMouseCursor(mapImageObj);

        actionRangeObj = new SceneObject("Action Range Object", this);
        objT = actionRangeObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.AddPriority(1);
        new FEMapActionRangeDrawer(actionRangeObj);



        mapElementObj = new SceneObject("Map Element Object", this);
        objT = mapElementObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.AddPriority(4);
        new FEMapObjectDrawer(mapElementObj);
        new FEMapUnitRouter(mapElementObj);

        unitViewObj = new SceneObject("Unit View Object", this);
        new FEMapUnitViewer(unitViewObj);

        terrainViewObj = new SceneObject("Terrain View Object", this);
        new FEMapTerrainViewer(terrainViewObj);

        cursorObj = new SceneObject("Cursor Object", this);
        objT = cursorObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.AddPriority(7);
        new FEMapCursor(cursorObj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        FEBattleMapManager bm = feManager.GetBattleMapManager();
        SceneObjectTransform objT = mapImageObj.GetTransform();

        objT.SetSize(bm.GetMapWidth() * FEConst.SYSTEM_MAP_GRID_PX, bm.GetMapHeight() * FEConst.SYSTEM_MAP_GRID_PX);
        mapImage.SetUsingImageName(bm.GetMapImagePath());
    }
}

/**
 ユニットの行動範囲を描画する振る舞い。
 */
public class FEMapActionRangeDrawer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_ACTION_RANGE_DRAWER;
    }

    private FEBattleMapManager bm;

    public FEMapActionRangeDrawer(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
    }

    public void Draw() {
        super.Draw();

        if (!_IsDrawable()) return;
        int[][] ar = bm.GetActionRanges();
        boolean f = bm.GetOperationMode() == FEConst.BATTLE_OPE_MODE_ACTIVE;
        for (int i=0; i<bm.GetMapHeight(); i++) {
            for (int j=0; j<bm.GetMapWidth(); j++) {
                switch(ar[i][j]) {
                case FEConst.BATTLE_MAP_MARKER_ACTION:
                    _DrawRange(j, i, 0, 100, 250, f?180:100);
                    break;
                case FEConst.BATTLE_MAP_MARKER_ATTACK:
                    _DrawRange(j, i, 250, 0, 0, f?180:100);
                    break;
                case FEConst.BATTLE_MAP_MARKER_CANE:
                    _DrawRange(j, i, 0, 200, 200, f?150:100);
                    break;
                }
            }
        }
    }

    private void _DrawRange(int x, int y, int r, int g, int b, int a) {
        noStroke();
        fill(r, g, b, a);
        rect(x * FEConst.SYSTEM_MAP_GRID_PX + 1, y * FEConst.SYSTEM_MAP_GRID_PX + 1, FEConst.SYSTEM_MAP_GRID_PX - 2, FEConst.SYSTEM_MAP_GRID_PX - 2);
    }

    private boolean _IsDrawable() {
        switch(bm.GetOperationMode()) {
        default:
            return true;
        case FEConst.BATTLE_OPE_MODE_MOVING:
        case FEConst.BATTLE_OPE_MODE_FINISH_MOVE:
            return false;
        }
    }
}

/**
 ユニットオブジェクトの描画を行う振る舞い。
 */
public class FEMapObjectDrawer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_DRAWER;
    }

    private FEBattleMapManager bm;
    private int offset;

    private SceneObjectTimer timer;
    private String timerLabel;
    private int cnt, normalIdx, runIdx;

    public FEMapObjectDrawer(SceneObject obj) {
        super();

        timer = new SceneObjectTimer(obj);
        timerLabel = "FEMapObjectDrawer CountTimer";

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
        offset = (FEConst.SYSTEM_MAP_GRID_PX - FEConst.SYSTEM_MAP_OBJECT_PX) / 2;
        cnt = 0;

        timer.GetTimers().Add(timerLabel, new ITimer() {
            public void OnInit() {
                cnt = ++cnt % 2;
                runIdx = ++runIdx % 6;
                if (cnt == 0) {
                    normalIdx = ++normalIdx % 6;
                }
            }

            public void OnTimeOut() {
                timer.ResetTimer(timerLabel, 0.1);
                timer.Start(timerLabel);
            }
        }
        );
        timer.ResetTimer(timerLabel, 0.1);
        timer.Start(timerLabel);
    }

    public void Draw() {
        super.Draw();

        FEMapElement e;
        FEMapObject o;
        PVector pos;
        float x, y;
        String imgPath;
        for (int i=0; i<bm.GetMapElements().size(); i++) {
            e = bm.GetMapElements().get(i);
            o = e.GetMapObject();
            if (o == null) continue;
            if (o.GetMapImageFolderPath() == null) continue;

            imgPath = o.GetMapImageFolderPath() + "/N" + _DrawIdx(e.IsRunning()?runIdx:normalIdx) + ".png";
            if (imageManager.GetImage(imgPath) == null) continue;
            pos = e.GetPosition();
            x = pos.x;
            y = pos.y;
            x = x * FEConst.SYSTEM_MAP_GRID_PX + offset;
            y = y * FEConst.SYSTEM_MAP_GRID_PX + offset;
            image(imageManager.GetImage(imgPath), x, y, FEConst.SYSTEM_MAP_OBJECT_PX, FEConst.SYSTEM_MAP_OBJECT_PX);
        }
    }

    private int _DrawIdx(int idx) {
        switch(idx) {
        case 4:
        case 5:
            return 0;
        case 1:
        case 2:
            return 2;
        default:
            return 1;
        }
    }
}

/**
 ユニットの移動イベントが生じた時に、自動的にイベントを移動させる。
 */
public class FEMapUnitRouter extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_UNIT_ROUTER;
    }

    private SceneObjectDuration _duration;
    private String _durationLabel;

    private FEBattleMapManager bm;
    private boolean isMoving;
    private int routeIdx;

    public FEMapUnitRouter(SceneObject obj) {
        super();
        _duration = new SceneObjectDuration(obj);
        _durationLabel = "FEMapUnitRouter Duration";
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
        isMoving = false;

        _duration.GetDurations().Add(_durationLabel, new IDuration() {
            private PVector aimPos, crtPos;
            private FEMapElement elem;
            private SceneObjectDuration dur;
            private float settedTime, dX, dY;

            public void OnInit() {
                dur = _duration;
                settedTime = dur.GetSettedTimer(_durationLabel);
                aimPos = bm.GetUnitRoute().get(routeIdx);
                elem = bm.GetSelectedElement();
                if (elem == null) {
                    _duration.Stop(_durationLabel);
                }
                crtPos = elem.GetPosition();
                dX = aimPos.x - crtPos.x;
                dY = aimPos.y - crtPos.y;
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                crtPos.x += dX /(frameRate * settedTime);
                crtPos.y += dY /(frameRate * settedTime);
            }
            public void OnEnd() {
                crtPos.x = aimPos.x;
                crtPos.y = aimPos.y;
                routeIdx--;
                if (routeIdx >= 0) {
                    dur.ResetTimer(_durationLabel, feManager.GetConfig().GetUnitMoveTime());
                    dur.Start(_durationLabel);
                } else {
                    isMoving = false;
                    bm.OnFinishMoving();
                }
            }
        }
        );
    }

    public void Update() {
        super.Update();

        if (bm.GetOperationMode() == FEConst.BATTLE_OPE_MODE_MOVING && !isMoving) {
            isMoving = true;
            routeIdx = bm.GetUnitRoute().size() - 1;
            _duration.SetUseTimer(_durationLabel, true);
            _duration.ResetTimer(_durationLabel, feManager.GetConfig().GetUnitMoveTime());
            _duration.Start(_durationLabel);
        }
    }
}

/**
 マウス座標を戦闘マップ座標の相対座標に変換する。
 */
public class FEMapMouseCursor extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_MOUSE_CURSOR;
    }

    private float _x, _y;
    public float GetX() {
        return _x;
    }
    public float GetY() {
        return _y;
    }

    private int _mapX, _mapY;
    public int GetMapX() {
        return _mapX;
    }
    public int GetMapY() {
        return _mapY;
    }

    private SceneObjectTransform _objT;
    private PMatrix2D _objM;
    private float[] _in, _out;
    private int _mapW, _mapH;

    public FEMapMouseCursor(SceneObject obj) {
        super();    
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
        _in = new float[2];
        _out = new float[2];
        _mapW = feManager.GetBattleMapManager().GetMapWidth();
        _mapH = feManager.GetBattleMapManager().GetMapHeight();
    }

    /**
     UpdateはTransformする前なので、その直後のDrawで正確な逆演算を行う。
     */
    public void Draw() {
        super.Draw();
        if (_objT == null) return;
        _objM = _objT.GetMatrix().get();
        if (!_objM.invert()) return;
        _in[0] = mouseX;
        _in[1] = mouseY;
        _objM.mult(_in, _out);
        _in[0] = _out[0];
        _in[1] = _out[1];
        _objM.mult(_in, _out);
        _x = _out[0];
        _y = _out[1];

        _mapX = _mapY = -999;
        for (int i=0; i<_mapW; i++) {
            if (_IsInGrid(i, _x)) {
                _mapX = i;
                break;
            }
        }
        for (int i=0; i<_mapH; i++) {
            if (_IsInGrid(i, _y)) {
                _mapY = i;
                break;
            }
        }
    }

    private boolean _IsInGrid(int idx, float p) {
        return FEConst.SYSTEM_MAP_GRID_PX * idx <= p && p < FEConst.SYSTEM_MAP_GRID_PX * (idx + 1);
    }
}

/**
 マップを参照してカーソルが重なったところにいるキャラクタの概要を表示する。
 */
public class FEMapUnitViewer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_UNIT_VIEWER;
    }

    private FEMapMouseCursor _mapCur;
    private SceneObjectTransform _objT;

    private SceneObject _prmBackObj, _faceBackObj;
    private SceneObjectDrawBack _prmBack, _faceBack;
    private SceneObjectImage _faceImg;

    public FEMapUnitViewer(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();

        GetObject().SetActivatable(false);
        _objT = GetObject().GetTransform();
        _objT.AddPriority(500);
        _objT.SetAnchor(1, 0.5, 1, 0.5);
        _objT.SetPivot(1, 0.5);
        _objT.SetSize(320, 70);
        FESceneBattleMap sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();

        SceneObjectTransform objT;
        SceneObjectDrawBack objD;

        _prmBackObj = new SceneObject("Unit Parameter Viewer Back", sbm);
        _prmBackObj.SetActivatable(false);
        objT = _prmBackObj.GetTransform();
        objT.SetParent(_objT, true);
        objT.SetSize(240, 0);
        objT.SetAnchor(1, 0, 1, 1);
        objT.SetPivot(1, 0.5);
        objT.SetTranslation(-5, 0);
        _prmBack = _prmBackObj.GetDrawBack();
        _prmBack.SetCorner(7);
        _prmBack.SetEnable(true, false);

        SceneObject _prmFrontObj = new SceneObject("Unit Parameter Viewer Front", sbm);
        _prmFrontObj.SetActivatable(false);
        objT = _prmFrontObj.GetTransform();
        objT.SetParent(_prmBackObj.GetTransform(), true);
        objT.SetAnchor(0, 1, 1, 1);
        objT.SetPivot(0.5, 1);
        objT.SetOffsetMin(4, 0);
        objT.SetOffsetMax(-4, 0);
        objT.SetTranslation(0, -4);
        objT.SetSize(0, 35);
        objD = _prmFrontObj.GetDrawBack();
        objD.SetCorner(7);
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(255, 250, 220);

        _faceBackObj = new SceneObject("Unit Face Viewer Back", sbm);
        _faceBackObj.SetActivatable(false);
        objT  = _faceBackObj.GetTransform();
        objT.SetParent(_objT, true);
        objT.SetSize(70, 0);
        objT.SetAnchor(1, 0, 1, 1);
        objT.SetPivot(1, 0.5);
        objT.SetTranslation(-250, 0);
        _faceBack = _faceBackObj.GetDrawBack();
        _faceBack.SetCorner(7);
        _faceBack.SetEnable(true, false);

        SceneObject _faceFrontObj = new SceneObject("Unit Face Viewer Front", sbm);
        _faceFrontObj.SetActivatable(false);
        objT = _faceFrontObj.GetTransform();
        objT.SetParent(_faceBackObj.GetTransform(), true);
        objT.SetOffsetMin(4, 4);
        objT.SetOffsetMax(-4, -4);
        objD = _faceFrontObj.GetDrawBack();
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(40, 10, 10);
        _faceImg = new SceneObjectImage(_faceFrontObj, null);
    }

    public void Update() {
        super.Update();
        if (_mapCur == null) {
            _objT.SetScale(0, 0);
            return;
        }
        FEMapElement elem = feManager.GetBattleMapManager().GetMapElementOnPos(_mapCur.GetMapX(), _mapCur.GetMapY());
        if (elem == null) {
            _objT.SetScale(0, 0);
        } else {
            if (!(elem.GetMapObject() instanceof FEUnit)) {
                _objT.SetScale(0, 0);
                return;
            }
            _objT.SetScale(1, 1);

            boolean f = mouseY < height / 2;
            _objT.SetTranslation(0, (f?1:-1) * ((height - _objT.GetSize().y) / 2 - 5));
            FEUnit unit = (FEUnit)elem.GetMapObject();
            if (unit.GetFaceImagePath() == null) {
                _faceBackObj.GetTransform().SetScale(0, 0);
            } else {
                _faceBackObj.GetTransform().SetScale(1, 1);
                _faceImg.SetUsingImageName(unit.GetFaceImagePath());
            }
            _prmBack.GetBackColorInfo().SetColor(20, 60, 130);
            _faceBack.GetBackColorInfo().SetColor(20, 60, 130);
            //if (feManager.GetBattleMapManager().GetSortieUnits().contains(unit)) {
            //    _prmBack.GetBackColorInfo().SetColor(20, 60, 130);
            //    _faceBack.GetBackColorInfo().SetColor(20, 60, 130);
            //} else if (feManager.GetBattleMapManager().GetSortieEnemyUnits().contains(unit)) {
            //    _prmBack.GetBackColorInfo().SetColor(150, 0, 20);
            //    _faceBack.GetBackColorInfo().SetColor(150, 0, 20);
            //}
        }
    }
}

/**
 マップを参照してカーソルが重なったところの地形の概要を表示する。
 */
public class FEMapTerrainViewer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_TERRAIN_VIEWER;
    }

    private FEBattleMapManager bm;

    private FEMapMouseCursor _mapCur;
    private SceneObjectTransform _objT;

    public FEMapTerrainViewer(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();

        bm = feManager.GetBattleMapManager();

        GetObject().SetActivatable(false);
        _objT = GetObject().GetTransform();
        _objT.AddPriority(500);
        _objT.SetAnchor(0, 0.5, 0, 0.5);
        _objT.SetPivot(0, 0.5);
        _objT.SetSize(320, 70);
        FESceneBattleMap sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();

        SceneObjectTransform objT;
        SceneObjectDrawBack objD;

        SceneObject _terBackObj, _terFrontObj;
        _terBackObj = new SceneObject("Terrain Viewer Back", sbm);
        _terBackObj.SetActivatable(false);
        objT = _terBackObj.GetTransform();
        objT.SetParent(_objT, true);
        objT.SetSize(240, 0);
        objT.SetAnchor(0, 0, 0, 1);
        objT.SetPivot(0, 0.5);
        objT.SetTranslation(5, 0);
        objD = _terBackObj.GetDrawBack();
        objD.SetCorner(7);
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(20, 60, 130);

        _terFrontObj = new SceneObject("Terrain Viewer Front", sbm);
        _terFrontObj.SetActivatable(false);
        objT = _terFrontObj.GetTransform();
        objT.SetParent(_terBackObj.GetTransform(), true);
        objT.SetAnchor(0, 1, 1, 1);
        objT.SetPivot(0.5, 1);
        objT.SetOffsetMin(4, 0);
        objT.SetOffsetMax(-4, 0);
        objT.SetTranslation(0, -4);
        objT.SetSize(0, 35);
        objD = _terFrontObj.GetDrawBack();
        objD.SetCorner(7);
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(255, 250, 220);
    }

    public void Update() {
        super.Update();
        if (_mapCur == null) {
            _objT.SetScale(0, 0);
            return;
        }
        if (!bm.IsInMap(_mapCur.GetMapX(), _mapCur.GetMapY())) {
            _objT.SetScale(0, 0);
            return;
        }

        FETerrain terrain = bm.GetTerrains()[_mapCur.GetMapY()][_mapCur.GetMapX()];
        if (terrain == null) {
            _objT.SetScale(0, 0);
            return;
        } else {
            _objT.SetScale(1, 1);

            boolean f = mouseY < height / 2;
            _objT.SetTranslation(0, (f?1:-1) * ((height - _objT.GetSize().y) / 2 - 5));
        }
    }
}

/**
 カーソルを表示する
 また、マウスカーソルの座標をマネージャに送信し続ける
 */
public class FEMapCursor extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_CURSOR;
    }

    private FEBattleMapManager bm;

    private FEMapMouseCursor _mapCur;
    private PVector _cursorCenter;
    private float _rad;

    public FEMapCursor(SceneObject obj) {
        super();
        _cursorCenter = new PVector();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
        FESceneBattleMap sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();
        inputManager.GetMouseClickedHandler().GetEvents().Add("FE Battle Map Interface On Click", new IEvent() {
            public void Event() {
                bm.OnClick(_mapCur.GetMapX(), _mapCur.GetMapY());
            }
        }
        );
    }

    public void Draw() {
        super.Draw();
        bm.OnOverlapped(_mapCur.GetMapX(), _mapCur.GetMapY());

        int mode = bm.GetOperationMode();
        int rad = FEConst.SYSTEM_MAP_GRID_PX / 2;
        float offset = rad + 3 * abs(sin(_rad)) - 3;
        _rad = (_rad + 4/frameRate) % TWO_PI;
        _cursorCenter.x = _mapCur.GetMapX() * FEConst.SYSTEM_MAP_GRID_PX + rad;
        _cursorCenter.y = _mapCur.GetMapY() * FEConst.SYSTEM_MAP_GRID_PX + rad;

        translate(_cursorCenter.x, _cursorCenter.y);
        for (int i=0; i<4; i++) {
            translate(-offset, -offset);
            fill(0);
            rect(0, 0, 4, 14);
            rect(0, 0, 14, 4);
            switch(mode) {
            default:
                fill(255);
                break;
            case FEConst.BATTLE_OPE_MODE_ACTIVE:
                fill(255, 0, 0);
                break;
            }
            rect(1, 1, 2, 12);
            rect(1, 1, 12, 2);
            translate(offset, offset);
            rotate(HALF_PI);
        }
    }
}