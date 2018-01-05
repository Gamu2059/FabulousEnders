public class FEManager {
    /**
     環境コンフィグ
     全てのデータで共通のため、別枠保持
     */
    private FEConfig config;
    public FEConfig GetConfig() {
        return config;
    }

    /**
     ゲームで使用するデータの原本を保持する
     */
    private FEDataBase dataBase;
    public FEDataBase GetDataBase() {
        return dataBase;
    }

    /**
     ゲームの全体的な進行状況を管理する
     */
    private FEProgressManager progressManager;
    public FEProgressManager GetProgressDataBase() {
        return progressManager;
    }

    /**
     ゲームの戦闘マップに関することを管理する
     */
    private FEBattleMapManager battleMapManager;
    public FEBattleMapManager GetBattleMapManager() {
        return battleMapManager;
    }

    public FEManager() {
        config = new FEConfig();
        dataBase = new FEDataBase();
        progressManager = new FEProgressManager();
        battleMapManager = new FEBattleMapManager();

        config.Load("data/config/config.json");
        dataBase.Load("data/database");
    }

    /**
     ゲームを最初からプレイする。
     */
    public void StartGame() {
        try {
            String path = "data/database/start.json";
            progressManager.LoadSavingData(path);
            battleMapManager.LoadSavingData(path);
        } 
        catch(Exception e) {
            println(111);
        }
    }

    /**
     ゲームを続きからプレイする。
     */
    public void ContinueGame() {
        // ロードシーンを開く
    }

    /**
     環境コンフィグを設定する。
     */
    public void SetConfig() {
        // 環境設定シーンを開く
    }
}

/**
 ゲーム内で設定を変更することができるコンフィグパラメータを保持するクラス。
 */
public class FEConfig {
    // グリッドカーソルを移動させる速さ
    private int _gridSpeed;
    public int GetGridSpeed() {
        return _gridSpeed;
    }
    public void SetGridSpeed(int value) {
        _gridSpeed = value;
    }
    public void AddGridSpeed(int value) {
        _gridSpeed += value;
    }

    // メッセージウィンドウに表示させる文章の表示の速さ
    private int _messageSpeed;
    public int GetMessageSpeed() {
        return _messageSpeed;
    }
    public void SetMessageSpeed(int value) {
        _messageSpeed = value;
    }
    public void AddMessageSpeed(int value) {
        _messageSpeed += value;
    }

    public void Load(String path) {
        JsonObject json = new JsonObject();
        json.Load(path);

        _gridSpeed = json.GetInt("Grid Speed", -1);
        _messageSpeed = json.GetInt("Message Speed", -1);
    }
}

/**
 プレイヤーユニット、クラス、武器、アイテム、スキル、ステート、地形効果、武器クラスなど、ゲーム内で使用されるデータの原本を保持するクラス。
 原本であって、進行中のゲームのデータを保持するものではない。
 */
public class FEDataBase {
    private HashMap<Integer, FEWeaponClass> _weaponClasses;
    public HashMap<Integer, FEWeaponClass> GetWeaponClasses() {
        return _weaponClasses;
    }

    private HashMap<Integer, FETerrainEffect> _terrainEffects;
    public HashMap<Integer, FETerrainEffect> GetTerrainEffects() {
        return _terrainEffects;
    }

    private HashMap<Integer, FEState> _states;
    public HashMap<Integer, FEState> GetStates() {
        return _states;
    }

    private HashMap<Integer, FESkill> _skills;
    public HashMap<Integer, FESkill> GetSkills() {
        return _skills;
    }

    private HashMap<Integer, FEItem> _items;
    public HashMap<Integer, FEItem> GetItems() {
        return _items;
    }

    private HashMap<Integer, FEWeapon> _weapons;
    public HashMap<Integer, FEWeapon> GetWeapons() {
        return _weapons;
    }

    private HashMap<Integer, FEClass> _unitClasses;
    public HashMap<Integer, FEClass> GetUnitClasses() {
        return _unitClasses;
    }

    private HashMap<Integer, FEUnit> _playerUnits;
    public HashMap<Integer, FEUnit> GetPlayerUnits() {
        return _playerUnits;
    }

    public FEDataBase() {
        _weaponClasses = new HashMap<Integer, FEWeaponClass>();
        _terrainEffects = new HashMap<Integer, FETerrainEffect>();
        _states = new HashMap<Integer, FEState>();
        _skills = new HashMap<Integer, FESkill>();
        _items = new HashMap<Integer, FEItem>();
        _weapons = new HashMap<Integer, FEWeapon>();
        _unitClasses = new HashMap<Integer, FEClass>();
        _playerUnits = new HashMap<Integer, FEUnit>();
    }

    public void Load(String dataBaseFolderPath) {
        JsonArray jsonArray = new JsonArray();
        JsonObject json = new JsonObject();

        jsonArray.Load(dataBaseFolderPath + "/unit.json");
        FEUnit unit;
        for (int i=0; i<jsonArray.Size(); i++) {
            json = jsonArray.GetJsonObject(i);
            unit = new FEUnit();
            feJsonUtility.LoadUnit(unit, json);
            _playerUnits.put(unit.GetID(), unit);
        }
    }
}

/**
 仲間になったユニット、アイテムリスト、所持金など、ゲーム内で全体的に使用されるデータを保持するマネージャ。
 */
public class FEProgressManager {
    /**
     所持金
     */
    private int _money;
    public int GetMoney() {
        return _money;
    }
    public void SetMoney(int value) {
        _money = value;
    }
    public void AddMoney(int value) {
        _money += value;
    }

    /**
     アイテム、武器を問わないリスト
     */
    private ArrayList<FEItemBase> _items;
    public ArrayList<FEItemBase> GetItems() {
        return _items;
    }

    /**
     仲間になったユニットのリスト
     原本を複製して保持
     */
    private ArrayList<FEUnit> _playerUnits;
    public ArrayList<FEUnit> GetPlayerUnits() {
        return _playerUnits;
    }
    public FEUnit GetPlayerUnitOnID(int id) {
        if (_playerUnits == null) return null;
        for (int i=0; i<_playerUnits.size(); i++) {
            if (_playerUnits.get(i).GetID() == id) {
                return _playerUnits.get(i);
            }
        }
        return null;
    }

    /**
     グローバル変数
     */
    private PHash<Integer> _globalVariables;
    public PHash<Integer> GetGlobalVariables() {
        return _globalVariables;
    }

    /**
     グローバルスイッチ
     */
    private PHash<Boolean> _globalSwitches;
    public PHash<Boolean> GetGlobalSwitches() {
        return _globalSwitches;
    }

    public FEProgressManager() {
        _money = 0;
        _items = new ArrayList<FEItemBase>();
        _playerUnits = new ArrayList<FEUnit>();
        _globalVariables = new PHash<Integer>();
        _globalSwitches = new PHash<Boolean>();
    }

    public void LoadSavingData(String dataPath) throws Exception {
        JsonObject json = new JsonObject();
        json.LoadWithThrowException(dataPath);

        // money
        int money = json.GetInt("Money", -1);
        if (money >= 0) {
            _money = money;
        }

        // player units
        JsonArray units = json.GetJsonArray("Player Units");
        JsonObject unit;
        if (units != null) {
            FEUnit playerUnit, copyBase;
            for (int i=0; i<units.Size(); i++) {
                unit = units.GetJsonObject(i);
                playerUnit = new FEUnit();
                copyBase = feManager.GetDataBase().GetPlayerUnits().get(unit.GetInt("ID", -99999));
                if (copyBase == null) continue;
                copyBase.CopyTo(playerUnit);
                feJsonUtility.LoadUnit(playerUnit, unit);
                _playerUnits.add(playerUnit);
            }
        }
    }
}

/**
 戦闘マップに関するデータと処理を管理するマネージャ。
 */
public class FEBattleMapManager {
    private String _mapName;
    public String GetMapName() {
        return _mapName;
    }

    private String _mapImagePath;
    public String GetMapImagePath() {
        return _mapImagePath;
    }

    private PVector _mapSize;
    public PVector GetMapSize() {
        return _mapSize;
    }

    /**
     経過ターン
     */
    private int _elapsedTurn;
    public int GetElapsedTurn() {
        return _elapsedTurn;
    }
    public void SetElapsedTurn(int value) {
        _elapsedTurn = value;
    }
    public void AddElapsedTurn(int value) {
        _elapsedTurn += value;
    }

    /**
     出撃可能人数
     */
    private int _sortableUnitNum;
    public int GetSortableUnitNum() {
        return _sortableUnitNum;
    }

    /**
     現在の出撃しているプレイヤーユニットのリスト
     playerUnitsの要素を参照保持
     */
    private ArrayList<FEUnit> _sortieUnits;
    public ArrayList<FEUnit> GetSortieUnits() {
        return _sortieUnits;
    }

    /**
     エネミーユニットのリスト
     データの原本であることに注意
     */
    private HashMap<Integer, FEOtherUnit> _enemyUnits;
    public HashMap<Integer, FEOtherUnit> GetEnemyUnits() {
        return _enemyUnits;
    }

    /**
     現在の出撃しているエネミーユニットのリスト
     enemyUnitsの要素を複製保持
     */
    private ArrayList<FEOtherUnit> _sortieEnemyUnits;
    public ArrayList<FEOtherUnit> GetSortieEnemyUnits() {
        return _sortieEnemyUnits;
    } 

    /**
     現在のマップに存在するイベントのリスト
     イベントは一意のため原本保持はしない
     */
    private ArrayList<FEMapObject> _events;
    public ArrayList<FEMapObject> GetEvents() {
        return _events;
    }

    /**
     現在のマップの地形情報
     */
    private FETerrain[][] _terrains;
    public FETerrain[][] GetTerrains() {
        return _terrains;
    }

    /**
     危険領域
     */
    private int[][] _hazardAreas;
    public int[][] GetHazardAreas() {
        return _hazardAreas;
    }

    /**
     行動範囲
     */
    /***/
    private int[][] _actionRanges;
    public int[][] GetActionRanges() {
        return _actionRanges;
    }

    /**
     マップ上にいるユニットやイベントの存在情報
     */
    private ArrayList<FEMapElement> _mapElements;
    public ArrayList<FEMapElement> GetMapElements() {
        return _mapElements;
    }

    /**
     ローカル変数
     */
    private PHash<Integer> _localVariables;
    public PHash<Integer> GetLocalVariables() {
        return _localVariables;
    }

    /**
     ローカルスイッチ
     */
    private PHash<Boolean> _localSwitches;
    public PHash<Boolean> GetLocalSwitches() {
        return _localSwitches;
    }

    public FEBattleMapManager() {
        _mapSize = new PVector();

        _elapsedTurn = 0;
        _sortieUnits = new ArrayList<FEUnit>();
        _enemyUnits = new HashMap<Integer, FEOtherUnit>();
        _sortieEnemyUnits = new ArrayList<FEOtherUnit>();
        _events = new ArrayList<FEMapObject>();
        _terrains = new FETerrain[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _hazardAreas = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _actionRanges = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _mapElements = new ArrayList<FEMapElement>();
        _localVariables = new PHash<Integer>();
        _localSwitches = new PHash<Boolean>();
    }

    /**
     マップを読み込み、マップ情報をリセットする
     */
    public void LoadMapData(String mapDataPath) {
        String path = FEConst.MAP_PATH + mapDataPath;
        try {
            JsonObject json = new JsonObject();
            json.LoadWithThrowException(path);

            _mapName = json.GetString("Name", "No Data");
            _mapImagePath = json.GetString("Image Path", null);
            _mapSize.x = json.GetInt("Width", -1);
            _mapSize.y = json.GetInt("Height", -1);

            JsonArray playerPositions = json.GetJsonArray("Player Positions");
            if (playerPositions != null) {
                JsonObject playerPosition;
                int id;
                _sortableUnitNum = playerPositions.Size();
                _mapElements.clear();
                for (int i=0; i<_sortableUnitNum; i++) {
                    playerPosition = playerPositions.GetJsonObject(i);
                    FEMapElement elem = new FEMapElement();
                    elem.GetPosition().x = playerPosition.GetInt("x", -1);
                    elem.GetPosition().y = playerPosition.GetInt("y", -1);
                    id = playerPosition.GetInt("ID", -99999);
                    if (id != -99999) {
                        elem.SetMapObject(feManager.GetProgressDataBase().GetPlayerUnitOnID(id));
                    }
                    _mapElements.add(elem);
                }
            }
        } 
        catch(Exception e) {
            println(e);
            dialog.Show("データの読込に失敗", "マップデータの読込に失敗しました。\npath = " + path);
        }
    }

    /**
     セーブされた情報を読み込み、マップ情報をリセットする
     ただし、マップに関する情報が保存されていない場合は何もしない。
     */
    public void LoadSavingData(String dataPath) {
    }

    /**
     マップ座標から、そこに存在するマップエレメントを返す。
     */
    public FEMapElement GetMapElementOnPos(int x, int y) {
        for (int i=0; i<_mapElements.size(); i++) {
            if (_mapElements.get(i).IsSamePosition(x, y)) {
                return _mapElements.get(i);
            }
        }
        return null;
    }
}

public class FEJsonUtility {
    public void LoadUnitParameter(FEUnitParameter prm, JsonObject json) {
        if (prm == null || json == null) return;
        int value;

        value = json.GetInt("HP", -1);
        if (value >= 1) {
            prm.SetHp(value);
        }
        value = json.GetInt("MAT", -1);
        if (value >= 0) {
            prm.SetMAttack(json.GetInt("MAT", -1));
        }
        value = json.GetInt("ATK", -1);
        if (value > 0) {
            prm.SetAttack(json.GetInt("ATK", -1));
        }
        value = json.GetInt("TEC", -1);
        if (value > 0) {
            prm.SetTech(json.GetInt("TEC", -1));
        }
        value = json.GetInt("SPD", -1);
        if (value > 0) {
            prm.SetSpeed(json.GetInt("SPD", -1));
        }
        value = json.GetInt("LUC", -1);
        if (value > 0) {
            prm.SetLucky(json.GetInt("LUC", -1));
        }
        value = json.GetInt("DEF", -1);
        if (value > 0) {
            prm.SetDefense(json.GetInt("DEF", -1));
        }
        value = json.GetInt("MDF", -1);
        if (value > 0) {
            prm.SetMDefense(json.GetInt("MDF", -1));
        }
        value = json.GetInt("MOV", -1);
        if (value > 0) {
            prm.SetMobility(json.GetInt("MOV", -1));
        }
        value = json.GetInt("PRO", -1);
        if (value > 0) {
            prm.SetProficiency(json.GetInt("PRO", -1));
        }
    }

    public void LoadUnit(FEUnit unit, JsonObject json) {
        if (unit == null || json == null) return;

        String value;
        value = json.GetString("Name", null);
        if (value != null) {
            unit.SetName(value);
        }
        int id = json.GetInt("ID", -99999);
        unit.SetID(id);
        value = json.GetString("Explain", null);
        if (value != null) {
            unit.SetExplain(value);
        }
        value = json.GetString("Organization", null);
        if (value != null) {
            unit.SetOrganization(value);
        }
        value = json.GetString("Face Image Path", null);
        if (value != null) {
            unit.SetFaceImagePath(value);
        }
        value = json.GetString("Map Image Folder Path", null);
        if (value != null) {
            unit.SetMapImageFolderPath(value);
        }
        switch(json.GetString("Importance", "NORMAL")) {
        case "LEADER":
            unit.SetImportance(FEConst.UNIT_IMPORTANCE_LEADER);
            break;
        case "SUB LEADER":
            unit.SetImportance(FEConst.UNIT_IMPORTANCE_SUB_LEADER);
            break;
        default:
            unit.SetImportance(FEConst.UNIT_IMPORTANCE_NORMAL);
            break;
        }
        //unit.SetUnitClass();

        int level = json.GetInt("Level", -1);
        if (level >= 1) {
            unit.SetLevel(level);
        }

        LoadUnitParameter(unit.GetBaseGrowthRate(), json.GetJsonObject("Growth Correct"));
        LoadUnitParameter(unit.GetParameter(), json.GetJsonObject("Parameter Correct"));
    }
}