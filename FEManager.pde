public class FEManager { //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
    }

    public void Init() {
        config.Load(FEConst.CONFIG_PATH + "config.json");
        dataBase.Load(FEConst.DATABASE_PATH);
    }

    /**
     ゲームを最初からプレイする。
     */
    public void StartGame() {
        try {
            String path = FEConst.DATABASE_PATH + "start.json";
            progressManager.LoadSavingData(path);
            //battleMapManager.LoadSavingData(path);
        } 
        catch(Exception e) {
            println(e);
            dialog.Show("エラー", "ゲームデータのロードに失敗しました。");
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

    public void Update() {
        battleMapManager.Update();
    }
}

/**
 ゲーム内で設定を変更することができるコンフィグパラメータを保持するクラス。
 */
public class FEConfig {
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

    /**
     マップ上のユニットが移動する時に、1マス移動するのに掛かる時間
     */
    private float _unitMoveTime;
    public float GetUnitMoveTime() {
        return _unitMoveTime;
    }
    public void SetUnitMoveTime(float value) {
        _unitMoveTime = value;
    }
    public void AddUnitMoveTime(float value) {
        _unitMoveTime += value;
    }

    public void Load(String path) {
        JsonObject json = new JsonObject();
        json.Load(path);

        _messageSpeed = json.GetInt("Message Speed", -1);
        _unitMoveTime = json.GetFloat("Unit Move Time", 0.1);
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

    private HashMap<Integer, FETerrain> _terrains;
    public HashMap<Integer, FETerrain> GetTerrains() {
        return _terrains;
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
        _terrains = new HashMap<Integer, FETerrain>();
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
        String path;

        // タイル効果
        path = dataBaseFolderPath + "terrain_effect.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FETerrainEffect effect;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                effect = new FETerrainEffect();
                feJsonUtility.LoadTerrainEffect(effect, json);
                _terrainEffects.put(effect.GetID(), effect);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "タイル効果データの読込に失敗しました。\npath = " + path);
        }

        // タイル
        path = dataBaseFolderPath + "terrain.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FETerrain terrain;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                terrain = new FETerrain();
                feJsonUtility.LoadTerrain(terrain, json);
                _terrains.put(terrain.GetID(), terrain);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "タイルデータの読込に失敗しました。\npath = " + path);
        }

        // 武器クラス
        path = dataBaseFolderPath + "weapon_class.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEWeaponClass weaponClass;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                weaponClass = new FEWeaponClass();
                feJsonUtility.LoadWeaponClass(weaponClass, json);
                _weaponClasses.put(weaponClass.GetID(), weaponClass);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "武器クラスデータの読込に失敗しました。\npath = " + path);
        }

        // ステート
        path = dataBaseFolderPath + "state.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEState state;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                state = new FEState();
                feJsonUtility.LoadState(state, json);
                _states.put(state.GetID(), state);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "ステートデータの読込に失敗しました。\npath = " + path);
        }

        // スキル
        path = dataBaseFolderPath + "skill.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FESkill skill;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                skill = new FESkill();
                feJsonUtility.LoadSkill(skill, json);
                _skills.put(skill.GetID(), skill);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "スキルデータの読込に失敗しました。\npath = " + path);
        }

        // アイテム
        path = dataBaseFolderPath + "item.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEItem item;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                item = new FEItem();
                feJsonUtility.LoadItem(item, json);
                _items.put(item.GetID(), item);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "アイテムデータの読込に失敗しました。\npath = " + path);
        }

        // 武器
        path = dataBaseFolderPath + "weapon.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEWeapon weapon;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                weapon = new FEWeapon();
                feJsonUtility.LoadWeapon(weapon, json);
                _weapons.put(weapon.GetID(), weapon);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "武器データの読込に失敗しました。\npath = " + path);
        }

        // クラス
        path = dataBaseFolderPath + "class.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEClass unitClass;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                unitClass = new FEClass();
                feJsonUtility.LoadClass(unitClass, json);
                _unitClasses.put(unitClass.GetID(), unitClass);
            }
        } 
        catch(Exception e) {
            dialog.Show("致命的なエラー", "クラスデータの読込に失敗しました。\npath = " + path);
        }

        // プレイヤーユニット
        path = dataBaseFolderPath + "unit.json";
        try {
            jsonArray.LoadWithThrowException(path);
            FEUnit unit;
            for (int i=0; i<jsonArray.Size(); i++) {
                json = jsonArray.GetJsonObject(i);
                unit = new FEUnit();
                feJsonUtility.LoadUnit(unit, json);
                _playerUnits.put(unit.GetID(), unit);
            }
        } 
        catch(Exception e) {
            println(e);
            dialog.Show("致命的なエラー", "ユニットデータの読込に失敗しました。\npath = " + path);
        }
    }

    /**
     新しく持ち物を生成する。
     isItemがfalseの場合は武器を生成する。
     idが不正である場合はnullを返す。
     */
    public FEActualItem CreateItem(int id, boolean isItem) {
        if (isItem) {
            FEItem item = GetItems().get(id);
            if (item == null) return null;
            return new FEActualItem(item, isItem);
        } else {
            FEWeapon weapon = GetWeapons().get(id);
            if (weapon == null) return null;
            return new FEActualItem(weapon, isItem);
        }
    }

    /**
     新しくステートを生成する。
     idが不正である場合はnullを返す。
     */
    public FEActualState CreateState(int id) {
        FEState state = feManager.GetDataBase().GetStates().get(id);
        if (state == null) return null;
        return new FEActualState(state);
    }
}

/**
 仲間になったユニット、アイテムリスト、所持金など、ゲーム内で全体的に使用されるデータを保持するマネージャ。
 */
public class FEProgressManager {
    private int _difficulty;
    public int GetDifficulty() {
        return _difficulty;
    }

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

    /**
     場面の状態
     拠点にいるか、出撃しているか、など
     */
    private int _sceneMode;
    public int GetSceneMode() {
        return _sceneMode;
    }
    public void SetSceneMoce(int value) {
        _sceneMode = value;
    }

    public FEProgressManager() {
        _money = 0;
        _items = new ArrayList<FEItemBase>();
        _playerUnits = new ArrayList<FEUnit>();
        _globalVariables = new PHash<Integer>();
        _globalSwitches = new PHash<Boolean>();
    }

    /**
     セーブデータから情報を完全にロードする。
     */
    public void LoadSavingData(String dataPath) throws Exception {
        JsonObject json = new JsonObject();
        json.LoadWithThrowException(dataPath);

        // お金
        _money = json.GetInt("Money", -1);

        // プレイヤーユニット
        JsonArray units = json.GetJsonArray("Player Units");
        if (units != null) {
            JsonObject unit;
            FEUnit playerUnit, copyBase;
            for (int i=0; i<units.Size(); i++) {
                unit = units.GetJsonObject(i);
                if (unit == null) continue;
                playerUnit = new FEUnit();
                copyBase = feManager.GetDataBase().GetPlayerUnits().get(unit.GetInt("ID", FEConst.NOT_FOUND));
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
    //////////////////////////////////////////////////////
    // マップ基本情報
    //////////////////////////////////////////////////////
    private String _mapName;
    public String GetMapName() {
        return _mapName;
    }
    private String _mapImagePath;
    public String GetMapImagePath() {
        return _mapImagePath;
    }
    private int _mapWidth;
    public int GetMapWidth() {
        return _mapWidth;
    }
    private int _mapHeight;
    public int GetMapHeight() {
        return _mapHeight;
    }

    //////////////////////////////////////////////////////
    // 出撃フラグ情報
    //////////////////////////////////////////////////////
    // マップデータを読み込んだ直後に出撃準備を開始するかどうか
    private boolean _isImmediatelySortie;
    public boolean IsImmediatelySortie() {
        return _isImmediatelySortie;
    }
    // 出撃準備を飛ばすかどうか     
    private boolean _isSkipPreparation;
    public boolean IsSkipPreparation() {
        return _isSkipPreparation;
    }
    // プレイヤーが先攻かどうか     
    private boolean _isFirstPhase;
    public boolean IsFirstPhase() {
        return _isFirstPhase;
    }

    //////////////////////////////////////////////////////
    // モード制御用
    //////////////////////////////////////////////////////
    /**
     現在の出撃状態。
     通常、出撃準備中、出撃中など
     */
    private int _sortieMode;
    public int GetSortieMode() {
        return _sortieMode;
    }
    /**
     現在の操作状態。
     通常、選択中、移動中、戦闘中など
     */
    private int _operationMode;
    public int GetOperationMode() {
        return _operationMode;
    }

    //////////////////////////////////////////////////////
    // 戦闘全体情報
    //////////////////////////////////////////////////////
    // 経過ターン
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
    // プレイヤーユニット側の出撃可能人数     
    private int _sortableUnitNum;
    public int GetSortableUnitNum() {
        return _sortableUnitNum;
    }
    private FETerrain[][] _terrains;
    public FETerrain[][] GetTerrains() {
        return _terrains;
    }
    /** 
     行動フェーズ
     プレイヤーユニットの番の場合はtrue、敵ユニットの番の場合はfalse
     */
    private boolean _actionPhase;
    public boolean GetActionPhase() {
        return _actionPhase;
    }

    //////////////////////////////////////////////////////
    // 制御用バッファ情報
    //////////////////////////////////////////////////////
    // 現在カーソルで重ねられているマップエレメント     
    private FEMapElement _overlappedElement;
    public FEMapElement GetOverlappedElement() {
        return _overlappedElement;
    }
    // 現在カーソルで重ねられているユニット     
    private FEUnit _overlappedUnit;
    public FEUnit GetOverlappedUnit() {
        return _overlappedUnit;
    }
    // 現在選択中のマップエレメント     
    private FEMapElement _selectedElement;
    public FEMapElement GetSelectedElement() {
        return _selectedElement;
    }
    // 現在選択中のユニット     
    private FEUnit _selectedUnit;
    public FEUnit GetSelectedUnit() {
        return _selectedUnit;
    }
    // 選択中のユニットの移動ルート     
    private ArrayList<PVector> _unitRoute;
    public ArrayList<PVector> GetUnitRoute() {
        return _unitRoute;
    }
    // 移動しているユニットの元の座標     
    private PVector _basePosOfMovingUnit;
    public PVector GetBasePosOfMovingUnit() {
        return _basePosOfMovingUnit;
    }

    //////////////////////////////////////////////////////
    // 戦闘用情報
    //////////////////////////////////////////////////////
    private FEMapElement _attackerElement;
    public FEMapElement GetAttackerElement() {
        return _attackerElement;
    }
    private FEMapElement _defenderElement;
    public FEMapElement GetDefenderElement() {
        return _defenderElement;
    }
    private boolean _battlePhase;
    public boolean GetBattlePhase() {
        return _battlePhase;
    }
    public void SetBattlePhase(boolean value) {
        _battlePhase = value;
    }
    private int _attackerAttackNum;
    public int GetAttackerAttackNum() {
        return _attackerAttackNum;
    }
    private int _defenderAttackNum;
    public int GetDefenderAttackNum() {
        return _defenderAttackNum;
    }
    private int _remainAttackerChance;
    public int GetRemainAttackerChance() {
        return _remainAttackerChance;
    }
    private int _remainDefenderChance;
    public int GetRemainDefenderChance() {
        return _remainDefenderChance;
    }
    private FEUnitBattleConsider _attackerValue;
    public FEUnitBattleConsider GetAttackerValue() {
        return _attackerValue;
    }
    private FEUnitBattleConsider _defenderValue;
    public FEUnitBattleConsider GetDefenderValue() {
        return _defenderValue;
    }
    private FEUnitBattleConsider _battleResult;
    public FEUnitBattleConsider GetBattleResult() {
        return _battleResult;
    }

    //////////////////////////////////////////////////////
    // 出撃ユニット及びイベント情報
    //////////////////////////////////////////////////////
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
     データの原本であるため、要素の変更はしてはならない
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

    //////////////////////////////////////////////////////
    // 特定描画領域情報
    //////////////////////////////////////////////////////
    private int[][] _hazardAreas;
    public int[][] GetHazardAreas() {
        return _hazardAreas;
    }
    private int[][] _actionRanges;
    public int[][] GetActionRanges() {
        return _actionRanges;
    }

    //////////////////////////////////////////////////////
    // マップ上のオブジェクト情報
    //////////////////////////////////////////////////////
    private ArrayList<FEMapElement> _mapPlayerObjects;
    public ArrayList<FEMapElement> GetMapPlayerObjects() {
        return _mapPlayerObjects;
    }
    private ArrayList<FEMapElement> _mapEnemyObjects;
    public ArrayList<FEMapElement> GetMapEnemyObjects() {
        return _mapEnemyObjects;
    } 
    private ArrayList<FEMapElement> _mapElements;
    public ArrayList<FEMapElement> GetMapElements() {
        return _mapElements;
    } 
    private Collection<FEMapElement> _elementSorter;

    //////////////////////////////////////////////////////
    // AI用情報
    //////////////////////////////////////////////////////
    // 地形効果バイアス
    private int[][] _terrainEffectBias;
    public int[][] GetTerrainEffectBias() {
        return _terrainEffectBias;
    }
    // 範囲損益分布
    private int[][] _rangeProfitDistribution;
    public int[][] GetRangeProfitDistribution() {
        return _rangeProfitDistribution;
    }
    private FEUnitAction _dummyAction;


    //////////////////////////////////////////////////////
    // イベント制御用
    //////////////////////////////////////////////////////
    private PHash<Integer> _localVariables;
    public PHash<Integer> GetLocalVariables() {
        return _localVariables;
    }
    private PHash<Boolean> _localSwitches;
    public PHash<Boolean> GetLocalSwitches() {
        return _localSwitches;
    }

    public FEBattleMapManager() {
        _mapWidth = _mapHeight = 0;

        _basePosOfMovingUnit = new PVector();
        _elapsedTurn = 0;

        _sortieUnits = new ArrayList<FEUnit>();
        _enemyUnits = new HashMap<Integer, FEOtherUnit>();
        _sortieEnemyUnits = new ArrayList<FEOtherUnit>();
        _events = new ArrayList<FEMapObject>();

        _attackerValue = new FEUnitBattleConsider();
        _defenderValue = new FEUnitBattleConsider();
        _battleResult = new FEUnitBattleConsider();

        _terrains = new FETerrain[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _hazardAreas = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _actionRanges = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];

        _mapPlayerObjects = new ArrayList<FEMapElement>();
        _mapEnemyObjects = new ArrayList<FEMapElement>();
        _mapElements = new ArrayList<FEMapElement>();
        _elementSorter = new Collection<FEMapElement>();

        _localVariables = new PHash<Integer>();
        _localSwitches = new PHash<Boolean>();

        _terrainEffectBias = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _rangeProfitDistribution = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _dummyAction = new FEUnitAction();
        _dummyAction.SetActionID(FEConst.BATTLE_AI_NO_MARK);
        _dummyAction.SetOnlyRangeAction(true);
    }

    /**
     マップを読み込み、マップ情報をリセットする
     */
    public void LoadMapData(String mapDataPath) {
        String path = FEConst.MAP_PATH + mapDataPath;
        try {
            JsonObject json = new JsonObject();
            json.LoadWithThrowException(path);
            JsonArray array;

            // マップ基本情報
            _mapName = json.GetString("Name", "No Data");
            _mapImagePath = json.GetString("Image Path", null);
            _mapWidth = json.GetInt("Width", -1);
            _mapHeight = json.GetInt("Height", -1);

            // 戦闘開始に関わるフラグ
            _isImmediatelySortie = json.GetBoolean("Immediately Sortie", true);
            _isSkipPreparation = json.GetBoolean("Skip Preparation", true);
            _isFirstPhase = json.GetBoolean("First Phase", true);

            // 地形情報
            boolean[][] terrain = new boolean[_mapHeight][_mapWidth];
            FETerrain defTerrain = feManager.GetDataBase().GetTerrains().get(json.GetInt("Default Terrain ID", 0));
            array = json.GetJsonArray("Terrains");
            JsonObject terrainObj;
            if (array != null) {
                int x, y, id;
                boolean exsId;
                for (int i=0; i<array.Size(); i++) {
                    terrainObj = array.GetJsonObject(i);
                    if (terrainObj == null) continue;
                    x = terrainObj.GetInt("x", -1);
                    y = terrainObj.GetInt("y", -1);
                    id = terrainObj.GetInt("ID", FEConst.NOT_FOUND);
                    exsId = feManager.GetDataBase().GetTerrains().containsKey(id);
                    if (x == -1 || y == -1 || !exsId) continue;
                    _terrains[y][x] = feManager.GetDataBase().GetTerrains().get(id);
                    terrain[y][x] = true;
                }
            }
            for (int i=0; i<_mapHeight; i++) {
                for (int j=0; j<_mapWidth; j++) {
                    if (terrain[i][j]) continue;
                    _terrains[i][j] = defTerrain;
                }
            }

            // 敵ユニットの原本生成
            _enemyUnits.clear();
            array = json.GetJsonArray("Enemies");
            if (array != null) {
                JsonObject enemy;
                FEOtherUnit otherUnit;
                for (int i=0; i<array.Size(); i++) {
                    enemy = array.GetJsonObject(i);
                    if (enemy == null) continue;
                    otherUnit = new FEOtherUnit();
                    feJsonUtility.LoadOtherUnit(otherUnit, enemy);
                    _enemyUnits.put(otherUnit.GetID(), otherUnit);
                }
            }

            // プレイヤーユニットの出撃地点情報
            array = json.GetJsonArray("Player Positions");
            _mapPlayerObjects.clear();
            if (array != null) {
                FEProgressManager fePm = feManager.GetProgressDataBase();
                JsonObject playerPosition;
                FEMapElement elem;
                FEUnit unit;
                int x, y;
                int unFixNum = 0;
                for (int i=0; i<array.Size(); i++) {
                    playerPosition = array.GetJsonObject(i);
                    if (playerPosition == null) continue;
                    x = playerPosition.GetInt("x", -1);
                    y = playerPosition.GetInt("y", -1);
                    if (!IsInMap(x, y)) continue;
                    elem = new FEMapElement(true);
                    elem.GetPosition().x = x;
                    elem.GetPosition().y = y;
                    unit = fePm.GetPlayerUnitOnID(playerPosition.GetInt("ID", FEConst.NOT_FOUND));
                    if (unit != null) {
                        elem.SetFixElement(true);
                        elem.SetMapObject(unit);
                    } else {
                        unFixNum++;
                    }
                    _mapPlayerObjects.add(elem);
                }
                _sortableUnitNum = _mapPlayerObjects.size();
                // 固定されていないユニットの中から出撃地点に埋め合わせを行う
                ArrayList<FEUnit> _units = feManager.GetProgressDataBase().GetPlayerUnits();
                boolean flag;
                for (int i=0; i<_units.size() || unFixNum > 0; i++) {
                    unit = _units.get(i);
                    flag = false;
                    for (int j=0; j<_mapPlayerObjects.size(); j++) {
                        elem = _mapPlayerObjects.get(j);
                        if (elem.GetMapObject() == unit) {
                            flag = true;
                            break;
                        }
                    }
                    if (flag) continue;
                    for (int j=0; j<_mapPlayerObjects.size(); j++) {
                        elem = _mapPlayerObjects.get(j);
                        if (elem.GetMapObject() != null) continue;
                        elem.SetMapObject(unit);
                        unFixNum--;
                        break;
                    }
                }
            }

            // 敵ユニットの出撃地点情報
            array = json.GetJsonArray("Enemy Positions");
            _mapEnemyObjects.clear();
            if (array != null) {
                JsonObject enemyPosition;
                FEMapElement elem;
                FEUnit unit, toUnit;
                int x, y;
                for (int i=0; i<array.Size(); i++) {
                    enemyPosition = array.GetJsonObject(i);
                    if (enemyPosition == null) continue;
                    x = enemyPosition.GetInt("x", -1);
                    y = enemyPosition.GetInt("y", -1);
                    if (!IsInMap(x, y)) continue;
                    elem = new FEMapElement(false);
                    elem.GetPosition().x = x;
                    elem.GetPosition().y = y;
                    unit = _enemyUnits.get(enemyPosition.GetInt("ID", FEConst.NOT_FOUND));
                    if (unit == null) continue;
                    toUnit = new FEOtherUnit();
                    unit.CopyTo(toUnit);
                    elem.SetFixElement(true);
                    elem.SetMapObject(toUnit);
                    _mapEnemyObjects.add(elem);
                }
            }

            _sortieMode = FEConst.BATTLE_SORTIE_MODE_NONE;
        } 
        catch(Exception e) {
            println(e);
            dialog.Show("エラー", "マップデータの読込に失敗しました。\npath = " + path);
        }

        if (_isImmediatelySortie) {
            PrepareSortie();
        }
    }

    /**
     セーブされた情報を読み込み、マップ情報をリセットする
     ただし、マップに関する情報が保存されていない場合は何もしない。
     */
    //public void LoadSavingData(String dataPath) {
    //}

    /**
     出撃準備に突入する。
     スキップフラグが立っている場合は、準備を飛ばして戦闘を開始する。
     */
    public void PrepareSortie() {
        // 全てのプレイヤーユニットの情報を最大値に設定しておく
        FEUnit unit;
        for (int i=0; i<feManager.GetProgressDataBase().GetPlayerUnits().size(); i++) {
            unit = feManager.GetProgressDataBase().GetPlayerUnits().get(i);
            unit.SetHp(unit.GetBaseParameter().GetHp());
        }

        if (_isSkipPreparation) {
            StartSortie();
            return;
        }

        _sortieMode = FEConst.BATTLE_SORTIE_MODE_IN_PREPARATION;
        feManager.GetProgressDataBase().SetSceneMoce(FEConst.OVERALL_MODE_PRE_SORTIE);
    }

    /**
     出撃する。
     */
    public void StartSortie() {
        // 空白の出撃地点を削除する
        FEMapElement elem;
        ArrayList<FEMapElement> elems = new ArrayList<FEMapElement>();
        for (int i=0; i<_mapPlayerObjects.size(); i++) {
            elem = _mapPlayerObjects.get(i);
            if (elem.GetMapObject() == null) {
                elems.add(elem);
            } else {
                elem.SetFixElement(true);
            }
        }
        for (int i=0; i<elems.size(); i++) {
            _mapPlayerObjects.remove(elems.get(i));
        }

        // マップエレメントの生成処理
        _mapElements.clear();
        // 出撃プレイヤーユニットを確定する
        _sortieUnits.clear();
        for (int i=0; i<_mapPlayerObjects.size(); i++) {
            elem = _mapPlayerObjects.get(i);
            _mapElements.add(elem);
            _sortieUnits.add((FEUnit)elem.GetMapObject());
        }

        // 出撃敵ユニットを確定する
        _sortieEnemyUnits.clear();
        for (int i=0; i<_mapEnemyObjects.size(); i++) {
            elem = _mapEnemyObjects.get(i);
            _mapElements.add(elem);
            _sortieEnemyUnits.add((FEOtherUnit)elem.GetMapObject());
        }

        // ユニットのパラメータを更新
        UpdateAllUnitsParameter();

        // ユニットの行動範囲を更新
        _UpdateAllActionRange();

        _sortieMode = FEConst.BATTLE_SORTIE_MODE_SORTIE;
        _operationMode = FEConst.BATTLE_OPE_MODE_NORMAL;

        // 地形効果バイアスの算出
        UpdateTerrainEffectBias();

        // 先攻後攻決定
        _actionPhase = _isFirstPhase;
        feManager.GetProgressDataBase().SetSceneMoce(FEConst.OVERALL_MODE_SORTIE);
    }

    /**
     戦闘を開始する。
     */
    public void StartBattle(FEMapElement attacker, FEMapElement defender) {
        // REMARK プレイヤー側では戦闘予測を表示するのでそのタイミングで戦闘予測を計算する AIは攻撃対象を最終的に決めてから行動に移すので、そのタイミングで計算する
        attacker.SetRunning(true);
        defender.SetRunning(true);
        // 戦闘開始時の先攻(trueは攻撃者、falseは非攻撃者)
        _battlePhase = true;
        _attackerElement = attacker;
        _defenderElement = defender;
        _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE_START;
    }

    /**
     戦闘の予測を行う。
     */
    private void PredictBattle(FEMapElement attacker, FEMapElement defender, boolean isPredict) {
        // パラメータ更新
        _UpdateBattlerValues(attacker, defender);
        // 攻撃回数、攻撃チャンス数更新
        _UpdateBattlerAttackChances(attacker, defender, isPredict);
    }

    /**
     戦闘に加わるユニット同士の威力、ダメージ、命中率、会心率を更新する。
     */
    private void _UpdateBattlerValues(FEMapElement attacker, FEMapElement defenser) {
        // 各々単独のパラメータを更新
        UpdateUnitParameter(attacker);
        UpdateUnitParameter(defenser);

        // 互いの考慮
        _attackerValue.Reset(0);
        _defenderValue.Reset(0);
        FEUnit atk, def;
        atk = (FEUnit) attacker.GetMapObject();
        def = (FEUnit) defenser.GetMapObject();
        FEClass atkC, defC;
        atkC = feManager.GetDataBase().GetUnitClasses().get(atk.GetUnitClassID());
        defC = feManager.GetDataBase().GetUnitClasses().get(def.GetUnitClassID());
        FEWeapon atkW, defW;
        atkW = atk.GetEquipWeapon() != null ? (FEWeapon)atk.GetEquipWeapon().GetItem() : null;
        defW = def.GetEquipWeapon() != null ? (FEWeapon)def.GetEquipWeapon().GetItem() : null;
        boolean atkSpecial, defSpecial;
        if (atkW != null) {
            atkSpecial = atkW.IsContainSpecialAttack(defC.GetClassType());
        } else {
            atkSpecial = false;
        }
        if (defW != null) {
            defSpecial = defW.IsContainSpecialAttack(atkC.GetClassType());
        } else {
            defSpecial = false;
        }
        // 相性考慮
        if (atkW != null && defW != null) {
            FEWeaponClass atkWC, defWC;
            atkWC = feManager.GetDataBase().GetWeaponClasses().get(atkW.GetWeaponClassID());
            defWC = feManager.GetDataBase().GetWeaponClasses().get(defW.GetWeaponClassID());
            _ConsiderCompatibility(atkWC, defW, _attackerValue);
            _ConsiderCompatibility(defWC, atkW, _attackerValue);
        }
        // 特効係数を考慮して威力確定
        _ConsiderPower(atk, atkW, atkSpecial, _attackerValue);
        _ConsiderPower(def, defW, defSpecial, _defenderValue);
        // 互いの威力を考慮してダメージ値確定
        _ConsiderDamager(def, atk, _defenderValue, _attackerValue);
        _ConsiderDamager(atk, def, _attackerValue, _defenderValue);
        // 命中率と会心率を設定
        _ConsiderAccuracyAndCritical(atk, def, _attackerValue);
        _ConsiderAccuracyAndCritical(def, atk, _defenderValue);
        // 下限修正
        _attackerValue.CorrectToLimit();
        _defenderValue.CorrectToLimit();
    }

    /**
     武器相性を考慮する。
     */
    private void _ConsiderCompatibility(FEWeaponClass wc, FEWeapon w, FEUnitBattleConsider consider) {
        if (wc != null) {
            FEWeaponCompatibility comp = wc.GetCompatibility().get(w.GetWeaponClassID());
            if (comp != null) {
                FEUnitBattleParameter correct = comp.GetCorrect();
                int a = comp.IsBadCompatibility()?-1:1;
                consider.AddPower(a * correct.GetPower());
                consider.AddAccuracy(a * correct.GetAccuracy());
                consider.AddCritical(a * correct.GetCritical());
            }
        }
    }

    /**
     威力を考慮する。
     */
    private void _ConsiderPower(FEUnit unit, FEWeapon w, boolean isSpecialAttack, FEUnitBattleConsider consider) {
        if (w != null) {
            consider.AddPower((int)(unit.GetBattleParameter().GetPower() * (isSpecialAttack?FEConst.CONFIG_SPECIAL_HIT_RATE:1)));
        } else {
            consider.SetPower(0);
        }
    }

    /**
     ダメージを考慮する。
     */
    private void _ConsiderDamager(FEUnit damaging, FEUnit damaged, FEUnitBattleConsider damagingValue, FEUnitBattleConsider damagedValue) {
        switch(damaging.GetBattleParameter().GetPowerType()) {
        case FEConst.WEAPON_POWER_PHYSICS:
            damagedValue.AddDamage(damagingValue.GetPower() - damaged.GetBattleParameter().GetDefense());
            break;
        case FEConst.WEAPON_POWER_MAGIC:
            damagedValue.AddDamage(damagingValue.GetPower() - damaged.GetBattleParameter().GetMDefense());
            break;
        case FEConst.WEAPON_POWER_UNKNOWN:
            damagedValue.AddDamage(damagingValue.GetPower());
            break;
        }
    }

    /**
     命中率と会心率を考慮する。
     */
    private void _ConsiderAccuracyAndCritical(FEUnit damaging, FEUnit damaged, FEUnitBattleConsider damagingValue) {
        damagingValue.AddAccuracy(damaging.GetBattleParameter().GetAccuracy() - damaged.GetBattleParameter().GetAvoid());
        damagingValue.AddAccuracy(damaging.GetBattleParameter().GetCritical() - damaged.GetBattleParameter().GetCriticalAvoid());
    }

    /**
     互いの攻撃チャンス数と攻撃回数を更新する。
     */
    private void _UpdateBattlerAttackChances(FEMapElement attacker, FEMapElement defenser, boolean isPredict) {
        // 攻撃チャンス数の考慮
        _remainAttackerChance = _remainDefenderChance = 1;
        FEUnit atk, def;
        atk = (FEUnit) attacker.GetMapObject();
        def = (FEUnit) defenser.GetMapObject();
        FEUnitBattleParameter atkB, defB;
        atkB = atk.GetBattleParameter();
        defB = def.GetBattleParameter();
        int speed = atkB.GetSpeed() - defB.GetSpeed();
        if (speed >= 5) {
            _remainAttackerChance++;
        } else if (speed <= -5) {
            _remainDefenderChance++;
        }
        float x, y;
        x = attacker.GetPosition().x - defenser.GetPosition().x;
        y = attacker.GetPosition().y - defenser.GetPosition().y;
        int range = (int)(abs(x)) + (int)(abs(y));
        if (!isPredict) {
            if (range < defB.GetMinRange() || range > defB.GetMaxRange()) {
                _remainDefenderChance = 0;
            }
        } else {
            // ユニットは適切な距離を保って攻撃すると仮定
            if (!_IsIncludeRange(defB.GetMinRange(), defB.GetMaxRange(), atkB.GetMinRange()) || !_IsIncludeRange(defB.GetMinRange(), defB.GetMaxRange(), atkB.GetMaxRange())) {
                _remainDefenderChance = 0;
            }
        }
        // 攻撃回数の考慮
        _attackerAttackNum = _defenderAttackNum = 0;
        _attackerAttackNum = atkB.GetAttackNum();
        _defenderAttackNum = defB.GetAttackNum();
    }

    /**
     命中判定、会心判定を行い、ダメージ量を求める。
     */
    public void Battle() {
        if (_battlePhase) {
            _SetBattleResult(_attackerValue, _defenderValue);
        } else {
            _SetBattleResult(_defenderValue, _attackerValue);
        }
        _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE;
    }

    /**
     指定された確率に当たったらtrueを返す。
     100以上は必ずtrueになる。
     */
    private boolean _IsHitOn(int parcentage) {
        return random(0, 100) < parcentage;
    }

    private void _SetBattleResult(FEUnitBattleConsider damaging, FEUnitBattleConsider damaged) {
        _battleResult.Reset(0);
        boolean isHit, isCritical = false;
        isHit = _IsHitOn(damaging.GetAccuracy());
        _battleResult.SetAccuracy(isHit?1:0);
        if (isHit) {
            isCritical = _IsHitOn(damaging.GetCritical());
        }
        _battleResult.SetCritical(isCritical?1:0);
        _battleResult.SetDamage(isHit?(int)(damaged.GetDamage()*(isCritical?FEConst.CONFIG_CRITICAL_HIT_RATE:1)):0);
    }

    /**
     HPを減少させる。
     分けておかないと自動的にHPバーに反映されてしまう。
     */
    public void BattleDamage() {
        FEUnit unit;
        if (_battlePhase) {
            unit = (FEUnit)_defenderElement.GetMapObject();
            unit.AddHp(-_battleResult.GetDamage());
        } else {
            unit = (FEUnit)_attackerElement.GetMapObject();
            unit.AddHp(-_battleResult.GetDamage());
        }
        if (unit.GetHp() < 0) unit.SetHp(0);
    }

    /**
     戦闘に参加したどちらかがHP0の場合はtrueを返し、操作モードもBATTLE_RESULTにする。
     */
    public boolean IsBattlerDead() {
        FEUnit atk, def;
        atk = (FEUnit)_attackerElement.GetMapObject();
        def = (FEUnit)_defenderElement.GetMapObject();
        if (atk.GetHp() == 0 || def.GetHp() == 0) {
            _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE_RESULT;
            if (atk.GetHp() == 0) {
                _attackerElement.SetDead(true);
            } else {
                _defenderElement.SetDead(true);
            }
            return true;
        }
        return false;
    }

    /**
     戦闘を終了するかどうかを決める。
     どちらかがHP0もしくは、どちらの残り攻撃チャンス回数も0になっていた場合は終了とし、trueを返して操作モードをBATTLE_RESULTにする。
     それ以外は継続とし、falseを返して操作モードをBATTLE_STARTにする。
     */
    public boolean IsBattleEnd() {
        if (IsBattlerDead()) {
            return true;
        }
        if (_battlePhase) {
            _remainAttackerChance--;
        } else {
            _remainDefenderChance--;
        }
        if (_remainAttackerChance <= 0 && _remainDefenderChance <= 0) {
            _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE_RESULT;
            return true;
        }
        if (_battlePhase) {
            _battlePhase = _remainDefenderChance <= 0;
        } else {
            _battlePhase = _remainAttackerChance > 0;
        }
        _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE_START;
        return false;
    }

    /**
     戦闘が終了した時に呼び出される。
     */
    public void OnFinishBattle() {
        _attackerElement.SetRunning(false);
        _defenderElement.SetRunning(false);
        SetAlreadyUnit(_attackerElement);
        if (_attackerElement.IsDead() || _defenderElement.IsDead()) {
            _operationMode = FEConst.BATTLE_OPE_MODE_BATTLE_DEAD;
            if (_attackerElement.IsDead()) {
                _attackerElement.SetAnimation(false);
            }
            if (_defenderElement.IsDead()) {
                _defenderElement.SetAnimation(false);
            }
        }
    }

    /**
     死亡した(透過0)ユニットを出撃リストから削除する。
     */
    public void RemoveDeadElement(FEMapElement elem) {
        if (_mapElements.contains(elem)) {
            _mapElements.remove(elem);
        }
        if (elem.IsPlayerUnit()) {
            _mapPlayerObjects.remove(elem);
            _sortieUnits.remove(elem.GetMapObject());
        } else {
            _mapEnemyObjects.remove(elem);
            _sortieEnemyUnits.remove(elem.GetMapObject());
        }
        _ConfirmUnitList();
        _UpdateOverallHazardArea();
        _operationMode = FEConst.BATTLE_OPE_MODE_NORMAL;
    }

    /**
     ユニットリストを確認し、勝敗条件を満足しているかどうかなどを確認する。
     */
    private void _ConfirmUnitList() {
        if (_mapPlayerObjects.isEmpty()) {
            // ゲームオーバ
            SceneGameOver gm = (SceneGameOver)sceneManager.GetScene(SceneID.SID_GAMEOVER);
            gm.GoGameOver();
            return;
        }
        if (_mapEnemyObjects.isEmpty()) {
            // ゲームクリア
            colorMode(RGB, 255, 255, 255);
            background(0, 255, 255);
            noLoop();
            return;
        }
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

    /**
     指定したマップ座標がマップ領域内にあるかどうかを返す。
     */
    public boolean IsInMap(int x, int y) {
        return !(x < 0 || x >= _mapWidth || y < 0 || y >= _mapHeight);
    }

    /**
     ユニットを待機状態にして行動範囲を更新する。
     もし、全ての同じ軍のユニットが待機状態になっている場合は強制的にフェーズを移行する。
     */
    public void SetAlreadyUnit(FEMapElement elem) {
        if (elem == null) return;
        elem.SetAlready(true);
        boolean flag = false;
        ArrayList<FEMapElement> elems;
        if (elem.IsPlayerUnit()) {
            elems = _mapPlayerObjects;
        } else {
            elems = _mapEnemyObjects;
        }
        for (int i=0; i<elems.size(); i++) {
            if (!elems.get(i).IsAlready()) {
                flag = true;
                break;
            }
        }
        _SetToNormalMode();
        if (flag) return;
        ChangeSortiePhase();
    }

    /**
     行動フェーズを切り替える。
     もし切り替え先の軍に誰一人として行動可能なユニットがいない場合は切り替え元の軍にフェーズが戻ってくる。
     */
    public void ChangeSortiePhase() {
        if (_actionPhase) {
            if (!_mapEnemyObjects.isEmpty()) {
                _actionPhase = !_actionPhase;
            }
        } else {
            if (!_mapPlayerObjects.isEmpty()) {
                _actionPhase = !_actionPhase;
            }
        }
        _ResetAllUnitActivities();
        _UpdateOverallHazardArea();
        if (!_actionPhase) {
            UpdateAllUnitsParameter();
            UpdateAllUnitsPowerBias();
            _operationMode = FEConst.BATTLE_OPE_MODE_AI_THINKING;
        }
    }

    /**
     全てのユニットの行動力を回復する。
     */
    private void _ResetAllUnitActivities() {
        for (int i=0; i<_mapElements.size(); i++) {
            _mapElements.get(i).SetAlready(false);
        }
    }

    /**
     カーソルが重なっている座標を受け取る。
     */
    public void OnOverlapped(int x, int y) {
        switch(_operationMode) {
        case FEConst.BATTLE_OPE_MODE_NORMAL:
            FEMapElement elem = GetMapElementOnPos(x, y);
            if (elem != _preOverlappedElement) {
                _preOverlappedElement = _overlappedElement;
                _overlappedElement = elem;
                _ClearIntegerArray(_actionRanges);
                if (elem != null) {
                    if (elem.GetMapObject() instanceof FEUnit) {
                        _overlappedUnit = (FEUnit)elem.GetMapObject();
                    }
                    _UpdateOverallActionRange(elem, true);
                }
            }
            break;
        }
    }
    private FEMapElement _preOverlappedElement;

    /**
     クリックされた座標を受け取り、プレイヤーの操作を処理する。
     */
    public void OnClick(int x, int y) {
        switch(_operationMode) {
        case FEConst.BATTLE_OPE_MODE_NORMAL:
        case FEConst.BATTLE_OPE_MODE_AI_MOVING:
            _OnModeNormal(x, y);
            break;
        case FEConst.BATTLE_OPE_MODE_ACTIVE:
            _OnModeActive(x, y);
            break;
        case FEConst.BATTLE_OPE_MODE_FINISH_MOVE:
            _OnModeMovingFinish(x, y);
            break;
        case FEConst.BATTLE_OPE_MODE_PRE_BATTLE:
            _OnModePreBattle(x, y);
            break;
        }
    }

    private void _OnModeNormal(int x, int y) {
        FEMapElement elem = GetMapElementOnPos(x, y);
        boolean isLeft = mouseButton == LEFT;
        if (isLeft || !_actionPhase) {
            if (elem == null) return;
            FEMapObject mapObj = elem.GetMapObject();
            if (!(mapObj instanceof FEUnit)) return;
            if (elem.IsPlayerUnit()) {
                if (elem.IsAlready()) return;
                _operationMode = FEConst.BATTLE_OPE_MODE_ACTIVE;
                _selectedUnit = (FEUnit)elem.GetMapObject();
                _selectedElement = elem;
                _selectedElement.SetRunning(true);
            } else {
                if (_actionPhase) {
                    elem.SetDrawHazardAreas(!elem.IsDrawHazardAres());
                    _UpdateOverallHazardArea();
                } else {
                    if (elem.IsAlready()) return;
                    _operationMode = FEConst.BATTLE_OPE_MODE_ACTIVE;
                    _selectedUnit = (FEUnit)elem.GetMapObject();
                    _selectedElement = elem;
                    _selectedElement.SetRunning(true);
                }
            }
        } else {
            // テスト用 ユニットのステータス表示
            if (elem != null) {
                println(elem.GetMapObject());
            }
        }
    }

    private void _OnModeActive(int x, int y) {
        FEMapElement elem = GetMapElementOnPos(x, y);
        boolean isLeft = mouseButton == LEFT;
        if (isLeft || !_actionPhase) {
            if (IsInMap(x, y) && _actionRanges[y][x] == FEConst.BATTLE_MAP_MARKER_ACTION) {
                FEClass unitClass = feManager.GetDataBase().GetUnitClasses().get(_selectedUnit.GetUnitClassID());
                if (unitClass == null) {
                    _SetToNormalMode();
                }
                PVector baseP = _selectedElement.GetPosition();
                ArrayList<PVector> _a, _b;
                _a = _MakeRouteToAimPosition(_selectedElement, unitClass.GetClassType(), x, y, (int)baseP.x, (int)baseP.y, _selectedUnit.GetBaseParameter().GetMov(), true);
                _b = _MakeRouteToAimPosition(_selectedElement, unitClass.GetClassType(), x, y, (int)baseP.x, (int)baseP.y, _selectedUnit.GetBaseParameter().GetMov(), false);
                if (_a == null && _b == null) {
                    _SetToNormalMode();
                } else {
                    if (_a != null) {
                        _CutRedundantRoute(_a);
                    }
                    if (_b != null) {
                        _CutRedundantRoute(_b);
                    }
                    if (_a != null && _b == null) {
                        _unitRoute = _a;
                    } else if (_a == null && _b != null) {
                        _unitRoute = _b;
                    } else {
                        _unitRoute = (_a.size() <= _b.size()?_a:_b);
                    }
                    _basePosOfMovingUnit.x = baseP.x;
                    _basePosOfMovingUnit.y = baseP.y;
                    _operationMode = FEConst.BATTLE_OPE_MODE_MOVING;
                }
            }
        } else {
            _SetToNormalMode();
        }
    }

    private void _OnModeMovingFinish(int x, int y) {
        FEMapElement elem = GetMapElementOnPos(x, y);
        boolean isLeft = mouseButton == LEFT;
        if (isLeft || !_actionPhase) {
            SetAlreadyUnit(_selectedElement);
        } else {
            _selectedElement.GetPosition().x = _basePosOfMovingUnit.x;
            _selectedElement.GetPosition().y = _basePosOfMovingUnit.y;
            _SetToNormalMode();
        }
    }

    private void _OnModePreBattle(int x, int y) {
        FEMapElement elem = GetMapElementOnPos(x, y);
        boolean isLeft = mouseButton == LEFT;
        if (isLeft || !_actionPhase) {
            if (elem == null) return;
            FEMapObject mapObj = elem.GetMapObject();
            if (!(mapObj instanceof FEUnit)) return;
            if (IsInMap(x, y) && _actionRanges[y][x] == FEConst.BATTLE_MAP_MARKER_ATTACK) {
                if (_selectedElement.IsPlayerUnit() == elem.IsPlayerUnit()) return;
                // 戦闘開始
                PredictBattle(_selectedElement, elem, false);
                StartBattle(_selectedElement, elem);
            } else {
                // AIのキャンセル行動
                if (!_actionPhase) {
                    _operationMode = FEConst.BATTLE_OPE_MODE_FINISH_MOVE;
                }
            }
        } else {
            _operationMode = FEConst.BATTLE_OPE_MODE_FINISH_MOVE;
        }
    }

    /**
     探索したルートの同じ座標を行き来している部分を検出し、そこをショートカットする。
     */
    private void _CutRedundantRoute(ArrayList<PVector> route) {
        int idx1 = 0, idx2 = 0;
        boolean flag;
        PVector pos1, pos2;
        while (true) {
            flag = false;
            for (int i=0; i<route.size()-1; i++) {
                pos1 = route.get(i);
                idx2 = -1;
                for (int j=i+1; j<route.size(); j++) {
                    pos2 = route.get(j);
                    if (pos1.x == pos2.x && pos1.y == pos2.y) {
                        idx2 = j;
                        break;
                    }
                }
                if (idx2 > 0 && i != idx2) {
                    flag = true;
                    idx1 = i;
                    break;
                }
            }
            if (flag) {
                for (int i = idx2 - idx1; i>0; i--) {
                    route.remove(idx1);
                }
            } else {
                break;
            }
        }
    }

    /**
     操作をNORMALに移行する。
     */
    private void _SetToNormalMode() {
        _operationMode = FEConst.BATTLE_OPE_MODE_NORMAL;
        _UpdateAllActionRange();
        _UpdateOverallActionRange(_selectedElement, true);
        _selectedUnit = null;
        _selectedElement.SetRunning(false);
        _elementSorter.SortList(_mapElements);
    }

    private void _ClearIntegerArray(int[][] ary) {
        if (ary == null) return;
        for (int i=0; i<ary.length; i++) {
            for (int j=0; j<ary[0].length; j++) {
                ary[i][j] = 0;
            }
        }
    }

    /**
     移動が完了した時に呼び出される。
     */
    public void OnFinishMoving() {
        _operationMode = FEConst.BATTLE_OPE_MODE_FINISH_MOVE;
        _elementSorter.SortList(_mapElements);

        // テスト用で戦闘準備にすぐ移行する
        _operationMode = FEConst.BATTLE_OPE_MODE_PRE_BATTLE;
        _UpdateOverallActionRange(_selectedElement, false);
        // 攻撃範囲に敵ユニットが一切いない場合はモードを戻す
        FEMapElement elem;
        int x, y;
        boolean flag = false;
        for (int i=0; i<_mapElements.size(); i++) {
            elem = _mapElements.get(i);
            if (elem.IsPlayerUnit() == _selectedElement.IsPlayerUnit()) continue;
            x = (int)elem.GetPosition().x;
            y = (int)elem.GetPosition().y;
            if (_selectedElement.GetAttackRange()[y][x]) {
                flag = true;
                break;
            }
        }
        if (!flag) {
            _operationMode = FEConst.BATTLE_OPE_MODE_FINISH_MOVE;
        }
    }

    /**
     自軍、敵軍全てのユニットのパラメータを更新する。
     */
    private void UpdateAllUnitsParameter() {
        for (int i=0; i<_mapElements.size(); i++) {
            UpdateUnitParameter(_mapElements.get(i));
        }
    }

    /**
     ユニットの自身のパラメータ、武器、アイテム、スキル、ステート、地形のパラメータ補正を総合的に合わせたパラメータを計算して保持する。
     */
    public void UpdateUnitParameter(FEMapElement elem) {
        if (elem == null) return;
        if (!(elem.GetMapObject() instanceof FEUnit)) return;
        FEUnit unit = (FEUnit)elem.GetMapObject();
        FEUnitParameter prm;

        // 通常パラメータ
        prm = unit.GetCorrectParameter();
        prm.Reset(0);
        // 武器の補正
        if (unit.GetEquipWeapon() != null) {
            unit.GetEquipWeapon().GetItem().GetParameterBonus().AddTo(prm);
        }
        // アイテムの補正
        FEActualItem item;
        for (int i=0; i<unit.GetItemList().size(); i++) {
            item = unit.GetItemList().get(i);
            if (!item.IsItem()) continue;
            item.GetItem().GetParameterBonus().AddTo(prm);
        }
        // TODO スキルの補正

        // TODO ステートの補正

        // 地形の補正
        int x, y;
        x = (int)elem.GetPosition().x;
        y = (int)elem.GetPosition().y;
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(_terrains[y][x].GetEffectID());
        if (terE != null) {
            prm.AddDef(terE.GetDefense());
            prm.AddMdf(terE.GetMDefense());
        }

        unit.GetBaseParameter().CopyTo(unit.GetParameter());
        prm.AddTo(unit.GetParameter());

        // パラメータが下限を超えないように修正
        unit.GetParameter().CorrectToLimit();

        // 戦闘用パラメータ
        FEUnitBattleParameter bPrm = unit.GetBattleParameter();
        bPrm.Reset(0);
        // クラス補正
        FEClass unitClass = feManager.GetDataBase().GetUnitClasses().get(unit.GetUnitClassID());
        if (unitClass == null) {
            bPrm.Reset(FEConst.NOT_FOUND);
            return;
        }
        unitClass.GetBattleParameter().CopyTo(bPrm);
        // 武器の補正
        if (unit.GetEquipWeapon() != null) {
            FEWeapon wep = (FEWeapon) unit.GetEquipWeapon().GetItem();
            bPrm.SetPowerType(wep.GetPowerType());
            bPrm.AddPower(wep.GetPower());
            bPrm.AddAccuracy(wep.GetAccuracy());
            bPrm.AddCritical(wep.GetCritical());
            bPrm.SetMinRange(wep.GetMinRange());
            bPrm.SetMaxRange(wep.GetMaxRange());
            bPrm.AddSpeed(-wep.GetWeight());
            bPrm.SetAttackNum(wep.GetAttackNum());
        }
        // パラメータの補正
        prm = unit.GetParameter(); 
        int p = 0;
        if (bPrm.GetPowerType() == FEConst.WEAPON_POWER_PHYSICS) {
            p = prm.GetAtk();
        } else if (bPrm.GetPowerType() == FEConst.WEAPON_POWER_MAGIC) {
            p = prm.GetMat();
        }
        bPrm.AddPower(p);
        bPrm.AddDefense(prm.GetDef());
        bPrm.AddMDefense(prm.GetMdf());
        bPrm.AddAccuracy((prm.GetTec() * 3 + prm.GetLuc()) / 2);
        bPrm.AddSpeed(prm.GetSpd());
        bPrm.AddAvoid((prm.GetSpd() * 3 + prm.GetLuc()) / 2);
        bPrm.AddCritical((prm.GetTec() - 4) / 2);
        bPrm.AddCriticalAvoid(prm.GetLuc() / 2);

        // パラメータが下限を超えないように修正
        bPrm.CorrectToLimit();
    }

    /**
     マップ上にいる敵ユニットの行動範囲で危険領域を更新する。
     */
    private void _UpdateOverallHazardArea() {
        int a;
        FEMapElement elem;
        _ClearIntegerArray(_hazardAreas);
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                a = 0;
                for (int k=0; k<_mapEnemyObjects.size(); k++) {
                    elem = _mapEnemyObjects.get(k);
                    if (!elem.IsDrawHazardAres()) continue;
                    if (elem.GetAttackRange()[i][j]) {
                        a = FEConst.BATTLE_MAP_MARKER_ATTACK;
                        break;
                    } else if (elem.GetCaneRange()[i][j]) {
                        a = FEConst.BATTLE_MAP_MARKER_CANE;
                    }
                }
                _hazardAreas[i][j] = a;
            }
        }
    }

    /**
     指定したマーカ要素の行動範囲を用いてマップ中の行動範囲を更新する。
     */
    private void _UpdateOverallActionRange(FEMapElement elem, boolean isConsiderMoving) {
        _UpdateSelfActionRange(elem, isConsiderMoving);
        _ClearIntegerArray(_actionRanges);
        FEMapElement e;
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                e = GetMapElementOnPos(j, i);
                if (elem.GetActionRange()[i][j] && (e == null || elem == e)) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_ACTION;
                } else if (elem.GetAttackRange()[i][j] && (e == null || elem.IsPlayerUnit() != e.IsPlayerUnit())) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_ATTACK;
                } else if (elem.GetCaneRange()[i][j]) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_CANE;
                }
            }
        }
    }

    /**
     自軍、敵軍全てのユニットの行動範囲を更新し、行動範囲配列をクリアする。
     */
    private void _UpdateAllActionRange() {
        for (int i=0; i<_mapElements.size(); i++) {
            _UpdateSelfActionRange(_mapElements.get(i), true);
        }
        _ClearIntegerArray(_actionRanges);
    }

    /**
     指定したマップ要素の行動範囲マーカを更新する。
     */
    private void _UpdateSelfActionRange(FEMapElement elem, boolean isConsiderMoving) {
        if (elem == null) return;
        if (!(elem.GetMapObject() instanceof FEUnit)) return;
        FEUnit unit = (FEUnit)elem.GetMapObject();
        // ユニットの行動範囲の初期化
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                elem.GetActionRange()[i][j] = false;
                elem.GetAttackRange()[i][j] = false;
                elem.GetCaneRange()[i][j] = false;
            }
        }
        FEClass unitClass = feManager.GetDataBase().GetUnitClasses().get(unit.GetUnitClassID());
        if (unitClass == null) return;

        // TODO 杖の射程を考慮
        int mov, minR, maxR, x, y;
        mov = isConsiderMoving ? unit.GetParameter().GetMov() : 0;
        if (mov < 0) return;
        minR = unit.GetBattleParameter().GetMinRange();
        maxR = unit.GetBattleParameter().GetMaxRange();
        minR = minR < 0 ? 0 : minR;
        maxR = maxR < 0 ? 0 : maxR;
        x = (int)elem.GetPosition().x;
        y = (int)elem.GetPosition().y;
        _SetRecursiveActionRange(elem, unitClass.GetClassType(), x, y, mov, minR, maxR, 0);
    }

    private void _SetRecursiveActionRange(FEMapElement elem, int classType, int x, int y, int remain, int minR, int maxR, int caneR) {
        if (!IsInMap(x, y)) return;
        if (remain < 0) return;

        FETerrain ter = GetTerrains()[y][x];
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(ter.GetEffectID());
        if (terE == null) return;
        if (!terE.IsMovable()) return;

        FEMapElement otherElem = GetMapElementOnPos(x, y);
        if (otherElem != null && otherElem.GetMapObject() instanceof FEUnit) {
            if (otherElem != elem) {
                if (remain == 0) return;
                // 敵はすり抜けられない
                if (_sortieUnits.contains(otherElem.GetMapObject()) && !elem.IsPlayerUnit()) return;
                if (_sortieEnemyUnits.contains(otherElem.GetMapObject()) && elem.IsPlayerUnit()) return;
            }
        }

        elem.GetActionRange()[y][x] = true;
        _SetRange(x, y, minR, maxR, elem.GetAttackRange());
        if (caneR > 0) {
            _SetRange(x, y, 1, caneR, elem.GetCaneRange());
        }

        int cost = terE.GetMoveConts().get(classType);
        _SetRecursiveActionRange(elem, classType, x, y - 1, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, x - 1, y, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, x, y + 1, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, x + 1, y, remain - cost, minR, maxR, caneR);
    }

    private void _SetRange(int x, int y, int minR, int maxR, boolean[][] target) {
        if (target == null) return;
        int r, a, b;
        for (int i=-maxR; i<=maxR; i++) {
            r = maxR - abs(i);
            for (int j=-r; j<=r; j++) {
                if (abs(i) + abs(j) >= minR) {
                    a = y + i;
                    b = x + j;
                    if (!IsInMap(b, a)) continue;
                    target[y+i][x+j] = true;
                }
            }
        }
    }

    /**
     いまいる座標から目標座標へのルートを作成する。
     */
    private ArrayList<PVector> _MakeRouteToAimPosition(FEMapElement elem, int classType, int aimX, int aimY, int x, int y, int remain, boolean isFromTop) {
        if (!IsInMap(x, y)) return null;
        if (remain < 0) return null;
        if (!elem.GetActionRange()[y][x]) return null;

        FETerrain ter = GetTerrains()[y][x];
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(ter.GetEffectID());
        if (terE == null) return null;
        if (!terE.IsMovable()) return null;

        ArrayList<PVector> aim;
        if (x == aimX && y == aimY) {
            aim = new ArrayList<PVector>();
            aim.add(new PVector(x, y));
            return aim;
        }

        int cost = terE.GetMoveConts().get(classType);
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x, y - (isFromTop?1:-1), remain - cost, isFromTop);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x - 1, y, remain - cost, isFromTop);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x, y + (isFromTop?1:-1), remain - cost, isFromTop);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x + 1, y, remain - cost, isFromTop);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        return null;
    }


    /**
     敵AI用処理。
     毎フレーム呼び出してタイミングを図る。
     */
    public void Update() {
        if (feManager.GetProgressDataBase().GetSceneMode() !=  FEConst.OVERALL_MODE_SORTIE) return;
        if (mousePressed&&!_actionPhase) {
            println(_operationMode);
            println(GetMapElementOnPos(5, 9));
        }
        switch(_operationMode) {
        case FEConst.BATTLE_OPE_MODE_AI_THINKING:
            if (_actionPhase) {
                // プレイヤー側のおまかせとして残しておく
            } else {
                // 敵ごとに行動を決定する
                FEMapElement elem;
                for (int i=0; i<_mapEnemyObjects.size(); i++) {
                    elem = _mapEnemyObjects.get(i);
                    if (elem.IsAlready()) continue;
                    for (int a=0; a<_mapHeight; a++) {
                        for (int b=0; b<_mapWidth; b++) {
                            print((elem.GetActionRange()[a][b]?"T":"f")+", ");
                        }
                        println("");
                    }
                    println("");
                    _UpdateOverallActionRange(elem, true);
                    _UpdateOverallHazardArea();
                    _CalcUnitProfitDistribution(elem);
                    _DecideAction(elem, _mapPlayerObjects);
                    break;
                }
                _operationMode = FEConst.BATTLE_OPE_MODE_AI_MOVING;
            }
            break;
        case FEConst.BATTLE_OPE_MODE_AI_MOVING:
            if (_actionPhase) {
                // プレイヤー側のおまかせとして残しておく
            } else {
                // 自身を選択して
                FEMapElement elem;
                for (int i=0; i<_mapEnemyObjects.size(); i++) {
                    elem = _mapEnemyObjects.get(i);
                    if (elem.IsAlready()) continue;
                    OnClick((int)elem.GetPosition().x, (int)elem.GetPosition().y);
                    break;
                }
            }
            break;
        case FEConst.BATTLE_OPE_MODE_ACTIVE:
            if (_actionPhase) {
                // プレイヤー側のおまかせとして残しておく
            } else {
                // 目的の場所まで移動する
                FEOtherUnit unit = (FEOtherUnit)_selectedUnit;
                OnClick((int)unit.GetGotoPos().x, (int)unit.GetGotoPos().y);
            }
            break;
        case FEConst.BATTLE_OPE_MODE_PRE_BATTLE:
            if (_actionPhase) {
                // プレイヤー側のおまかせとして残しておく
            } else {
                // 戦闘を開始する
                FEOtherUnit unit = (FEOtherUnit)_selectedUnit;
                FEUnitBattleParameter bp = unit.GetBattleParameter();
                float x, y, range;
                x = unit.GetGotoPos().x - unit.GetAttackPos().x;
                y = unit.GetGotoPos().y - unit.GetAttackPos().y;
                range = abs(x) + abs(y);
                if (IsInMap((int)unit.GetAttackPos().x, (int)unit.GetAttackPos().x) && _IsIncludeRange(bp.GetMinRange(), bp.GetMaxRange(), (int)range)) {
                    OnClick((int)unit.GetAttackPos().x, (int)unit.GetAttackPos().y);
                } else {
                    OnClick((int)_selectedElement.GetPosition().x, (int)_selectedElement.GetPosition().y);
                }
            }
            break;
        case FEConst.BATTLE_OPE_MODE_FINISH_MOVE:
            if (_actionPhase) {
            } else {
                // 戦闘行動を行わずに、待機する
                OnClick((int)_selectedElement.GetPosition().x, (int)_selectedElement.GetPosition().y);
            }
            break;
        case FEConst.BATTLE_OPE_MODE_NORMAL:
            if (_actionPhase) {
                // プレイヤー側のおまかせとして残しておく
            } else {
                // 戦闘を開始する
                _operationMode = FEConst.BATTLE_OPE_MODE_AI_THINKING;
            }
            break;
        }
    }

    /**
     地形効果バイアスを作成する。
     */
    public void UpdateTerrainEffectBias() {
        _ClearIntegerArray(_terrainEffectBias);
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                _terrainEffectBias[i][j] = _CalcTerrainEffectBias(_terrains[i][j].GetEffectID());
            }
        }
    }

    /**
     地形効果バイアスを計算する。
     */
    private int _CalcTerrainEffectBias(int effectID) {
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(effectID);
        if (terE == null) return 0;
        int bias = 0;
        bias += terE.GetAvoid();
        bias += terE.GetDefense() * 3;
        bias += terE.GetMDefense() * 3;
        bias += terE.GetRecover() * 2;
        return bias;
    }

    /**
     全ユニットの戦闘力バイアスを作成する。
     */
    public void UpdateAllUnitsPowerBias() {
        FEMapElement elem;        
        FEUnit unit;
        for (int i=0; i<_mapElements.size(); i++) {
            elem = _mapElements.get(i);
            if (elem.GetMapObject() == null) return;
            if (!(elem.GetMapObject() instanceof FEUnit)) return;
            unit = (FEUnit) elem.GetMapObject();
            _CalcUnitPowerBias(unit);
        }
    }

    /**
     ユニットの戦闘力バイアスを計算する。
     */
    private void _CalcUnitPowerBias(FEUnit unit) {
        FEUnitBattleParameter bPrm = unit.GetBattleParameter();
        if (bPrm == null) {
            unit.SetPowerBias(0);
            return;
        }
        int bias = 0, minR, maxR;
        bias += bPrm.GetPower() * 15;
        bias += bPrm.GetDefense() * 5;
        bias += bPrm.GetMDefense() * 5;
        bias += bPrm.GetAccuracy() * 3;
        bias += bPrm.GetAvoid() * 3;
        bias += bPrm.GetCritical() * 2;
        bias += bPrm.GetCriticalAvoid();
        minR = bPrm.GetMinRange();
        maxR = bPrm.GetMaxRange();
        if (maxR > 0) {
            if (minR < 0) minR = 0; 
            bias += (2 * maxR - minR) * 10;
        }
        unit.SetPowerBias(bias);
    }

    /**
     損益値を計算し、損益分布を求める。
     */
    private void _CalcUnitProfitDistribution(FEMapElement elem) {
        FEOtherUnit unit;
        FEUnit enemy;
        FEMapElement enemyElem;
        int value;
        if (!(elem.GetMapObject() instanceof FEOtherUnit)) return;
        unit = (FEOtherUnit) elem.GetMapObject();
        _ClearIntegerArray(unit.GetUnitProfitDistribution());
        if (elem.IsPlayerUnit()) {
            // おまかせAIのために残しておく
        } else {
            for (int i=0; i<_mapPlayerObjects.size(); i++) {
                enemyElem = _mapPlayerObjects.get(i);
                enemy = (FEUnit)enemyElem.GetMapObject();
                value = unit.GetPowerBias() - enemy.GetPowerBias();
                for (int y=0; y<_mapHeight; y++) {
                    for (int x=0; x<_mapWidth; x++) {
                        if (enemyElem.GetAttackRange()[y][x]) {
                            unit.GetUnitProfitDistribution()[y][x] += value;
                        }
                    }
                }
            }
        }
    }

    /**
     行動リストから行動を決定する。
     */
    private void _DecideAction(FEMapElement elem, ArrayList<FEMapElement> enemies) {
        FEOtherUnit unit;
        if (!(elem.GetMapObject() instanceof FEOtherUnit)) return;
        unit = (FEOtherUnit) elem.GetMapObject();
        int targetPriority, rangePriority;
        FEMapElement target = null, range = null;
        targetPriority = _GetPriorityOfAction(elem, unit, enemies, true);
        if (targetPriority < unit.GetActionList().size()) {
            target = unit.GetActionList().get(targetPriority).GetTarget();
        }
        rangePriority = _GetPriorityOfAction(elem, unit, enemies, false);
        if (rangePriority < unit.GetActionList().size()) {
            range = unit.GetActionList().get(rangePriority).GetTarget();
        }
        if (targetPriority <= rangePriority) {
            if (rangePriority > 0) {
                target = range;
            } else {
                if (!_PickUpTarget(elem, enemies, false, _dummyAction)) {
                    // ノーマークでも対象相手が見つからない場合
                    _DecideNearestPosition(elem, enemies);
                    return;
                }
                target = _dummyAction.GetTarget();
            }
        }
        if (target != null) {
            // ターゲットに対してどの位置から攻撃するか
            _DeceideAttackPosition(elem, target);
        } else {
            // ノーマークではないがターゲット無しという場合は、行動しないと解釈する
            unit.GetGotoPos().x = elem.GetPosition().x;
            unit.GetGotoPos().y = elem.GetPosition().y;
            unit.GetAttackPos().x = -1;
            unit.GetAttackPos().y = -1;
        }
    }

    private int _GetPriorityOfAction(FEMapElement elem, FEOtherUnit unit, ArrayList<FEMapElement> enemies, boolean isTargetPriority) {
        FEUnitAction action;
        boolean flag;
        for (int i=0; i<unit.GetActionList().size(); i++) {
            action = unit.GetActionList().get(i);
            if (action.IsOnlyRangeAction()) continue;
            flag = _PickUpTarget(elem, enemies, isTargetPriority, action);
            if (flag) {
                return i;
            }
        }
        return unit.GetActionList().size();
    }

    private boolean _PickUpTarget(FEMapElement elem, ArrayList<FEMapElement> enemies, boolean isTargetPriority, FEUnitAction action) {
        FEMapElement enemyElem;
        FEUnit enemy;
        JsonObject json;
        int x, y, prm;
        ArrayList<FEMapElement> candidate = new ArrayList<FEMapElement>();
        // 候補をピックアップする
        for (int i=0; i<enemies.size(); i++) {
            enemyElem = enemies.get(i);
            enemy = (FEUnit)enemyElem.GetMapObject();
            x = (int)enemyElem.GetPosition().x;
            y = (int)enemyElem.GetPosition().y;
            if (!(isTargetPriority || elem.GetAttackRange()[y][x])) continue;
            switch(action.GetActionID()) {
            case FEConst.BATTLE_AI_NO_MARK:
                if (!isTargetPriority) {
                    candidate.add(enemyElem);
                }
                break;
            case FEConst.BATTLE_AI_UNIT:
                json = action.GetActionParameter();
                if (json != null) {
                    prm = json.GetInt("ID", FEConst.NOT_FOUND);
                    if (prm == enemy.GetID()) {
                        candidate.add(enemyElem);
                    }
                }
                break;
            case FEConst.BATTLE_AI_IMPORTANCE:
                json = action.GetActionParameter();
                if (json != null) {
                    prm = FEConst.NOT_FOUND;
                    switch(json.GetString("Importance", null)) {
                    case "LEADER":
                        prm = FEConst.UNIT_IMPORTANCE_LEADER;
                        break;
                    case "SUB LEADER":
                        prm = FEConst.UNIT_IMPORTANCE_SUB_LEADER;
                        break;
                    case "NORMAL":
                        prm = FEConst.UNIT_IMPORTANCE_NORMAL;
                        break;
                    }
                    if (prm == enemy.GetImportance()) {
                        candidate.add(enemyElem);
                    }
                }
                break;
            case FEConst.BATTLE_AI_NO_MOVE:
                // 行動しないのは特例なので、候補を上げないまま返す
                action.SetTarget(null);
                return true;
            }
        }
        if (candidate.isEmpty()) {
            action.SetTarget(null);
            return false;
        } else if (candidate.size() == 1) {
            action.SetTarget(candidate.get(0));
            return true;
        }
        // 複数該当する場合は最も高い期待値を持つユニットを採用する
        int id = 0;
        float maxValue = -999999, value;
        for (int i=0; i<candidate.size(); i++) {
            enemyElem = candidate.get(i);
            PredictBattle(elem, enemyElem, true);
            value = _GetExpectedValue(elem, enemyElem);
            if (value >= maxValue) {
                maxValue = value;
                id = i;
            }
        }
        action.SetTarget(candidate.get(id));
        return true;
    }

    private float _GetExpectedValue(FEMapElement atk, FEMapElement def) {
        boolean phase = true;
        float expected = 0, temp;
        int atkRem, atkAtkNum, atkHp, defRem, defAtkNum, defHp;
        FEUnitBattleParameter atkB, defB;

        atkRem = _remainAttackerChance;
        atkAtkNum = _attackerAttackNum;
        defRem = _remainDefenderChance;
        defAtkNum = _defenderAttackNum;
        atkHp = ((FEUnit)(atk.GetMapObject())).GetHp();
        defHp = ((FEUnit)(def.GetMapObject())).GetHp();
        atkB = ((FEUnit)(atk.GetMapObject())).GetBattleParameter();
        defB = ((FEUnit)(def.GetMapObject())).GetBattleParameter();
        // 射程範囲外から攻撃できる場合は相手の行動チャンス数を0にする
        if (!_IsIncludeRange(defB.GetMinRange(), defB.GetMaxRange(), atkB.GetMinRange()) || !_IsIncludeRange(defB.GetMinRange(), defB.GetMaxRange(), atkB.GetMaxRange())) {
            defRem = 0;
        }
        while (true) {
            if (phase) {
                temp = (int)(_defenderValue.GetPower() * atkAtkNum * _attackerValue.GetAccuracy()/100f * (_attackerValue.GetCritical()/50f + 1));
                if (defHp - temp <= 0) {
                    return 999999;
                }
                defHp -= temp;
                expected += temp;
                atkRem--;
                if (atkRem <= 0 && defRem <= 0) {
                    return expected;
                }
                phase = defRem <= 0;
            } else {
                temp = (int)(_attackerValue.GetPower() * defAtkNum * _defenderValue.GetAccuracy()/100f * (_defenderValue.GetCritical()/50f + 1));
                if (atkHp - temp <= 0) {
                    return -999999;
                }
                atkHp -= temp;
                expected -= temp;
                defRem--;
                if (atkRem <= 0 && defRem <= 0) {
                    return expected;
                }
                phase = atkRem > 0;
            }
        }
    }

    private boolean _IsIncludeRange(int a, int b, int c) {
        return a <= c && c <= b;
    }

    /**
     攻撃する座標を決定する。
     */
    private void _DeceideAttackPosition(FEMapElement elem, FEMapElement target) {
        FEOtherUnit unit;
        FEUnit tarUnit;
        FEUnitBattleParameter unitBP, tarUnitBP;
        FETerrainEffect terE;
        int x, y, posX, posY, maxValue;

        unit = (FEOtherUnit)elem.GetMapObject();
        tarUnit = (FEUnit)target.GetMapObject();
        unitBP = unit.GetBattleParameter();
        tarUnitBP = tarUnit.GetBattleParameter();
        x = (int)target.GetPosition().x;
        y = (int)target.GetPosition().y;

        _ClearIntegerArray(_rangeProfitDistribution);
        // 敵の位置から自身の射程範囲のところを加算する
        _AddRangeDistribution(x, y, unitBP.GetMaxRange(), unitBP.GetMinRange(), 10);
        // 敵のその場の射程範囲のところを減算する
        _AddRangeDistribution(x, y, tarUnitBP.GetMaxRange(), tarUnitBP.GetMinRange(), -5);
        posX = posY = -1;
        maxValue = -1;
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                if (!elem.GetActionRange()[i][j]) continue;   
                if (GetMapElementOnPos(j, i) != null) continue;
                terE = feManager.GetDataBase().GetTerrainEffects().get(_terrains[i][j].GetEffectID());
                if (terE != null && !terE.IsMovable()) continue;
                _rangeProfitDistribution[i][j] += _terrainEffectBias[i][j] + unit.GetUnitProfitDistribution()[i][j];                
                if (maxValue <= _rangeProfitDistribution[i][j]) {
                    posY = i;
                    posX = j;
                    maxValue = _rangeProfitDistribution[i][j];
                }
            }
        }
        unit.GetGotoPos().x = posX;
        unit.GetGotoPos().y = posY;
        unit.GetAttackPos().x = target.GetPosition().x;
        unit.GetAttackPos().y = target.GetPosition().y;
        println("GO :", unit.GetGotoPos());
        println("ARK:", unit.GetAttackPos());
    }

    /**
     最も近い敵に近づく。
     */
    private void _DecideNearestPosition(FEMapElement elem, ArrayList<FEMapElement> enemies) {
        // 最も近い敵を選出する
        FEMapElement enemyElem;
        float x, y, dist, minDist = 1000;
        int idx = 0;
        FEOtherUnit unit = (FEOtherUnit)elem.GetMapObject();
        FETerrainEffect terE;
        if (!enemies.isEmpty()) {
            for (int i=0; i<enemies.size(); i++) {
                enemyElem = enemies.get(i);
                x = elem.GetPosition().x - enemyElem.GetPosition().x;
                y = elem.GetPosition().y - enemyElem.GetPosition().y;
                dist = abs(x) + abs(y);
                if (minDist >= dist) {
                    minDist = dist;
                    idx = i;
                }
            }
            enemyElem = enemies.get(idx);

            int posX, posY, i, j;
            float dirX, dirY;
            posX = posY = -1;
            dirX = enemyElem.GetPosition().x - elem.GetPosition().x;
            dirY = enemyElem.GetPosition().y - elem.GetPosition().y;
            _ClearIntegerArray(_rangeProfitDistribution);
            while (true) {
                i = (int)random(0, _mapHeight);
                j = (int)random(0, _mapWidth);
                if (!elem.GetActionRange()[i][j]) continue;   
                if (GetMapElementOnPos(j, i) != null) continue;
                terE = feManager.GetDataBase().GetTerrainEffects().get(_terrains[i][j].GetEffectID());
                if (terE != null && !terE.IsMovable()) continue;
                if ((i - elem.GetPosition().y) * dirY >= 0 && (j - elem.GetPosition().x) * dirX >= 0) {
                    posY = i;
                    posX = j;
                    break;
                }
            }
            unit.GetGotoPos().x = posX;
            unit.GetGotoPos().y = posY;
            unit.GetAttackPos().x = -1;
            unit.GetAttackPos().y = -1;
        } else {
            unit.GetGotoPos().x = elem.GetPosition().x;
            unit.GetGotoPos().y = elem.GetPosition().y;
            unit.GetAttackPos().x = -1;
            unit.GetAttackPos().y = -1;
        }
        println("?GO :", unit.GetGotoPos());
        println("?ARK:", unit.GetAttackPos());
    }

    private void _AddRangeDistribution(int x, int y, int maxR, int minR, int value) {
        int r;
        for (int i=-maxR; i<=maxR; i++) {
            r = maxR - abs(i);
            for (int j=-r; j<=r; j++) {
                if (abs(i) + abs(j) >= minR) {
                    if (!IsInMap(x + j, y + i)) continue;
                    _rangeProfitDistribution[y+i][x+j] += value;
                }
            }
        }
    }
}

public class FEJsonUtility {
    /**
     パラメータに変更の可能性があるため退避処理を設けている。
     */
    public void LoadFEData(FEData data, JsonObject json) throws Exception {
        if (data == null || json == null) return;
        String value;
        int id;
        value = json.GetString("Name", null);
        if (value != null) {
            data.SetName(value);
        }
        value = json.GetString("Explain", null);
        if (value != null) {
            data.SetExplain(value);
        }
        id = json.GetInt("ID", FEConst.NOT_FOUND);
        if (id != FEConst.NOT_FOUND) {
            data.SetID(id);
        } else {
            dialog.Show("エラー", "IDが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadTerrainEffect(FETerrainEffect efc, JsonObject json) throws Exception {
        if (efc == null || json == null) return;
        LoadFEData(efc, json);
        efc.SetAvoid(json.GetInt("Avoid", 0));
        efc.SetDefense(json.GetInt("Defense", 0));
        efc.SetMDefense(json.GetInt("MDefense", 0));
        efc.SetRecover(json.GetInt("Recover", 0));
        efc.GetMoveConts().put(FEConst.CLASS_TYPE_NORMAL, json.GetInt("NORMAL", 1));
        efc.GetMoveConts().put(FEConst.CLASS_TYPE_SORCERER, json.GetInt("SORCERER", 1));
        efc.GetMoveConts().put(FEConst.CLASS_TYPE_ARMOR, json.GetInt("ARMOR", 1));
        efc.GetMoveConts().put(FEConst.CLASS_TYPE_RIDER, json.GetInt("RIDER", 1));
        efc.GetMoveConts().put(FEConst.CLASS_TYPE_FLYER, json.GetInt("FLYER", 1));
        efc.SetMovable(json.GetBoolean("Is Movable", true));
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadTerrain(FETerrain ter, JsonObject json) throws Exception {
        if (ter == null || json == null) return;
        LoadFEData(ter, json);
        ter.SetEffectID(json.GetInt("Effect ID", 0));
        ter.SetMapImagePath(json.GetString("Map Image Path", null));
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadWeaponClass(FEWeaponClass wpc, JsonObject json) throws Exception {
        if (wpc == null || json == null) return;
        LoadFEData(wpc, json);
        wpc.SetIconImagePath(json.GetString("Icon Image Path", null));
        switch(json.GetString("Weapon Type", "NO TYPE")) {
        case "FIGHTER":
            wpc.SetWeaponType(FEConst.WEAPON_TYPE_FIGHTER);
            break;
        case "SORCERER":
            wpc.SetWeaponType(FEConst.WEAPON_TYPE_SORCERER);
            break;
        case "ARCHER":
            wpc.SetWeaponType(FEConst.WEAPON_TYPE_ARCHER);
            break;
        default:
            dialog.Show("エラー", "武器タイプが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
        wpc.SetWearOnHit(json.GetBoolean("Is Wear On Hit", true));
        JsonArray array = json.GetJsonArray("Compatibility");
        if (array != null) {
            FEWeaponCompatibility comp;
            for (int i=0; i<array.Size(); i++) {
                comp = new FEWeaponCompatibility();
                LoadWeaponCompatibility(comp, array.GetJsonObject(i));
                wpc.GetCompatibility().put(comp.GetWeaponClassID(), comp);
            }
        }
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadWeaponCompatibility(FEWeaponCompatibility wcm, JsonObject json) throws Exception {
        if (wcm == null || json == null) return;
        wcm.SetBadCompatibility(json.GetBoolean("Is Bad Compatibility", false));
        int value = json.GetInt("Weapon Class ID", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            wcm.SetWeaponClassID(value);
        } else {
            dialog.Show("エラー", "武器タイプIDが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
        LoadUnitBattleParameter(wcm.GetCorrect(), json.GetJsonObject("Correct"));
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadUnitParameter(FEUnitParameter prm, JsonObject json) {
        if (prm == null || json == null) return;
        int value;
        value = json.GetInt("HP", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetHp(value);
        }
        value = json.GetInt("ATK", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetAtk(value);
        }
        value = json.GetInt("MAT", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMat(value);
        }
        value = json.GetInt("TEC", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetTec(value);
        }
        value = json.GetInt("SPD", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetSpd(value);
        }
        value = json.GetInt("LUC", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetLuc(value);
        }
        value = json.GetInt("DEF", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetDef(value);
        }
        value = json.GetInt("MDF", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMdf(value);
        }
        value = json.GetInt("MOV", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMov(value);
        }
        value = json.GetInt("PRO", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetPro(value);
        }
    }

    /**
     省略されたパラメータに代入しないよう退避処理を設けている。
     */
    public void LoadUnitBattleParameter(FEUnitBattleParameter prm, JsonObject json) {
        if (prm == null || json == null) return;
        int value;
        value = json.GetInt("Power", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetPower(value);
        }
        String pType = json.GetString("Power Type", null);
        if (pType != null) {
            switch(pType) {
            case "PHYSICS":
                prm.SetPowerType(FEConst.WEAPON_POWER_PHYSICS);
                break;
            case "MAGIC":
                prm.SetPowerType(FEConst.WEAPON_POWER_PHYSICS);
                break;
            case "UNKNOWN":
                prm.SetPowerType(FEConst.WEAPON_POWER_PHYSICS);
                break;
            default:
                prm.SetPowerType(FEConst.NOT_FOUND);
                break;
            }
        }
        value = json.GetInt("Defense", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetDefense(value);
        }
        value = json.GetInt("MDefense", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMDefense(value);
        }
        value = json.GetInt("Accuracy", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetAccuracy(value);
        }
        value = json.GetInt("Avoid", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetAvoid(value);
        }
        value = json.GetInt("Critical", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetCritical(value);
        }
        value = json.GetInt("Critical Avoid", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetCriticalAvoid(value);
        }
        value = json.GetInt("Min Range", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMinRange(value);
        }
        value = json.GetInt("Max Range", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            prm.SetMaxRange(value);
        }
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadState(FEState state, JsonObject json) throws Exception {
        if (state == null || json == null) return;
        LoadFEData(state, json);
        state.SetIconImagePath(json.GetString("Icon Image Path", null));
        state.SetMapImagePath(json.GetString("Map Image Path", null));
        state.SetBadState(json.GetBoolean("Is Bad State", false));
        state.SetSustainTurn(json.GetInt("Sustain Turn", 0));
        state.SetRecoverOnTimes(json.GetInt("Recover", 0));
        JsonArray array = json.GetJsonArray("Sealed Options");
        if (array != null) {
            int[] sealed = new int[array.Size()];
            for (int i=0; i<array.Size(); i++) {
                switch(array.GetString(i, "NO OPTION")) {
                case "PHYSICS":
                    sealed[i] = FEConst.STATE_SEALED_PHYSICS;
                    break;
                case "MAGIC":
                    sealed[i] = FEConst.STATE_SEALED_MAGIC;
                    break;
                case "CANE":
                    sealed[i] = FEConst.STATE_SEALED_CANE;
                    break;
                case "ITEM":
                    sealed[i] = FEConst.STATE_SEALED_ITEM;
                    break;
                }
            }
            state.SetSealedOption(sealed);
        }
        switch(json.GetString("Act Option", "NONE")) {
        case "NONE":
            state.SetActOption(FEConst.STATE_ACT_NONE);
            break;
        case "INACTIVITY":
            state.SetActOption(FEConst.STATE_ACT_INACTIVITY);
            break;
        case "RUNWILDLY":
            state.SetActOption(FEConst.STATE_ACT_RUNWILDLY);
            break;
        case "AI":
            state.SetActOption(FEConst.STATE_ACT_AI);
            break;
        }
        switch(json.GetString("Release Option", "NONE")) {
        case "NONE":
            state.SetReleaseOption(FEConst.STATE_RELEASE_NONE);
            break;
        case "BATTLE":
            state.SetReleaseOption(FEConst.STATE_RELEASE_BATTLE);
            break;
        case "ATTACK":
            state.SetReleaseOption(FEConst.STATE_RELEASE_ATTACK);
            break;
        case "BE ATTACKED":
            state.SetReleaseOption(FEConst.STATE_RELEASE_BE_ATTACKED);
            break;
        }
        state.SetReleaseParameter(json.GetInt("Release Parameter", 0));
        LoadUnitParameter(state.GetParameterBonus(), json.GetJsonObject("Parameter Bonus"));
        array = json.GetJsonArray("Granted Skills");
        if (array != null) {
            int[] skills = new int[array.Size()];
            for (int i=0; i<array.Size(); i++) {
                skills[i] = array.GetInt(i, -1);
            }
            state.SetGrantedSkills(skills);
        }
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadSkill(FESkill skill, JsonObject json) throws Exception {
        if (skill == null || json == null) return;
        LoadFEData(skill, json);
        skill.SetIconImagePath(json.GetString("Icon Image Path", null));
        switch(json.GetString("Activate Ref", "UNIQUE")) {
        case "HP":
            skill.SetActivateReference(FEConst.REF_HP);
            break;
        case "ATK":
            skill.SetActivateReference(FEConst.REF_ATK);
            break;
        case "MAT":
            skill.SetActivateReference(FEConst.REF_MAT);
            break;
        case "TEC":
            skill.SetActivateReference(FEConst.REF_TEC);
            break;
        case "SPD":
            skill.SetActivateReference(FEConst.REF_SPD);
            break;
        case "LUC":
            skill.SetActivateReference(FEConst.REF_LUC);
            break;
        case "DEF":
            skill.SetActivateReference(FEConst.REF_DEF);
            break;
        case "MDF":
            skill.SetActivateReference(FEConst.REF_MDF);
            break;
        case "MOV":
            skill.SetActivateReference(FEConst.REF_MOV);
            break;
        case "PRO":
            skill.SetActivateReference(FEConst.REF_PRO);
            break;
        default:
            skill.SetActivateReference(FEConst.REF_UNI);
            break;
        }
        skill.SetUniqueActivateRate(json.GetInt("Unique Activate Rate", 0));
        switch(json.GetString("Feature", "NONE")) {
        case "PREEMPTIVE":
            skill.SetSkillFeature(FEConst.SKILL_FET_PREEMPTIVE);
            break;
        default:
            skill.SetSkillFeature(FEConst.SKILL_FET_NONE);
            break;
        }
        skill.SetSkillFeatureParameter(json.GetJsonObject("Feature Parameter"));
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadItemBase(FEItemBase ib, JsonObject json) throws Exception {
        if (ib == null || json == null) return;
        LoadFEData(ib, json);
        ib.SetIconImagePath(json.GetString("Icon Image Path", null));
        ib.SetEffectImagePath(json.GetString("Effect Image Folder Path", null));
        ib.SetPrice(json.GetInt("Price", 0));
        ib.SetWeight(json.GetInt("Weight", 0));
        ib.SetEndurance(json.GetInt("Endurance", 0));
        ib.SetSalable(json.GetBoolean("Is Salable", false));
        ib.SetImportant(json.GetBoolean("Is Important", false));
        ib.SetExchangeable(json.GetBoolean("Is Exchangeable", false));
        LoadUnitParameter(ib.GetParameterBonus(), json.GetJsonObject("Parameter Bonus"));
        LoadUnitParameter(ib.GetGrowthBonus(), json.GetJsonObject("Growth Rate Bonus"));
        JsonArray array = json.GetJsonArray("Granted Skills");
        if (array != null) {
            int[] skills = new int[array.Size()];
            for (int i=0; i<array.Size(); i++) {
                skills[i] = array.GetInt(i, -1);
            }
            ib.SetGrantedSkills(skills);
        }
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadItem(FEItem item, JsonObject json) throws Exception {
        if (item == null || json == null) return;
        LoadItemBase(item, json);
        item.SetCane(json.GetBoolean("Is Cane", false));
        item.SetGainExp(json.GetInt("Gain Exp", 0));
        switch(json.GetString("Range", "OWN")) {
        case "OWN":
            item.SetRange(FEConst.ITEM_RANGE_OWN);
            break;
        case "REGION":
            item.SetRange(FEConst.ITEM_RANGE_REGION);
            break;
        case "ALL":
            item.SetRange(FEConst.ITEM_RANGE_ALL);
            break;
        }
        JsonObject option = json.GetJsonObject("Range Option");
        if (option != null) {
            switch(option.GetString("Range Ref", "UNIQUE")) {
            case "HP":
                item.SEtRangeRef(FEConst.REF_HP);
                break;
            case "ATK":
                item.SEtRangeRef(FEConst.REF_ATK);
                break;
            case "MAT":
                item.SEtRangeRef(FEConst.REF_MAT);
                break;
            case "TEC":
                item.SEtRangeRef(FEConst.REF_TEC);
                break;
            case "SPD":
                item.SEtRangeRef(FEConst.REF_SPD);
                break;
            case "LUC":
                item.SEtRangeRef(FEConst.REF_LUC);
                break;
            case "DEF":
                item.SEtRangeRef(FEConst.REF_DEF);
                break;
            case "MDF":
                item.SEtRangeRef(FEConst.REF_MDF);
                break;
            case "MOV":
                item.SEtRangeRef(FEConst.REF_MOV);
                break;
            case "PRO":
                item.SEtRangeRef(FEConst.REF_PRO);
                break;
            default:
                item.SEtRangeRef(FEConst.REF_UNI);
                break;
            }
            item.SetRefRate(option.GetFloat("Ref Rate", 0));
            item.SetUniqueRange(option.GetInt("Unique Range", 0));
        }
        switch(json.GetString("Filter", "OWN")) {
        default:
            item.SetFilter(FEConst.ITEM_FILTER_OWN);
            break;
        case "OTHER":
            item.SetFilter(FEConst.ITEM_FILTER_OWN);
            break;
        }
        switch(json.GetString("Item Feature", "NONE")) {
        default:
            item.SetItemFeature(FEConst.ITEM_FET_NONE);
            break;
        case "RECOVER HP":
            item.SetItemFeature(FEConst.ITEM_FET_RECOVER_HP);
            break;
        }
        item.SetItemFeatureParameter(json.GetJsonObject("Item Feature Parameter"));
    }

    public void LoadWeapon(FEWeapon wep, JsonObject json) throws Exception {
        if (wep == null || json == null) return;
        LoadItemBase(wep, json);
        int value = json.GetInt("Weapon Class ID", FEConst.NOT_FOUND);
        if (value != FEConst.NOT_FOUND) {
            wep.SetWeaponClassID(value);
        } else {
            dialog.Show("エラー", "武器タイプIDが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
        switch(json.GetString("Power Type", "PHYSICS")) {
        default:
            wep.SetPowerType(FEConst.WEAPON_POWER_PHYSICS);
            break;
        case "MAGIC":
            wep.SetPowerType(FEConst.WEAPON_POWER_MAGIC);
            break;
        case "UNKNOWN":
            wep.SetPowerType(FEConst.WEAPON_POWER_UNKNOWN);
            break;
        }
        wep.SetPower(json.GetInt("Power", 0));
        wep.SetMinRange(json.GetInt("Min Range", 0));
        wep.SetMaxRange(json.GetInt("Max Range", 0));
        wep.SetAccuracy(json.GetInt("Accuracy", 0));
        wep.SetCritical(json.GetInt("Critical", 0));
        wep.SetAttackNum(json.GetInt("Attack Num", 0));
        wep.SetWearableProficiency(json.GetInt("Wearable Proficiency", 0));
        JsonArray array = json.GetJsonArray("Special Attacks");
        if (array != null) {
            int[] sp = new int[array.Size()];
            for (int i=0; i<array.Size(); i++) {
                switch(array.GetString(i, "NONE")) {
                case "SORCERER":
                    sp[i] = FEConst.CLASS_TYPE_SORCERER;
                    break;
                case "ARMOR":
                    sp[i] = FEConst.CLASS_TYPE_ARMOR;
                    break;
                case "RIDER":
                    sp[i] = FEConst.CLASS_TYPE_RIDER;
                    break;
                case "FLYER":
                    sp[i] = FEConst.CLASS_TYPE_FLYER;
                    break;
                }
            }
            wep.SetSpecialAttack(sp);
        }
        array = json.GetJsonArray("Granting States");
        if (array != null) {
            JsonObject state;
            for (int i=0; i<array.Size(); i++) {
                state = array.GetJsonObject(i);
                if (state == null) continue;
                wep.GetGrantingStates().put(state.GetInt("State ID", FEConst.NOT_FOUND), state.GetInt("Accuracy", 0));
            }
        }
    }

    public void LoadClass(FEClass cls, JsonObject json) throws Exception {
        if (cls == null || json == null) return;
        LoadFEData(cls, json);
        cls.SetFaceImagePath(json.GetString("Face Image Path", null));
        cls.SetMapImageFolderPath(json.GetString("Map Image Folder Path", null));
        switch(json.GetString("Class Type", "NONE")) {
        case "NORMAL":
            cls.SetClassType(FEConst.CLASS_TYPE_NORMAL);
            break;
        case "SORCERER":
            cls.SetClassType(FEConst.CLASS_TYPE_SORCERER);
            break;
        case "ARMOR":
            cls.SetClassType(FEConst.CLASS_TYPE_ARMOR);
            break;
        case "RIDER":
            cls.SetClassType(FEConst.CLASS_TYPE_RIDER);
            break;
        case "FLYER":
            cls.SetClassType(FEConst.CLASS_TYPE_FLYER);
            break;
        default:
            dialog.Show("エラー", "不正なクラスタイプが設定されているデータがあります。\njson = " + json);
            throw new Exception();
        }
        cls.SetConsiderTileEffect(json.GetBoolean("Is Consider Tile Effect", true));
        cls.SetUseCane(json.GetBoolean("Can Use Cane", false));
        cls.SetAdvancedClass(json.GetBoolean("Is Advanced Class", false));
        LoadUnitParameter(cls.GetChangeBonus(), json.GetJsonObject("Class Change Bonus"));
        LoadUnitParameter(cls.GetGrowthBonus(), json.GetJsonObject("Growth Rate Bonus"));
        LoadUnitParameter(cls.GetGrowthLimit(), json.GetJsonObject("Growth Limit"));
        LoadUnitBattleParameter(cls.GetBattleParameter(), json.GetJsonObject("Battle Parameter"));
        JsonArray array = json.GetJsonArray("Learnable Skills");
        if (array != null) {
            JsonObject skill;
            int id;
            for (int i=0; i<array.Size(); i++) {
                skill = array.GetJsonObject(i);
                if (skill == null) continue;
                id = skill.GetInt("Skill ID", FEConst.NOT_FOUND);
                if (id != FEConst.NOT_FOUND) {
                    cls.GetLearnabeSkills().put(id, skill.GetInt("Level", FEConst.NOT_FOUND));
                } else {
                    dialog.Show("エラー", "スキルIDが設定されていないデータがあります。\njson = " + json);
                    throw new Exception();
                }
            }
        }
    }

    public void LoadUnit(FEUnit unit, JsonObject json) throws Exception {
        if (unit == null || json == null) return;
        LoadFEData(unit, json);
        unit.SetOrganization(json.GetString("Organization", "無所属"));
        int classID = json.GetInt("Class ID", FEConst.NOT_FOUND);
        if (classID != FEConst.NOT_FOUND) {
            unit.SetUnitClassID(classID);
        } else {
            dialog.Show("エラー", "クラスIDが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
        String value;
        FEClass unitClass;
        value = json.GetString("Face Image Path", null);
        if (value != null) {
            unit.SetFaceImagePath(value);
        } else {
            unitClass = feManager.GetDataBase().GetUnitClasses().get(classID);
            if (unitClass != null && unitClass.GetFaceImagePath() != null) {
                unit.SetFaceImagePath(unitClass.GetFaceImagePath());
            } else {
                dialog.Show("エラー", "フェイスグラフィックスパスがユニットデータにも\nクラスデータにも設定されていないデータがあります。\njson = " + json);
                throw new Exception();
            }
        }
        value = json.GetString("Map Image Folder Path", null);
        if (value != null) {
            unit.SetMapImageFolderPath(value);
        } else {
            unitClass = feManager.GetDataBase().GetUnitClasses().get(classID);
            if (unitClass != null && unitClass.GetMapImageFolderPath() != null) {
                unit.SetMapImageFolderPath(unitClass.GetMapImageFolderPath());
            } else {
                dialog.Show("エラー", "マップグラフィックスフォルダパスがユニットデータにも\nクラスデータにも設定されていないデータがあります。\njson = " + json);
                throw new Exception();
            }
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
        unit.SetLevel(json.GetInt("Level", -1));
        unit.SetHp(json.GetInt("HP", -1));
        unit.SetExp(json.GetInt("Exp", -1));
        LoadUnitParameter(unit.GetBaseGrowthRate(), json.GetJsonObject("Growth Rate"));
        LoadUnitParameter(unit.GetBaseParameter(), json.GetJsonObject("Parameter"));
        JsonArray array = json.GetJsonArray("Skills");
        if (array != null) {
            int id;
            for (int i=0; i<array.Size(); i++) {
                id = array.GetInt(i, FEConst.NOT_FOUND);
                if (id != FEConst.NOT_FOUND) {
                    unit.GetLearnSkillList().add(id);
                } else {
                    dialog.Show("エラー", "スキルIDが設定されていないデータがあります。\njson = " + json);
                    throw new Exception();
                }
            }
        }
        array = json.GetJsonArray("Item List");
        if (array != null) {
            unit.GetItemList().clear();
            JsonObject item;
            FEActualItem actItem;
            for (int i=0; i<array.Size(); i++) {
                item = array.GetJsonObject(i);
                if (item == null) continue;
                actItem = feManager.GetDataBase().CreateItem(item.GetInt("ID", FEConst.NOT_FOUND), item.GetBoolean("Is Item", true));
                actItem.SetEndurance(item.GetInt("Endurance", 0));
                actItem.SetExchangeable(item.GetBoolean("Is Exchangeable", true));
                unit.GetItemList().add(actItem);
            }
        }
        int idx = json.GetInt("Equip Weapon Index", FEConst.NOT_FOUND);
        if (idx != FEConst.NOT_FOUND) {
            unit.SetEquipWeapon(unit.GetItemList().get(idx));
        }
    }

    public void LoadOtherUnit(FEOtherUnit unit, JsonObject json) throws Exception {
        if (unit == null || json == null) return;
        LoadUnit(unit, json);
    }
}