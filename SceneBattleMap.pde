/**
 戦闘マップ及びマップイベントを描画するシーン。
 */
public class FESceneBattleMap extends Scene {
    private JsonObject _mapData;

    private SceneObject _backObj;
    private SceneObjectImage _backImg;

    /**
     プレイヤーユニットオブジェクト
     */
    private ArrayList<SceneObject> _playerUnits;

    /**
     敵ユニットオブジェクト
     */
    private ArrayList<SceneObject> _enemyUnits;

    /**
     イベントオブジェクト
     */
    private ArrayList<FEMapObjectBase> _events;

    public FESceneBattleMap() {
        super(SceneID.SID_FE_BATTLE_MAP);

        _mapData = new JsonObject();

        _events = new ArrayList<FEMapObjectBase>();

        _backObj = new SceneObject("Back Image", this);
        _backImg = new SceneObjectImage(_backObj, null);
        SceneObjectTransform _objT = _backObj.GetTransform();
        _objT.SetAnchor(0, 0, 0, 0);
        _objT.SetPivot(0, 0);
    }

    /**
     マップデータを読み込み、現在のマップをリセットする。
     戦闘開始ではない。
     */
    public void LoadMap(String dataPath) {
        _mapData.Load(dataPath);

        // 背景設定
        _backImg.SetUsingImageName(_mapData.GetString("Back Image", null));

        // サイズ設定
        JsonObject pos = _mapData.GetJsonObject("Map Size");
        int x, y;
        x = pos.GetInt("x", -1);
        y = pos.GetInt("y", -1);
        SceneObjectTransform _objT = _backObj.GetTransform();
        _objT.SetSize(x * FEConst.SYSTEM_MAP_GRID_PX, y * FEConst.SYSTEM_MAP_GRID_PX);
        //_backScr.ReSetScroller();

        // イベントオブジェクト設定
        _events.clear();
        JsonArray eventArray = _mapData.GetJsonArray("Event Datas");
        if (eventArray == null) return;
        JsonObject event;
        for (int i=0; i<eventArray.Size(); i++) {
            event = eventArray.GetJsonObject(i);
            FEMapObjectBase obj = new FEMapObjectBase(event.GetString("Name", "No Name"), this, event);
            obj.GetTransform().SetParent(_backObj.GetTransform(), true);
        }
    }

    //private void _ResetSettedFlag(boolean[][] flags) {
    //    for (int i=0; i<flags.length; i++) {
    //        for (int j=0; j<flags[0].length; j++) {
    //            flags[i][j] = false;
    //        }
    //    }
    //}
}

/**
 マップ上に存在するオブジェクトのベースクラス。
 */
public class FEMapObjectBase extends SceneObject {
    private FEMapObjectData _data;
    public FEMapObjectData GetData() {
        return _data;
    }

    public FEMapObjectBase(String name, FESceneBattleMap scene, JsonObject json) {
        super(name, scene);

        SceneObjectTransform objT = GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        objT.SetSize(FEConst.SYSTEM_MAP_GRID_PX, FEConst.SYSTEM_MAP_GRID_PX);
        objT.SetTranslation(json.GetInt("x", 0) * FEConst.SYSTEM_MAP_GRID_PX, json.GetInt("y", 0) * FEConst.SYSTEM_MAP_GRID_PX);

        _data = new FEMapObjectData(this);
        FEMapObjectImage img = new FEMapObjectImage(this);

        img.SetBaseFolderPath(json.GetString("Image Folder Path", null));
        img.SetAnimation(json.GetBoolean("Is Animation", false));
        img.SetFixedDirection(json.GetBoolean("Is Fixed Direction", true));
    }
}



/**
 マップオブジェクトの基本情報を保持するコンポーネント。
 */
public class FEMapObjectData extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_DATA;
    }

    /**
     マップ上の座標
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }

    /**
     他のオブジェクトがすり抜けられるかどうか
     */
    private boolean _isSlipable;
    public boolean IsSlipable() {
        return _isSlipable;
    }
    public void SetSlipable(boolean value) {
        _isSlipable = value;
    }

    /**
     向き
     */
    private int _direction;
    public int GetDirection() {
        return _direction;
    }
    public void SetDirection(int value) {
        _direction = value;
    }

    public FEMapObjectData(FEMapObjectBase obj) {
        super();

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }
}

/**
 マップオブジェクトのアニメーションを司るコンポーネント。
 */
public class FEMapObjectImage extends SceneObjectImage {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_IMAGE;
    }

    /**
     イメージの保存されているフォルダのパス
     */
    private String _baseFolderPath;
    public String GetBaseFolderPath() {
        return _baseFolderPath;
    }
    public void SetBaseFolderPath(String value) {
        _baseFolderPath = value;
    }

    /**
     アニメーションさせるかどうか
     */
    private boolean _isAnimation;
    public boolean IsAnimation() {
        return _isAnimation;
    }
    public void SetAnimation(boolean value) {
        _isAnimation = value;
    }

    /**
     向きを固定するかどうか
     */
    private boolean _isFixedDirection;
    public boolean IsFixedDirection() {
        return _isFixedDirection;
    }
    public void SetFixedDirection(boolean value) {
        _isFixedDirection = value;
    }

    // タイマーコンポーネント
    SceneObjectTimer _timer;

    FEMapObjectBase _obj;

    private String _timerLabel;
    private int _index;

    public FEMapObjectImage(FEMapObjectBase obj) {
        super(obj, null);

        _obj = obj;

        _timer = new SceneObjectTimer(obj);
        _timerLabel = "FE Map Object Image Animation";
        _timer.GetTimers().Add(_timerLabel, new ITimer() {
            public void OnInit() {
                _index = (_index + 1) % 4;
                int id = _index % 2 == 0 ? _index : 1;
                if (_baseFolderPath == null) return;
                String dir;
                switch(_obj.GetData().GetDirection()) {
                case FEConst.MAP_OBJ_DIR_UP:
                    dir = "U";
                    break;
                case FEConst.MAP_OBJ_DIR_RIGHT:
                    dir = "R";
                    break;
                case FEConst.MAP_OBJ_DIR_DOWN:
                    dir = "D";
                    break;
                case FEConst.MAP_OBJ_DIR_LEFT:
                    dir = "L";
                    break;
                default:
                    dir = "N";
                    break;
                }
                SetUsingImageName(_baseFolderPath + "/" + dir + id + ".png");
            }

            public void OnTimeOut() {
                if (!_isAnimation) return;
                _timer.ResetTimer(_timerLabel, 0.5);
                _timer.Start(_timerLabel);
            }
        }
        );
    }

    public void Start() {
        super.Start();
        _timer.ResetTimer(_timerLabel, 0.5);
        _timer.Start(_timerLabel);
    }
}