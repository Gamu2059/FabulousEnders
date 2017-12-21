public final class SceneGameOver extends Scene {
    private String sceneBack;

    public SceneGameOver() {
        super(SceneID.SID_GAMEOVER);
        GetDrawBack().GetBackColorInfo().SetColor(0, 0, 0);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        sceneBack = "GameOverBack";

        SceneObject obj;
        SceneObjectButton btn;

        // クリックしたらタイトルに戻るボタン
        obj = new SceneObject("TitleBackButton", this);
        obj.GetTransform().SetPriority(10);
        btn = new SceneObjectButton(obj, "GameOver TitleBackButton");
        btn.GetDecideHandler().AddEvent("Go Title", new IEvent() {
            public void Event() {
                SceneTitle t = (SceneTitle)sceneManager.GetScene(SceneID.SID_TITLE);
                t.GoTitle();
            }
        }
        );

        // 背景
        obj = new SceneObject(sceneBack, this);
        new SceneObjectImage(obj, "gameover/back.png");
        SceneObjectDuration duration = new SceneObjectDuration(obj);
        duration.GetDurations().put("Back Gradation", new ADuration() {
            private SceneObject _obj;
            private SceneObjectTransform _objT;

            public void Start() {
                _isActive = true;
                if (!_isBeginning) {
                    _isBeginning = true;
                    OnInit();
                }
            }

            public void Update() {
                if (!_isActive || !_isBeginning) return;
                _timer -= 1/frameRate;
                if (!IsContinue()) {
                    End();
                    return;
                }
                OnUpdate();
            }

            public void OnInit() {
                _obj = GetObject(sceneBack);
                if (_obj == null) return;
                _objT = _obj.GetTransform();
                _objT.SetAnchor(0, 0, 1, 0);
                _objT.SetPivot(0.5, 0);
                _objT.SetSize(0, 0);
            }

            public boolean IsContinue() {
                return _objT.GetSize().y < height;
            }

            public void OnUpdate() {
                float y = _objT.GetSize().y;
                _objT.SetSize(0, y + height/(frameRate*3));
            }

            public void OnEnd() {
            }
        }
        );
    }

    public void OnEnabled() {
        super.OnEnabled();

        SceneObject obj;
        SceneObjectDuration dur;
        obj = GetObject(sceneBack);
        dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);

        dur.GetDurations().get("Back Gradation").Start();
    }

    public void OnDisabled() {
        super.OnDisabled();
    }

    public void GoGameOver() {
        sceneManager.ReleaseAllScenes();
        sceneManager.LoadScene(SceneID.SID_GAMEOVER);
    }
}