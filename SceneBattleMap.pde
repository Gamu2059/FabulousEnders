/**
 戦闘マップ及びマップイベントを描画するシーン。
 */
public class FESceneBattleMap extends Scene {
    private SceneObject mapImageObj, actionRangeObj, mapElementObj, unitViewObj, terrainViewObj, cursorObj, opeMenuObj, unitMenuObj;

    private SceneObjectImage mapImage;

    private FEMapMouseCursor mapCursor;
    public FEMapMouseCursor GetMapCursor() {
        return mapCursor;
    }

    private boolean _isOpenMenu;
    public boolean IsOpenMenu() {
        return _isOpenMenu;
    }
    public void SetOpenMenu(boolean value) {
        _isOpenMenu = value;
    }

    public FESceneBattleMap() {
        super(SceneID.SID_FE_BATTLE_MAP);

        SceneObjectTransform objT;

        mapImageObj = new SceneObject("Map Image Object", this);
        objT = mapImageObj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        mapImage = new FEMapImageDrawer(mapImageObj, null);
        mapCursor = new FEMapMouseCursor(mapImageObj);
        new FEMapScroller(mapImageObj);

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
        new FEMapUnitAnimator(mapElementObj);

        unitViewObj = new SceneObject("Unit View Object", this);
        new FEMapUnitViewer(unitViewObj);

        terrainViewObj = new SceneObject("Terrain View Object", this);
        new FEMapTerrainViewer(terrainViewObj);

        cursorObj = new SceneObject("Cursor Object", this);
        objT = cursorObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.AddPriority(7);
        new FEMapCursor(cursorObj);

        opeMenuObj = new SceneObject("Operate Menu Object", this);
        objT = opeMenuObj.GetTransform();
        objT.AddPriority(100);
        new FEMapOperateMenuViewer(opeMenuObj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        FEBattleMapManager bm = feManager.GetBattleMapManager();
        SceneObjectTransform objT = mapImageObj.GetTransform();

        objT.SetSize(bm.GetMapWidth() * FEConst.SYSTEM_MAP_GRID_PX, bm.GetMapHeight() * FEConst.SYSTEM_MAP_GRID_PX);
        mapImage.SetUsingImageName(bm.GetMapImagePath());

        objT.SetTranslation((width-objT.GetSize().x)/2f, (height-objT.GetSize().y)/2f);
    }
}

/**
 マップ背景および地形オブジェクトの描画を行う振る舞い。
 */
public class FEMapImageDrawer extends SceneObjectImage {
    public int GetID() {
        return ClassID.CID_FE_MAP_IMAGE_DRAWER;
    }
    private FEBattleMapManager bm;
    float offset;
    public FEMapImageDrawer(SceneObject obj, String path) {
        super(obj, path);
    }
    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
        offset = (FEConst.SYSTEM_MAP_GRID_PX - FEConst.SYSTEM_MAP_OBJECT_PX) / 2;
    }
    public void Draw() {
        super.Draw();
        float x, y;
        String imgPath;
        for (int i=0; i<bm.GetMapHeight(); i++) {
            for (int j=0; j<bm.GetMapWidth(); j++) {
                imgPath = bm.GetTerrains()[i][j].GetMapImagePath();
                if (imageManager.GetImage(imgPath) == null) continue;
                tint(255, 255, 255);
                x = j * FEConst.SYSTEM_MAP_GRID_PX + offset;
                y = i * FEConst.SYSTEM_MAP_GRID_PX + offset;
                image(imageManager.GetImage(imgPath), x, y, FEConst.SYSTEM_MAP_OBJECT_PX, FEConst.SYSTEM_MAP_OBJECT_PX);
            }
        }
    }
}

public class FEMapScroller extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_SCROLLER;
    }

    private SceneObjectTransform objT;

    private boolean isFixX, isFixY, flag;
    private PVector pos;

    public FEMapScroller(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        objT = GetObject().GetTransform();

        pos = objT.GetTranslation();
        flag = false;
    }

    public void Draw() {
        super.Draw();
        if (!flag) {
            isFixX = objT.GetSize().x <= width;
            isFixY = objT.GetSize().y <= height;
            flag = true;
        }
        if (!isFixX) {
            if (mouseX < 100) {
                objT.SetTranslation(pos.x + 5, pos.y);
                if (objT.GetTranslation().x > 0) {
                    objT.SetTranslation(0, pos.y);
                }
            }
            if (mouseX > width - 100) {
                objT.SetTranslation(pos.x - 5, pos.y);
                if (objT.GetTranslation().x < width - objT.GetSize().x) {
                    objT.SetTranslation(width - objT.GetSize().x, pos.y);
                }
            }
        }
        if (!isFixY) {
            if (mouseY < 100) {
                objT.SetTranslation(pos.x, pos.y + 5);
                if (objT.GetTranslation().y > 0) {
                    objT.SetTranslation(pos.x, 0);
                }
            }
            if (mouseY > height - 100) {
                objT.SetTranslation(pos.x, pos.y - 5);
                if (objT.GetTranslation().y < height - objT.GetSize().y) {
                    objT.SetTranslation(pos.x, height - objT.GetSize().y);
                }
            }
        }
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

        int[][] ar;
        // 危険領域
        ar = bm.GetHazardAreas();
        for (int i=0; i<bm.GetMapHeight(); i++) {
            for (int j=0; j<bm.GetMapWidth(); j++) {
                switch(ar[i][j]) {
                case FEConst.BATTLE_MAP_MARKER_ATTACK:
                    _DrawRange(j, i, 200, 0, 0, 150);
                    break;
                case FEConst.BATTLE_MAP_MARKER_CANE:
                    _DrawRange(j, i, 0, 200, 200, 150);
                    break;
                }
            }
        }

        // 行動範囲
        if (_IsDrawable(false)) {
            ar = bm.GetActionRanges();
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
    }

    private void _DrawRange(int x, int y, int r, int g, int b, int a) {
        noStroke();
        fill(r, g, b, a);
        rect(x * FEConst.SYSTEM_MAP_GRID_PX + 1, y * FEConst.SYSTEM_MAP_GRID_PX + 1, FEConst.SYSTEM_MAP_GRID_PX - 2, FEConst.SYSTEM_MAP_GRID_PX - 2);
    }

    private boolean _IsDrawable(boolean isHazardDraw) {
        if (isHazardDraw) {
            return true;
        } else {
            switch(bm.GetOperationMode()) {
            default:
                if (!bm.GetActionPhase()) {
                    return false;
                }
                return true;
            case FEConst.BATTLE_OPE_MODE_MOVING:
            case FEConst.BATTLE_OPE_MODE_FINISH_MOVE:
            case FEConst.BATTLE_OPE_MODE_BATTLE_START:
            case FEConst.BATTLE_OPE_MODE_BATTLE:
            case FEConst.BATTLE_OPE_MODE_BATTLE_RESULT:
            case FEConst.BATTLE_OPE_MODE_BATTLE_DEAD:
                return false;
            }
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
        FEUnit u;
        PVector pos;
        float x, y, rate;
        String imgPath;
        colorMode(HSB, 360, 100, 100, 255);
        noStroke();
        for (int i=0; i<bm.GetMapElements().size(); i++) {
            e = bm.GetMapElements().get(i);
            o = e.GetMapObject();
            if (o == null) continue;
            if (o.GetMapImageFolderPath() == null) continue;

            imgPath = o.GetMapImageFolderPath() + "/N" + (e.IsAnimation()&&!e.IsAlready()?_DrawIdx(e.IsRunning()?runIdx:normalIdx):0) + ".png";
            if (imageManager.GetImage(imgPath) == null) continue;
            pos = e.GetPosition();
            x = pos.x;
            y = pos.y;
            x = x * FEConst.SYSTEM_MAP_GRID_PX + offset;
            y = y * FEConst.SYSTEM_MAP_GRID_PX + offset;
            if (e.IsDrawHazardAres()) {
                tint(0, 100, e.IsAlready()?50:100, e.GetAlpha());
            } else {
                tint(0, 0, e.IsAlready()?50:100, e.GetAlpha());
            }
            image(imageManager.GetImage(imgPath), x, y, FEConst.SYSTEM_MAP_OBJECT_PX, FEConst.SYSTEM_MAP_OBJECT_PX);

            // HPゲージを表示する
            if (!(o instanceof FEUnit)) continue;
            u = (FEUnit) o;
            fill(0, e.GetAlpha());
            rect(x + 12, y + FEConst.SYSTEM_MAP_OBJECT_PX - 15, 36, 5);
            rate = (float)u.GetHp() / u.GetBaseParameter().GetHp();
            fill(0, 100, 20, e.GetAlpha());
            rect(x + 13, y + FEConst.SYSTEM_MAP_OBJECT_PX - 14, 34, 3);
            fill(rate * 180, 100, 100, e.GetAlpha());
            rect(x + 13, y + FEConst.SYSTEM_MAP_OBJECT_PX - 14, 34 * rate, 3);

            // ユニットの消滅は不透明度で判断する
            if (e.IsDead()) {
                e.SetAlpha((int)(e.GetAlpha() - 255/(frameRate * 0.5)));
                if (e.GetAlpha() <= 0) {
                    bm.RemoveDeadElement(e);
                }
            }
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
 ユニットのアニメーションイベントが生じた時に、自動的にイベントを移動させる。
 */
public class FEMapUnitAnimator extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_UNIT_ANIMATOR;
    }

    private SceneObjectDuration duration;
    private String moveLabel, battleLabel;

    private FEBattleMapManager bm;
    private boolean isMoving, isBattling;
    // 移動に使用する変数
    private int routeIdx;

    // 戦闘に使用する変数
    private PVector atkPos, defPos, pos;
    private float atkRad;
    private float atkDir;
    private boolean isGoing;

    public FEMapUnitAnimator(SceneObject obj) {
        super();
        duration = new SceneObjectDuration(obj);
        moveLabel = "FEMapUnitAnimator Moving Duration";
        battleLabel = "FEMapUnitAnimator Battler Duration";
        pos = new PVector();
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

        duration.GetDurations().Add(moveLabel, new IDuration() {
            private PVector aimPos, crtPos;
            private FEMapElement elem;
            private SceneObjectDuration dur;
            private float settedTime, rate, dX, dY;

            public void OnInit() {
                dur = duration;
                settedTime = dur.GetSettedTimer(moveLabel);
                aimPos = bm.GetUnitRoute().get(routeIdx);
                elem = bm.GetSelectedElement();
                if (elem == null) {
                    duration.Stop(moveLabel);
                }
                crtPos = elem.GetPosition();
                dX = aimPos.x - crtPos.x;
                dY = aimPos.y - crtPos.y;
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                rate = frameRate * settedTime;
                crtPos.x += dX / rate;
                crtPos.y += dY / rate;
            }
            public void OnEnd() {
                crtPos.x = aimPos.x;
                crtPos.y = aimPos.y;
                routeIdx--;
                if (routeIdx >= 0) {
                    dur.ResetTimer(moveLabel, feManager.GetConfig().GetUnitMoveTime());
                    dur.Start(moveLabel);
                } else {
                    isMoving = false;
                    bm.OnFinishMoving();
                }
            }
        }
        );
        duration.GetDurations().Add(battleLabel, new IDuration() {
            private SceneObjectDuration dur;
            private float settedTime;
            private int attackNum;
            public void OnInit() {
                dur = duration;
                settedTime = dur.GetSettedTimer(battleLabel);

                // 戦闘開始時は攻撃回数をリセットする
                if (bm.GetOperationMode() == FEConst.BATTLE_OPE_MODE_BATTLE_START) {
                    if (bm.GetBattlePhase()) {
                        attackNum = bm.GetAttackerAttackNum();
                    } else {
                        attackNum = bm.GetDefenderAttackNum();
                    }
                }
                if (isGoing) {
                    // 命中判定などを行う
                    bm.Battle();
                    if (bm.GetBattlePhase()) {
                        pos.x = atkPos.x;
                        pos.y = atkPos.y;
                    } else {
                        pos.x = defPos.x;
                        pos.y = defPos.y;
                    }
                }
            }

            public boolean IsContinue() {
                return true;
            }

            public void OnUpdate() {
                _BattlerGoing(settedTime);
            }

            public void OnEnd() {
                if (isGoing) {
                    isGoing = false;
                    bm.BattleDamage();
                    dur.ResetTimer(battleLabel, 0.1);
                    dur.Start(battleLabel);
                } else {
                    if (bm.GetBattlePhase()) {
                        atkPos.x = pos.x;
                        atkPos.y = pos.y;
                    } else {
                        defPos.x = pos.x;
                        defPos.y = pos.y;
                    }
                    if (bm.IsBattlerDead()) {
                        _BattleEnd();
                        return;
                    }
                    isGoing = true;
                    attackNum--;
                    if (attackNum == 0 && bm.IsBattleEnd()) {
                        _BattleEnd();
                        return;
                    }
                    duration.SetUseTimer(battleLabel, true);
                    duration.ResetTimer(battleLabel, 0.1);
                    duration.Start(battleLabel);
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
            duration.SetUseTimer(moveLabel, true);
            duration.ResetTimer(moveLabel, feManager.GetConfig().GetUnitMoveTime());
            duration.Start(moveLabel);
        } else if (bm.GetOperationMode() == FEConst.BATTLE_OPE_MODE_BATTLE_START && !isBattling) {
            isBattling = true;
            atkPos = bm.GetAttackerElement().GetPosition();
            defPos = bm.GetDefenderElement().GetPosition();
            atkRad = GeneralCalc.GetRad(defPos, atkPos);
            isGoing = true;
            duration.SetUseTimer(battleLabel, true);
            duration.ResetTimer(battleLabel, 0.1);
            duration.Start(battleLabel);
        }
    }

    private void _BattlerGoing(float settedTime) {
        float rate = frameRate * settedTime;
        if (bm.GetBattlePhase()) {
            if (isGoing) {
                atkPos.x += 0.4 * cos(atkRad) / rate;
                atkPos.y += 0.4 * sin(atkRad) / rate;
            } else {
                atkPos.x -= 0.4 * cos(atkRad) / rate;
                atkPos.y -= 0.4 * sin(atkRad) / rate;
            }
        } else {
            if (isGoing) {
                defPos.x += 0.4 * cos(atkRad + PI) / rate;
                defPos.y += 0.4 * sin(atkRad + PI) / rate;
            } else {
                defPos.x -= 0.4 * cos(atkRad + PI) / rate;
                defPos.y -= 0.4 * sin(atkRad + PI) / rate;
            }
        }
    }

    private void _BattleEnd() {
        duration.Stop(battleLabel);
        isBattling = false;
        bm.OnFinishBattle();
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
    private SceneObjectImage _faceImg, wepImg;
    private SceneObjectText levelTx, nameTx, wepTx, hpTx;

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

        SceneObject obj;
        SceneObjectText tex;

        obj = new SceneObject("Unit Parameter Viewer Level Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmBackObj.GetTransform(), true);
        objT.SetSize(40, 30);
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        tex = new SceneObjectText(obj, "Lv.");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(18);
        tex.GetColorInfo().SetColor(240, 220, 190);

        obj = new SceneObject("Unit Parameter Viewer Level Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmBackObj.GetTransform(), true);
        objT.SetSize(40, 30);
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        objT.SetTranslation(10, 0);
        levelTx = new SceneObjectText(obj, "");
        levelTx.SetAlign(RIGHT, CENTER);
        levelTx.SetFontSize(18);
        levelTx.GetColorInfo().SetColor(255, 255, 255);

        obj = new SceneObject("Unit Parameter Viewer Unit Name Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmBackObj.GetTransform(), true);
        objT.SetSize(0, 30);
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        objT.SetOffsetMin(0, 0);
        nameTx = new SceneObjectText(obj, "");
        nameTx.SetAlign(CENTER, CENTER);
        nameTx.SetFontSize(16);
        nameTx.GetColorInfo().SetColor(255, 255, 255);

        obj = new SceneObject("Unit Parameter Viewer Weapon Icon Image", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmFrontObj.GetTransform(), true);
        objT.SetSize(30, 30);
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        objT.SetTranslation(2, 2);
        wepImg = new SceneObjectImage(obj, null);

        obj = new SceneObject("Unit Parameter Viewer Unit Weapon Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmFrontObj.GetTransform(), true);
        objT.SetAnchor(0, 0, 0.5, 1);
        objT.SetOffsetMin(35, 0);
        wepTx = new SceneObjectText(obj, "武勲の剣");
        wepTx.SetAlign(CENTER, CENTER);
        wepTx.SetFontSize(14);
        wepTx.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Unit Parameter Viewer HP Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmFrontObj.GetTransform(), true);
        objT.SetAnchor(0.5, 0, 1, 1);
        objT.SetOffsetMax(-50, 0);
        tex = new SceneObjectText(obj, "HP : ");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(14);
        tex.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Unit Parameter Viewer HP Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_prmFrontObj.GetTransform(), true);
        objT.SetAnchor(1, 0, 1, 1);
        objT.SetPivot(1, 0.5);
        objT.SetSize(60, 0);
        hpTx = new SceneObjectText(obj, "");
        hpTx.SetAlign(LEFT, CENTER);
        hpTx.SetFontSize(14);
        hpTx.GetColorInfo().SetColor(50, 50, 100);
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
            if (feManager.GetBattleMapManager().GetSortieUnits().contains(unit)) {
                _prmBack.GetBackColorInfo().SetColor(20, 60, 130);
                _faceBack.GetBackColorInfo().SetColor(20, 60, 130);
            } else if (feManager.GetBattleMapManager().GetSortieEnemyUnits().contains(unit)) {
                _prmBack.GetBackColorInfo().SetColor(150, 0, 20);
                _faceBack.GetBackColorInfo().SetColor(150, 0, 20);
            }

            levelTx.SetText(unit.GetLevel()+"");
            nameTx.SetText(unit.GetName());

            FEWeapon item;
            if (unit.GetEquipWeapon() != null) {
                item = (FEWeapon)unit.GetEquipWeapon().GetItem();
                FEWeaponClass wc = feManager.GetDataBase().GetWeaponClasses().get(item.GetWeaponClassID());
                wepImg.SetUsingImageName(wc.GetIconImagePath());
                wepTx.SetText(item.GetName());
            } else {
                wepImg.SetUsingImageName("icon/base.png");
                wepTx.SetText("");
            }

            hpTx.SetText(unit.GetHp() + " / " + unit.GetParameter().GetHp());
            float rate = (float)unit.GetHp()/unit.GetParameter().GetHp();
            if (rate < 0.4) {
                hpTx.GetColorInfo().SetColor(250, 20, 20);
            } else {
                hpTx.GetColorInfo().SetColor(50, 50, 100);
            }
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

    private SceneObjectText nameTx, avoidTx, recoverTx, defTx, mdfTx;

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

        // テキストオブジェクト
        SceneObject obj;
        SceneObjectText tex;
        obj = new SceneObject("Terrain Viewer Terrain Name", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terBackObj.GetTransform(), true);
        objT.SetSize(0, 30);
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        nameTx = new SceneObjectText(obj, "");
        nameTx.SetAlign(CENTER, CENTER);
        nameTx.SetFontSize(18);
        nameTx.GetColorInfo().SetColor(240, 220, 190);

        obj = new SceneObject("Terrain Viewer Avoid Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0, 0, 0.25, 0.5);
        objT.SetOffsetMin(20, 0);
        objT.SetOffsetMax(-10, 0);
        tex = new SceneObjectText(obj, "回避");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(14);
        tex.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Terrain Viewer Recover Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0, 0.5, 0.25, 1);
        objT.SetOffsetMin(20, 0);
        objT.SetOffsetMax(-10, 0);
        tex = new SceneObjectText(obj, "回復");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(14);
        tex.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Terrain Viewer Defense Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.5, 0, 0.75, 0.5);
        objT.SetOffsetMin(20, 0);
        objT.SetOffsetMax(-10, 0);
        tex = new SceneObjectText(obj, "防御");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(14);
        tex.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Terrain Viewer MDefense Label", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.5, 0.5, 0.75, 1);
        objT.SetOffsetMin(20, 0);
        objT.SetOffsetMax(-10, 0);
        tex = new SceneObjectText(obj, "魔防");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(14);
        tex.GetColorInfo().SetColor(50, 50, 100);

        obj = new SceneObject("Terrain Viewer Avoid Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.25, 0, 0.5, 0.5);
        objT.SetOffsetMin(10, 0);
        objT.SetOffsetMax(-20, 0);
        avoidTx = new SceneObjectText(obj, "");
        avoidTx.SetAlign(CENTER, CENTER);
        avoidTx.SetFontSize(14);

        obj = new SceneObject("Terrain Viewer Recover Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.25, 0.5, 0.5, 1);
        objT.SetOffsetMin(10, 0);
        objT.SetOffsetMax(-20, 0);
        recoverTx = new SceneObjectText(obj, "");
        recoverTx.SetAlign(CENTER, CENTER);
        recoverTx.SetFontSize(14);

        obj = new SceneObject("Terrain Viewer Defense Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.75, 0, 1, 0.5);
        objT.SetOffsetMin(10, 0);
        objT.SetOffsetMax(-20, 0);
        defTx = new SceneObjectText(obj, "");
        defTx.SetAlign(CENTER, CENTER);
        defTx.SetFontSize(14);

        obj = new SceneObject("Terrain Viewer MDefense Text", sbm);
        objT = obj.GetTransform();
        objT.SetParent(_terFrontObj.GetTransform(), true);
        objT.SetAnchor(0.75, 0.5, 1, 1);
        objT.SetOffsetMin(10, 0);
        objT.SetOffsetMax(-20, 0);
        mdfTx = new SceneObjectText(obj, "");
        mdfTx.SetAlign(CENTER, CENTER);
        mdfTx.SetFontSize(14);
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
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(terrain.GetEffectID());
        if (terrain == null) {
            _objT.SetScale(0, 0);
            return;
        } else {
            _objT.SetScale(1, 1);

            boolean f = mouseY < height / 2;
            _objT.SetTranslation(0, (f?1:-1) * ((height - _objT.GetSize().y) / 2 - 5));

            nameTx.SetText(terrain.GetName());

            if (terE.IsMovable()) {
                int value;
                value = terE.GetAvoid();
                _SetTextColor(value, avoidTx);
                avoidTx.SetText(value+"");

                value = terE.GetRecover();
                _SetTextColor(value, recoverTx);
                recoverTx.SetText(value+"");

                value = terE.GetDefense();
                _SetTextColor(value, defTx);
                defTx.SetText(value+"");

                value = terE.GetMDefense();
                _SetTextColor(value, mdfTx);
                mdfTx.SetText(value+"");
            } else {
                avoidTx.GetColorInfo().SetColor(0, 0, 0);
                avoidTx.SetText("--");
                recoverTx.GetColorInfo().SetColor(0, 0, 0);
                recoverTx.SetText("--");
                defTx.GetColorInfo().SetColor(0, 0, 0);
                defTx.SetText("--");
                mdfTx.GetColorInfo().SetColor(0, 0, 0);
                mdfTx.SetText("--");
            }
        }
    }

    private void _SetTextColor(int value, SceneObjectText tex) {
        if (value > 0) {
            tex.GetColorInfo().SetColor(30, 220, 250);
        } else if (value < 0) {
            tex.GetColorInfo().SetColor(150, 10, 10);
        } else {
            tex.GetColorInfo().SetColor(0, 0, 0);
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

    private FESceneBattleMap sbm;
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
        sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();
        inputManager.GetMouseClickedHandler().GetEvents().Add("FE Battle Map Interface On Click", new IEvent() {
            public void Event() {
                if (bm.GetActionPhase() && !sbm.IsOpenMenu()) {
                    bm.OnClick(_mapCur.GetMapX(), _mapCur.GetMapY());
                }
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

        colorMode(RGB, 255, 255, 255);
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

public class FEMapOperateMenuViewer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_OPERATE_VIEWER;
    }

    private FEBattleMapManager bm;
    private FESceneBattleMap sbm;

    private FEMapMouseCursor _mapCur;
    private SceneObjectTransform atkMenuT, itemMenuT, waitMenuT, resetMenuT;
    private SceneObjectDrawBack atkMenuD, itemMenuD, waitMenuD, resetMenuD;

    public FEMapOperateMenuViewer(SceneObject obj) {
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
        sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();

        SceneObject obj;
        SceneObjectDrawBack objD;
        SceneObjectText tex;
        SceneObjectButton btn;

        obj = new SceneObject("OperateMenu Viewer Attack Menu", sbm);
        atkMenuT = obj.GetTransform();
        atkMenuT.SetParent(GetObject().GetTransform(), true);
        atkMenuT.SetAnchor(0, 0, 0, 0);
        atkMenuT.SetPivot(0, 0);
        atkMenuT.SetSize(120, 30);
        atkMenuD = obj.GetDrawBack();
        atkMenuD.SetEnable(true, false);
        atkMenuD.GetBorderColorInfo().SetColor(150, 255, 255);
        atkMenuD.SetBorderSize(3);
        atkMenuD.SetCorner(7);
        atkMenuD.GetBackColorInfo().SetColor(20, 60, 130);
        tex = new SceneObjectText(obj, "攻撃");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(16);
        tex.GetColorInfo().SetColor(240, 220, 190);
        btn = new SceneObjectButton(obj, "FESceneBattleMap Operate Menu Viewer Attack Menu Button");
        btn.GetDecideHandler().GetEvents().Add("On Click", new IEvent() {
            public void Event() {
                bm.OnClickAttackMenu();
            }
        }
        );
        btn.GetEnabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                atkMenuD.SetEnable(true, true);
            }
        }
        );
        btn.GetDisabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                atkMenuD.SetEnable(true, false);
            }
        }
        );

        obj = new SceneObject("OperateMenu Viewer Item Menu", sbm);
        itemMenuT = obj.GetTransform();
        itemMenuT.SetParent(GetObject().GetTransform(), true);
        itemMenuT.SetAnchor(0, 0, 0, 0);
        itemMenuT.SetPivot(0, 0);
        itemMenuT.SetSize(120, 30);
        itemMenuD = obj.GetDrawBack();
        itemMenuD.SetEnable(true, false);
        itemMenuD.GetBorderColorInfo().SetColor(150, 255, 255);
        itemMenuD.SetBorderSize(3);
        itemMenuD.SetCorner(7);
        itemMenuD.GetBackColorInfo().SetColor(20, 60, 130);
        tex = new SceneObjectText(obj, "持ち物");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(16);
        tex.GetColorInfo().SetColor(240, 220, 190);
        btn = new SceneObjectButton(obj, "FESceneBattleMap Operate Menu Viewer Item Menu Button");
        btn.GetDecideHandler().GetEvents().Add("On Click", new IEvent() {
            public void Event() {
                bm.OnClickItemMenu();
            }
        }
        );
        btn.GetEnabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                itemMenuD.SetEnable(true, true);
            }
        }
        );
        btn.GetDisabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                itemMenuD.SetEnable(true, false);
            }
        }
        );

        obj = new SceneObject("OperateMenu Viewer Wait Menu", sbm);
        waitMenuT = obj.GetTransform();
        waitMenuT.SetParent(GetObject().GetTransform(), true);
        waitMenuT.SetAnchor(0, 0, 0, 0);
        waitMenuT.SetPivot(0, 0);
        waitMenuT.SetSize(120, 30);
        waitMenuD = obj.GetDrawBack();
        waitMenuD.SetEnable(true, false);
        waitMenuD.GetBorderColorInfo().SetColor(150, 255, 255);
        waitMenuD.SetBorderSize(3);
        waitMenuD.SetCorner(7);
        waitMenuD.GetBackColorInfo().SetColor(20, 60, 130);
        tex = new SceneObjectText(obj, "待機");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(16);
        tex.GetColorInfo().SetColor(240, 220, 190);
        btn = new SceneObjectButton(obj, "FESceneBattleMap Operate Menu Viewer Wait Menu Button");
        btn.GetDecideHandler().GetEvents().Add("On Click", new IEvent() {
            public void Event() {
                bm.OnClickWaitMenu();
            }
        }
        );
        btn.GetEnabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                waitMenuD.SetEnable(true, true);
            }
        }
        );
        btn.GetDisabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                waitMenuD.SetEnable(true, false);
            }
        }
        );

        obj = new SceneObject("OperateMenu Viewer Reset Menu", sbm);
        resetMenuT = obj.GetTransform();
        resetMenuT.SetParent(GetObject().GetTransform(), true);
        resetMenuT.SetAnchor(0, 0, 0, 0);
        resetMenuT.SetPivot(0, 0);
        resetMenuT.SetSize(120, 30);
        resetMenuD = obj.GetDrawBack();
        resetMenuD.SetEnable(true, false);
        resetMenuD.GetBorderColorInfo().SetColor(150, 255, 255);
        resetMenuD.SetBorderSize(3);
        resetMenuD.SetCorner(7);
        resetMenuD.GetBackColorInfo().SetColor(20, 60, 130);
        tex = new SceneObjectText(obj, "やり直す");
        tex.SetAlign(CENTER, CENTER);
        tex.SetFontSize(16);
        tex.GetColorInfo().SetColor(240, 220, 190);
        btn = new SceneObjectButton(obj, "FESceneBattleMap Operate Menu Viewer Reset Menu Button");
        btn.GetDecideHandler().GetEvents().Add("On Click", new IEvent() {
            public void Event() {
                bm.OnClickResetMenu();
            }
        }
        );
        btn.GetEnabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                resetMenuD.SetEnable(true, true);
            }
        }
        );
        btn.GetDisabledActiveHandler().GetEvents().Add("On Active", new IEvent() {
            public void Event() {
                resetMenuD.SetEnable(true, false);
            }
        }
        );
    }

    public void Draw() {
        super.Draw();
        if (bm.GetOperationMode() == FEConst.BATTLE_OPE_MODE_FINISH_MOVE && bm.GetActionPhase()) {
            sbm.SetOpenMenu(true);
            float sX, sY;
            if (bm.IsAttackable()) {
                sX = atkMenuT.GetSize().x + waitMenuT.GetSize().x + resetMenuT.GetSize().x;
                sY = atkMenuT.GetSize().y + waitMenuT.GetSize().y + resetMenuT.GetSize().y + 4;
            } else {
                sX = waitMenuT.GetSize().x + resetMenuT.GetSize().x;
                sY = waitMenuT.GetSize().y + resetMenuT.GetSize().y + 4;
            }
            float x, y;
            boolean fX, fY;
            x = bm.GetSelectedElement().GetPosition().x * FEConst.SYSTEM_MAP_GRID_PX;
            y = bm.GetSelectedElement().GetPosition().y * FEConst.SYSTEM_MAP_GRID_PX;
            fX = x + FEConst.SYSTEM_MAP_GRID_PX + sX >= width;
            fY = y + FEConst.SYSTEM_MAP_GRID_PX + sY >= height;

            atkMenuT.SetTranslation(fX?(x-sX):(x + FEConst.SYSTEM_MAP_GRID_PX), (fY?(y-sY):(y + FEConst.SYSTEM_MAP_GRID_PX)) + (bm.IsAttackable()?0:-1000));
            waitMenuT.SetTranslation(fX?(x-sX):(x + FEConst.SYSTEM_MAP_GRID_PX), (fY?(y-sY):(y + FEConst.SYSTEM_MAP_GRID_PX)) + (bm.IsAttackable()?30:0) + 2);
            resetMenuT.SetTranslation(fX?(x-sX):(x + FEConst.SYSTEM_MAP_GRID_PX), (fY?(y-sY):(y + FEConst.SYSTEM_MAP_GRID_PX)) + (bm.IsAttackable()?60:30) + 4);
        } else {
            sbm.SetOpenMenu(false);
            atkMenuT.SetTranslation(-1000, -1000);
            itemMenuT.SetTranslation(-1000, -1000);
            waitMenuT.SetTranslation(-1000, -1000);
            resetMenuT.SetTranslation(-1000, -1000);
        }
    }
}