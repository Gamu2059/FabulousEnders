public final class SceneGameOver extends Scene {
    private String gameOverBack, gameOverLabel, clickLabel, adjustLayer;
    private String[] sword;

    public SceneGameOver() {
        super(SceneID.SID_GAMEOVER);
        GetDrawBack().GetBackColorInfo().SetColor(0, 0, 0);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        gameOverBack = "GameOverBack";
        gameOverLabel = "GameOverLabel";
        clickLabel = "ClickLabel";
        adjustLayer = "GameOverAdjustLayer";
        sword = new String[7];
        for (int i=0; i<sword.length; i++) {
            sword[i] = "sword" + i;
        }

        SceneObject obj;
        SceneObjectTransform objT;
        SceneObjectButton btn;
        SceneObjectDuration dur;
        SceneObjectTimer timer;

        // クリックしたらタイトルに戻るボタン
        obj = new SceneObject("TitleBackButton", this);
        obj.GetTransform().SetPriority(10);
        btn = new SceneObjectButton(obj, "GameOver TitleBackButton");
        btn.GetDecideHandler().GetEvents().Add("Go Title", new IEvent() {
            public void Event() {
                SceneTitle t = (SceneTitle)sceneManager.GetScene(SceneID.SID_TITLE);
                t.GoTitle();
            }
        }
        );

        // フレームアウト調整レイヤー
        obj = new SceneObject(adjustLayer, this);
        obj.GetTransform().SetPriority(9);
        obj.GetDrawBack().SetEnable(true);
        obj.GetDrawBack().SetEnableBorder(false);
        obj.GetDrawBack().GetBackColorInfo().SetColor(1, 1, 1);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Clean Out", new IDuration() {
            private SceneObjectDrawBack drawBack;
            private SceneObjectDuration duration;
            private float settedTime;
            public void OnInit() {
                drawBack = GetObject(adjustLayer).GetDrawBack();
                drawBack.GetBackColorInfo().SetAlpha(255);
                drawBack.SetEnable(true);
                duration = (SceneObjectDuration)GetObject(adjustLayer).GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = duration.GetSettedTimer("Clean Out");
            }
            public boolean IsContinue() {
                return drawBack.GetBackColorInfo().GetAlpha() > 0;
            }
            public void OnUpdate() {
                float a = drawBack.GetBackColorInfo().GetAlpha();
                if (settedTime <= 0) {
                    OnEnd();
                } else {
                    drawBack.GetBackColorInfo().SetAlpha(a - 255/(frameRate*settedTime));
                }
            }
            public void OnEnd() {
                drawBack.SetEnable(false);
                drawBack.GetBackColorInfo().SetAlpha(0);
            }
        }
        );

        // 背景
        obj = new SceneObject(gameOverBack, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        new SceneObjectImage(obj, "gameover/back.png");
        dur = new SceneObjectDuration(obj);
        dur.SetUseTimer("Back Gradation", false);
        dur.GetDurations().Set("Back Gradation", new IDuration() {
            private SceneObject _obj;
            private SceneObjectTransform _objT;
            private float settedTime;
            public void OnInit() {
                _obj = GetObject(gameOverBack);
                _objT = _obj.GetTransform();
                _objT.SetSize(0, 0);
                SceneObjectImage img = (SceneObjectImage)_obj.GetBehaviorOnID(ClassID.CID_IMAGE);
                img.GetColorInfo().SetAlpha(255);
                SceneObjectDuration _dur = (SceneObjectDuration)_obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Back Gradation");
            }
            public boolean IsContinue() {
                return _objT.GetSize().y < height;
            }
            public void OnUpdate() {
                float y = _objT.GetSize().y;
                if (settedTime <= 0) {
                    _objT.SetSize(0, height);
                } else {
                    _objT.SetSize(0, y + height/(frameRate*settedTime));
                }
            }
            public void OnEnd() {
            }
        }
        );


        // 剣
        for (int i=0; i<sword.length; i++) {
            obj = new SceneObject(sword[i]);
            AddObject(obj);
            objT = obj.GetTransform();
            objT.SetAnchor(0.5, 0.5, 0.5, 0.5);
            new SceneObjectImage(obj, "gameover/" + sword[i] + ".png");
            if (i == 0) {
                AddChild(obj);
                objT.SetPriority(3);
            } else {
                objT.SetParent(GetObject(sword[0]).GetTransform(), true);
            }
        }

        obj = GetObject(sword[0]);
        dur = new SceneObjectDuration(obj);
        timer = new SceneObjectTimer(obj);
        timer.GetTimers().Add("Fire Start Event", new ITimer() {
            public void OnInit() {
            }
            public void OnTimeOut() {
                SceneObjectDuration dur = (SceneObjectDuration)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_DURATION);
                dur.ResetTimer("Rotate Sword", 1);
                dur.SetUseTimer("Rotate Sword", true);
                dur.Start("Rotate Sword");
            }
        }
        );
        dur.GetDurations().Add("Rotate Sword", new IDuration() {
            private SceneObjectTransform _objT;
            private SceneObjectImage _img;
            private SceneObjectDuration _dur;
            private float settedTime;

            public void OnInit() {
                _objT = GetObject(sword[0]).GetTransform();
                _objT.SetSize(131, 388);
                _objT.SetTranslation(0, -100);
                _objT.SetScale(4, 4);
                _objT.SetRotate(-1);
                _img = (SceneObjectImage)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_IMAGE);
                _img.GetColorInfo().SetColor(0, 0, 0, 255);
                _dur = (SceneObjectDuration)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Rotate Sword");
            }
            public boolean IsContinue() {
                return true;
            }
            public void OnUpdate() {
                float r = _objT.GetRotate();
                _objT.SetRotate(r + 2/(frameRate * settedTime));
                float x, y;
                x = _objT.GetScale().x - 3/(frameRate * settedTime);
                y = _objT.GetScale().y - 3/(frameRate * settedTime);
                _objT.SetScale(x, y);
            }
            public void OnEnd() {
                GetDrawBack().GetBackColorInfo().SetColor(0, 0, 0);
                _img.GetColorInfo().SetAlpha(1);
                _dur = (SceneObjectDuration)GetObject(gameOverBack).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Back Gradation", 1);
                _dur.Start("Back Gradation");

                _dur = (SceneObjectDuration)GetObject(gameOverLabel).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Down", 1.5);
                _dur.Start("Down");

                _dur = (SceneObjectDuration)GetObject(clickLabel).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Up", 1.5);
                _dur.Start("Up");

                SceneObject obj;
                for (int i=1; i<sword.length; i++) {
                    obj = GetObject(sword[i]);
                    _objT = obj.GetTransform();
                    _objT.SetSize(131, 388);
                    _img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
                    _img.GetColorInfo().SetAlpha(100);
                    switch(i) {
                    case 1:
                        _objT.SetTranslation(10, -10);
                        _objT.SetRotate(radians(10));
                        break;
                    case 2:
                        _objT.SetTranslation(-5, -10);
                        _objT.SetRotate(radians(-10));
                        break;
                    case 3:
                        _objT.SetTranslation(5, 10);
                        _objT.SetRotate(radians(18));
                        break;
                    case 4:
                        _objT.SetTranslation(-10, 0);
                        _objT.SetRotate(radians(-10));
                        break;
                    case 5:
                        _objT.SetTranslation(25, 15);
                        _objT.SetRotate(radians(8));
                        break;
                    case 6:
                        _objT.SetTranslation(-5, 40);
                        _objT.SetRotate(radians(-5));
                        break;
                    }
                }
            }
        }
        );

        // ゲームオーバーテキスト
        obj = new SceneObject(gameOverLabel, this);
        new SceneObjectImage(obj, "gameover/gameover.png");
        objT = obj.GetTransform();
        objT.SetPriority(8);
        objT.SetSize(547, 100);
        objT.SetAnchor(0.5, 0, 0.5, 0);
        objT.SetPivot(0.5, 0);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Down", new IDuration() {
            private SceneObjectTransform _objT;
            private DrawColor _draw;
            private SceneObjectDuration _dur;
            private float settedTime;
            public void OnInit() {
                SceneObject obj = GetObject(gameOverLabel);
                _objT = obj.GetTransform();
                _objT.SetTranslation(0, 50);
                _draw = ((SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Down");
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                if (settedTime <= 0) {
                    _objT.SetTranslation(0, 80);
                    _draw.SetColor(0, 155, 205, 255);
                } else {
                    PVector t = _objT.GetTranslation();
                    color c = _draw.GetColor();
                    float d = frameRate * settedTime;
                    _objT.SetTranslation(t.x, t.y + 30/d);
                    _draw.SetColor(red(c) - 255/d, green(c) - 100/d, blue(c) - 50/d, alpha(c) + 255/d);
                }
            }
            public void OnEnd() {
                _objT.SetTranslation(0, 80);
                _draw.SetAlpha(255);
                _dur.Start("Flash");
            }
        }
        );
        dur.SetUseTimer("Down", true);
        dur.GetDurations().Add("Flash", new IDuration() {
            private DrawColor _draw;
            private float _rad;
            public void OnInit() {
                _draw = ((SceneObjectImage)GetObject(clickLabel).GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _rad = 0;
            }
            public boolean IsContinue() {
                return true;
            }
            public void OnUpdate() {
                _draw.SetAlpha(100 * cos(_rad) + 155);
                _rad += PI/frameRate;
                _rad %= TWO_PI;
            }
            public void OnEnd() {
            }
        }
        );

        // クリックテキスト
        obj = new SceneObject(clickLabel, this);
        new SceneObjectImage(obj, "gameover/click.png");
        objT = obj.GetTransform();
        objT.SetPriority(8);
        objT.SetSize(327, 37);
        objT.SetAnchor(0.5, 1, 0.5, 1);
        objT.SetPivot(0.5, 1);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Up", new IDuration() {
            private SceneObjectTransform _objT;
            private DrawColor _draw;
            private SceneObjectDuration _dur;
            private float settedTime;
            public void OnInit() {
                SceneObject obj = GetObject(clickLabel);
                _objT = obj.GetTransform();
                _objT.SetTranslation(0, -70);
                _draw = ((SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Up");
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                if (settedTime <= 0) {
                    _objT.SetTranslation(0, -100);
                    _draw.SetColor(0, 155, 205, 255);
                } else {
                    PVector t = _objT.GetTranslation();
                    _objT.SetTranslation(t.x, t.y - 30/(frameRate * settedTime));
                    _draw.SetAlpha(_draw.GetAlpha() + 255/(frameRate * settedTime));
                }
            }
            public void OnEnd() {
                _objT.SetTranslation(0, -100);
                _draw.SetAlpha(255);
            }
        }
        );
        dur.SetUseTimer("Up", true);
    }

    public void OnEnabled() {
        super.OnEnabled();

        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);

        SceneObject obj;
        SceneObjectTransform objT;
        SceneObjectImage img;
        SceneObjectDuration dur;
        SceneObjectTimer timer;

        obj = GetObject(gameOverBack);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);

        obj = GetObject(adjustLayer);
        obj.GetDrawBack().GetBackColorInfo().SetAlpha(255);
        dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
        dur.ResetTimer("Clean Out", 1);
        dur.Start("Clean Out");

        for (int i=1; i<sword.length; i++) {
            obj = GetObject(sword[i]);
            objT = obj.GetTransform();
            objT.SetTranslation(0, 0);
            objT.SetSize(0, 0);
            img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
            img.GetColorInfo().SetAlpha(1);
        }

        obj = GetObject(sword[0]);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        timer = (SceneObjectTimer)obj.GetBehaviorOnID(ClassID.CID_TIMER);
        timer.ResetTimer("Fire Start Event", 1);
        timer.Start("Fire Start Event");

        obj = GetObject(gameOverLabel);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        img.GetColorInfo().SetColor(255, 255, 255);

        obj = GetObject(clickLabel);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        img.GetColorInfo().SetColor(255, 255, 255);
    }

    public void OnDisabled() {
        super.OnDisabled();
    }

    public void GoGameOver() {
        sceneManager.ReleaseAllScenes();
        sceneManager.LoadScene(SceneID.SID_GAMEOVER);
    }
}