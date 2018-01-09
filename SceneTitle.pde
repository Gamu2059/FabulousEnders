public final class SceneTitle extends Scene {
    private String titleBack, titleText, dustF, dustE, fire, buttonBack;
    private String[] titleButtons;

    public SceneTitle() {
        super(SceneID.SID_TITLE);
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(2);

        titleBack = "TitleBack";
        titleText = "TitleNext";
        dustF = "DustEffectF";
        dustE = "DustEffectE";
        fire = "FireEffect";
        buttonBack = "ButtonBack";
        titleButtons = new String[]{"TitleStart", "TitleLoad", "TitleOption"};

        SceneObject obj;
        SceneObjectTransform objT;

        // 背景
        obj = new SceneObject(titleBack, this);
        SceneObjectImage backImg = new SceneObjectImage(obj, "title/back.png");
        backImg.GetColorInfo().SetAlpha(50);
        obj.SetActivatable(false);

        // タイトル
        obj = new SceneObject(titleText, this);
        obj.GetTransform().SetPriority(10);
        obj.SetActivatable(false);
        new SceneObjectImage(obj, "title/title.png");

        // ボタンとか
        String[] paths = new String[]{"start", "load", "option"};

        for (int i=0; i<3; i++) {
            obj = new SceneObject(titleButtons[i], this);
            objT = obj.GetTransform();
            objT.SetPriority(20);
            objT.SetTranslation(0, -(2-i) * 50 - 20);
            objT.SetSize(180, 50);
            objT.SetAnchor(0.5, 1, 0.5, 1);
            objT.SetPivot(0.5, 1);
            new SceneObjectImage(obj, "title/"+ paths[i] +".png");
            TitleButton b = new TitleButton(obj, titleButtons[i]);
            b.GetDecideHandler().GetEvents().Add("Go GameOver", new IEvent() {
                public void Event() {
                    feManager.StartGame();
                    feManager.GetBattleMapManager().LoadMapData("test_map.json");
                    sceneManager.ReleaseScene(SceneID.SID_TITLE);
                    sceneManager.LoadScene(SceneID.SID_FE_BATTLE_MAP);
                }
            }
            );
        }

        // 塵エフェクト
        String[] dustPaths = new String[20];
        for (int i=0; i<20; i++) {
            dustPaths[i] = "title/dust/_" + i/10 + "_" + i%10 + ".png";
        }

        obj = new SceneObject(dustF, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(203, 118);
        objT.SetSize(100, 0);
        objT.SetRotate(-1.114);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 5, 15, radians(-92) - objT.GetRotate(), 70, dustPaths);

        obj = new SceneObject(dustE, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(277, 252);
        objT.SetSize(100, 0);
        objT.SetRotate(-1.114);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 5, 15, radians(-90) - objT.GetRotate(), 70, dustPaths);

        // 火の粉エフェクト
        String[] firePaths = new String[20];
        for (int i=0; i<20; i++) {
            firePaths[i] = "title/fire/_" + i/10 + "_" + i%10 + ".png";
        }

        obj = new SceneObject(fire, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(width/2, height);
        objT.SetSize(width, 0);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 10, 30, radians(45) - objT.GetRotate(), 30, firePaths);

        // ボタン背景
        obj = new SceneObject(buttonBack, this);
        new SceneObjectImage(obj, "title/menuback.png");
        new TitleButtonBack(obj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        SceneObject obj;
        SceneObjectImage img;

        obj = GetObject(titleBack);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        
        feManager.GetProgressDataBase().SetSceneMoce(FEConst.OVERALL_MODE_TITLE);
    }

    public void OnDisabled() {
        super.OnDisabled();
    }

    public void GoTitle() {
        sceneManager.ReleaseAllScenes();
        sceneManager.LoadScene(SceneID.SID_TITLE);
    }
}

public final class TitleButton extends SceneObjectButton {
    public int GetID() {
        return ClassID.CID_TITLE_BUTTON;
    }

    private SceneObjectImage _img;

    public TitleButton(SceneObject obj, String eventLabel) {
        super(obj, eventLabel);
        _SetEventOnConstructor();
    }

    private void _SetEventOnConstructor() {
        GetEnabledActiveHandler().GetEvents().Add("title button on enabled active", new IEvent() {
            public void Event() {
                _OnEnabledActive();
            }
        }
        );
        GetDisabledActiveHandler().GetEvents().Add("title button on disabled active", new IEvent() {
            public void Event() {
                _OnDisabledActive();
            }
        }
        );
    }

    public void Start() {
        super.Start();
        _img = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
        OnDisabledActive();
    }

    private void _OnEnabledActive() {
        if (_img == null) return;
        _img.GetColorInfo().SetAlpha(255);
    }

    private void _OnDisabledActive() {
        if (_img == null) return;
        _img.GetColorInfo().SetAlpha(100);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleButton is destroyed");
        }
    }
}

public final class TitleDustEffect extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TITLE_DUST_EFFECT;
    }

    // 次のエフェクトを生成するまでの最低スパンと最高スパン 単位は秒
    private float _minSpan, _maxSpan;
    private float _vX, _vY, _alphaD, _relatedRad, _minSize, _maxSize;
    private String[] _paths;

    private float _cntDwn;

    private SceneObjectTransform _objT;

    public TitleDustEffect(SceneObject obj, float minSpan, float maxSpan, float vX, float vY, float minSize, float maxSize, float relatedRad, float alphaD, String[] paths) {
        super();
        _minSpan = minSpan;
        _maxSpan = maxSpan;
        _minSize = minSize;
        _maxSize = maxSize;
        _paths = paths;
        _vX = vX;
        _vY = vY;
        _relatedRad = relatedRad;
        _alphaD = alphaD;

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
    }

    public void Update() {
        super.Update();

        _cntDwn -= 1/frameRate;
        if (_cntDwn <= 0) {
            _cntDwn = random(_minSpan, _maxSpan);

            // 生成処理
            _GenerateDustEffect();
        }
    }

    private void _GenerateDustEffect() {
        SceneObject obj;
        SceneObjectTransform t;
        float x, y, d;
        x = _objT.GetSize().x/2;
        y = _objT.GetSize().y/2;
        d = random(_minSize, _maxSize);

        obj = new SceneObject("Title Dust Effect " + random(1000));
        obj.SetActivatable(false);
        t = obj.GetTransform();

        GetObject().GetScene().AddObject(obj);
        t.SetParent(GetObject().GetTransform(), true);

        t.SetAnchor(0.5, 0.5, 0.5, 0.5);
        t.SetTranslation(random(-x, x), random(-y, y));
        t.SetSize(d, d);

        new TitleDustImage(obj, _paths[(int)random(_paths.length)], _vX, _vY, _relatedRad, random(0.01, 0.05), _alphaD);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleDustEffect is destroyed");
        }
    }
}

public final class TitleDustImage extends SceneObjectImage {
    public int GetID() {
        return ClassID.CID_TITLE_DUST_IMAGE;
    }

    private PVector _velocity;

    // 親オブジェクトの角度に対して相対的に飛んでいく角度
    private float _relatedRad;

    // 自身の角速度
    private float _radVelocity;

    // 1秒あたりの透明度増加量
    private float _alphaDuration;

    private SceneObjectTransform _objT;

    public TitleDustImage(SceneObject obj, String imagePath, float vX, float vY, float relatedRad, float rad, float alphaD) {
        super(obj, imagePath);
        _velocity = new PVector(vX, vY);
        _relatedRad = relatedRad;
        _radVelocity = rad;
        _alphaDuration = alphaD;
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
    }

    public void Update() {
        super.Update();
        if (_objT == null) return;
        PVector t = _objT.GetTranslation();
        _objT.SetTranslation(t.x + _GetX(), t.y + _GetY());
        _objT.SetRotate(_objT.GetRotate() + _radVelocity);

        float a = GetColorInfo().GetAlpha() - _alphaDuration / frameRate;
        if (a > 0) {
            GetColorInfo().SetAlpha(a);
        } else {
            GetObject().Destroy();
        }
    }

    private float _GetX() {
        return _velocity.x * cos(_relatedRad) - _velocity.y * sin(_relatedRad);
    }

    private float _GetY() {
        return _velocity.x * sin(_relatedRad) + _velocity.y * cos(_relatedRad);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleDustImage is destroyed");
        }
    }
}

public final class TitleButtonBack extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TITLE_BUTTON_BACK;
    }

    private SceneObject _actObj;
    private SceneObjectTransform _objT;
    private SceneObjectImage _objImg;
    private float _rad;

    public TitleButtonBack(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Start() {
        super.Start();

        GetObject().SetActivatable(false);
        _objT = GetObject().GetTransform();
        _objT.SetAnchor(0.5, 1, 0.5, 1);
        _objT.SetSize(240, 20);
        _objT.SetPriority(15);

        _objImg = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
    }

    public void Update() {
        super.Update();

        _actObj = GetObject().GetScene().GetActiveObject();
        if (_actObj != null) {
            _objT.SetScale(1, 1);
            PVector actPos = _actObj.GetTransform().GetTranslation();
            _objT.SetTranslation(actPos.x, actPos.y-10);
        } else {
            _objT.SetScale(0, 0);
        }

        if (_objImg != null) {
            _objImg.GetColorInfo().SetAlpha(abs(cos(_rad)) * 255);
            _rad += 2/frameRate;
            _rad %= TWO_PI;
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleButtonBack is destroyed");
        }
    }
}