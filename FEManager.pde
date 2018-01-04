public class FEManager {
    /**
     環境コンフィグ
     全てのデータで共通のため、別枠保持
     */
    private FEConfig _config;
    public FEConfig GetConfig() {
        return _config;
    }

    private FEDataBase _dataBase;
    public FEDataBase GetDataBase() {
        return _dataBase;
    }

    private FEProgressDataBase _progressDataBase;
    public FEProgressDataBase GetProgressDataBase() {
        return _progressDataBase;
    }

    public FEManager() {
        _config = new FEConfig();
        _dataBase = new FEDataBase();
        _progressDataBase = new FEProgressDataBase();

        _config.Load("data/config/config.json");
        _dataBase.Load("data/database");
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
 プレイヤーユニット、クラス、武器、アイテム、スキル、ステート、地形効果、武器クラスなど、
 ゲーム内で使用されるデータの原本を保持するクラス。
 原本であって、進行中のゲームのデータを保持するものではないことに注意。
 */
public class FEDataBase {
    private ArrayList<FEWeaponClass> _weaponClasses;
    public ArrayList<FEWeaponClass> GetWeaponClasses() {
        return _weaponClasses;
    }

    private ArrayList<FETerrainEffect> _terrainEffects;
    public ArrayList<FETerrainEffect> GetTerrainEffects() {
        return _terrainEffects;
    }

    private ArrayList<FEState> _states;
    public ArrayList<FEState> GetStates() {
        return _states;
    }

    private ArrayList<FEUnitSkill> _skills;
    public ArrayList<FEUnitSkill> GetSkills() {
        return _skills;
    }

    private ArrayList<FEItem> _items;
    public ArrayList<FEItem> GetItems() {
        return _items;
    }

    private ArrayList<FEWeapon> _weapons;
    public ArrayList<FEWeapon> GetWeapons() {
        return _weapons;
    }

    private ArrayList<FEUnitClass> _unitClasses;
    public ArrayList<FEUnitClass> GetUnitClasses() {
        return _unitClasses;
    }

    private ArrayList<FEUnitBase> _playerUnits;
    public ArrayList<FEUnitBase> GetPlayerUnits() {
        return _playerUnits;
    }

    public FEDataBase() {
        _weaponClasses = new ArrayList<FEWeaponClass>();
        _terrainEffects = new ArrayList<FETerrainEffect>();
        _states = new ArrayList<FEState>();
        _skills = new ArrayList<FEUnitSkill>();
        _items = new ArrayList<FEItem>();
        _weapons = new ArrayList<FEWeapon>();
        _unitClasses = new ArrayList<FEUnitClass>();
        _playerUnits = new ArrayList<FEUnitBase>();
    }

    public void Load(String dataBaseFolderPath) {
        JsonArray jsonArray = new JsonArray();
        JsonObject json = new JsonObject();

        jsonArray.Load(dataBaseFolderPath + "/unit.json");
        FEUnitBase unit;
        for (int i=0; i<jsonArray.Size(); i++) {
            json = jsonArray.GetJsonObject(i);
            unit = new FEUnitBase();
            feJsonUtility.LoadPlayerUnit(unit, json);
            _playerUnits.add(unit);
        }
    }
}

/**
 仲間になったユニット、アイテムリスト、所持金など、
 ゲーム内で実際に使用されるデータを保持するクラス。
 */
public class FEProgressDataBase {
    //////////////////////////////////////////////////////
    // 全体(グローバル)の進捗データ
    //////////////////////////////////////////////////////
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
     */
    private ArrayList<FEUnitBase> _playerUnits;
    public ArrayList<FEUnitBase> GetPlayerUnits() {
        return _playerUnits;
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

    //////////////////////////////////////////////////////
    // マップ(ローカル)の進捗データ
    //////////////////////////////////////////////////////
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
     出撃しているユニットのリスト
     */
    private ArrayList<FEUnitBase> _sortableUnits;
    public ArrayList<FEUnitBase> GetSortableUnits() {
        return _sortableUnits;
    }

    /**
     現在のマップで敵対しているユニットのリスト
     */
    private ArrayList<FEOtherUnit> _enemyUnits;
    public ArrayList<FEOtherUnit> GetEnemyUnits() {
        return _enemyUnits;
    }

    /**
     現在のマップの地形情報
     */
    private ArrayList<ArrayList<FETerrain>> _terrains;
    public ArrayList<ArrayList<FETerrain>> GetTerrains() {
        return _terrains;
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

    public FEProgressDataBase() {
        _money = 0;
        _items = new ArrayList<FEItemBase>();
        _playerUnits = new ArrayList<FEUnitBase>();
        _globalVariables = new PHash<Integer>();
        _globalSwitches = new PHash<Boolean>();

        _elapsedTurn = 0;
        _sortableUnits = new ArrayList<FEUnitBase>();
        _enemyUnits = new ArrayList<FEOtherUnit>();
        _terrains = new ArrayList<ArrayList<FETerrain>>();
    }

    public void Load(String dataBaseFolderPath) {
    }
}

public class FEJsonUtility {
    public void LoadUnitParameter(FEUnitParameter prm, JsonObject json) {
        if (prm == null || json == null) return;
        prm.SetHp(json.GetInt("HP", -1));
        prm.SetMAttack(json.GetInt("MAT", -1));
        prm.SetAttack(json.GetInt("ATK", -1));
        prm.SetTech(json.GetInt("TEC", -1));
        prm.SetSpeed(json.GetInt("SPD", -1));
        prm.SetLucky(json.GetInt("LUC", -1));
        prm.SetDefense(json.GetInt("DEF", -1));
        prm.SetMDefense(json.GetInt("MDF", -1));
        prm.SetMobility(json.GetInt("MOV", -1));
        prm.SetProficiency(json.GetInt("PRO", -1));
    }

    public void LoadPlayerUnit(FEUnitBase unit, JsonObject json) {
        if (unit == null || json == null) return;
        unit.SetName(json.GetString("Name", "No Data"));
        unit.SetExplain(json.GetString("Explain", "No Data"));
        unit.SetOrganization(json.GetString("Organization", "No Data"));
        unit.SetFaceImagePath(json.GetString("Face Image Path", null));
        unit.SetMapImageFolderPath(json.GetString("Map Image Folder Path", null));
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
        unit.SetLevel(json.GetInt("Level", -1));
        LoadUnitParameter(unit.GetGrowthRate(), json.GetJsonObject("Growth Correct"));
        LoadUnitParameter(unit.GetParameter(), json.GetJsonObject("Parameter Correct"));
    }
}