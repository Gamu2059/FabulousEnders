/**
 戦闘マップ及びマップイベントを描画するシーン。
 */
public class FESceneBattleMap extends Scene {
    private SceneObject mapImageObj, terrainImageObj, hazardAreaObj, actionRangeObj, mapElementObj, cursorObj, unitViewObj;

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

        mapElementObj = new SceneObject("Map Element Object", this);
        objT = mapElementObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.SetPriority(objT.GetPriority() + 4);
        new FEMapObjectDrawer(mapElementObj);

        unitViewObj = new SceneObject("Unit View Object", this);
        new FEMapUnitViewer(unitViewObj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        FEBattleMapManager bm = feManager.GetBattleMapManager();
        SceneObjectTransform objT = mapImageObj.GetTransform();

        objT.SetSize(bm.GetMapSize().x * FEConst.SYSTEM_MAP_GRID_PX, bm.GetMapSize().y * FEConst.SYSTEM_MAP_GRID_PX);
        mapImage.SetUsingImageName(bm.GetMapImagePath());
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
        int x, y;
        String imgPath;
        for (int i=0; i<bm.GetMapElements().size(); i++) {
            e = bm.GetMapElements().get(i);
            o = e.GetMapObject();
            if (o == null) continue;
            if (o.GetMapImageFolderPath() == null) continue;

            imgPath = o.GetMapImageFolderPath() + "/N" + _DrawIdx(runIdx) + ".png";
            if (imageManager.GetImage(imgPath) == null) continue;
            pos = e.GetPosition();
            x = int(pos.x);
            y = int(pos.y);
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
        _mapW = (int)feManager.GetBattleMapManager().GetMapSize().x;
        _mapH = (int)feManager.GetBattleMapManager().GetMapSize().y;
        println(_mapW);
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

        stroke(200, 0, 0);
        strokeWeight(2);
        rect(_mapX * FEConst.SYSTEM_MAP_GRID_PX + 2, _mapY * FEConst.SYSTEM_MAP_GRID_PX + 2, FEConst.SYSTEM_MAP_GRID_PX - 4, FEConst.SYSTEM_MAP_GRID_PX - 4);
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

            boolean f = _mapCur.GetMapY() < feManager.GetBattleMapManager().GetMapSize().y / 2;
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