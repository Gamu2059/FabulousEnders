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
            battleMapManager.LoadSavingData(path);
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
    /**
     マップ名
     */
    private String _mapName;
    public String GetMapName() {
        return _mapName;
    }

    /**
     マップ背景パス
     */
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

    /**
     マップデータを読み込んだ直後に出撃準備を開始するかどうか
     */
    private boolean _isImmediatelySortie;
    public boolean IsImmediatelySortie() {
        return _isImmediatelySortie;
    }

    /**
     出撃準備を飛ばすかどうか
     */
    private boolean _isSkipPreparation;
    public boolean IsSkipPreparation() {
        return _isSkipPreparation;
    }

    /**
     プレイヤーが先攻かどうか
     */
    private boolean _isFirstPhase;
    public boolean IsFirstPhase() {
        return _isFirstPhase;
    }

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
     */
    private int _operationMode;
    public int GetOperationMode() {
        return _operationMode;
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
     現在カーソルで重ねられているマップエレメント
     */
    private FEMapElement _overlappedElement;
    public FEMapElement GetOverlappedElement() {
        return _overlappedElement;
    }

    /**
     現在カーソルで重ねられているユニット
     */
    private FEUnit _overlappedUnit;
    public FEUnit GetOverlappedUnit() {
        return _overlappedUnit;
    }

    /**
     現在選択中のマップエレメント
     */
    private FEMapElement _selectedElement;
    public FEMapElement GetSelectedElement() {
        return _selectedElement;
    }

    /**
     現在選択中のユニット
     */
    private FEUnit _selectedUnit;
    public FEUnit GetSelectedUnit() {
        return _selectedUnit;
    }

    /**
     選択中のユニットの移動ルート
     */
    private ArrayList<PVector> _unitRoute;
    public ArrayList<PVector> GetUnitRoute() {
        return _unitRoute;
    }

    /**
     現在移動しているユニットの元の座標
     */
    private PVector _basePosOfMovingUnit;
    public PVector GetBasePosOfMovingUnit() {
        return _basePosOfMovingUnit;
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
     マップ上のプレイヤーユニットの存在情報
     */
    private ArrayList<FEMapElement> _mapPlayerObjects;
    public ArrayList<FEMapElement> GetMapPlayerObjects() {
        return _mapPlayerObjects;
    }

    /**
     マップ上の敵ユニットの存在情報
     */
    private ArrayList<FEMapElement> _mapEnemyObjects;
    public ArrayList<FEMapElement> GetMapEnemyObjects() {
        return _mapEnemyObjects;
    }

    /**
     マップ上にいるユニットやイベントの存在情報
     */
    private ArrayList<FEMapElement> _mapElements;
    public ArrayList<FEMapElement> GetMapElements() {
        return _mapElements;
    }

    /**
     描画順序を考慮するために用意
     */
    private Collection<FEMapElement> _elementSorter;

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
        _mapWidth = _mapHeight = 0;

        _basePosOfMovingUnit = new PVector();
        _elapsedTurn = 0;

        _sortieUnits = new ArrayList<FEUnit>();
        _enemyUnits = new HashMap<Integer, FEOtherUnit>();
        _sortieEnemyUnits = new ArrayList<FEOtherUnit>();
        _events = new ArrayList<FEMapObject>();

        _terrains = new FETerrain[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _hazardAreas = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];
        _actionRanges = new int[FEConst.SYSTEM_MAP_MAX_HEIGHT][FEConst.SYSTEM_MAP_MAX_WIDTH];

        _mapPlayerObjects = new ArrayList<FEMapElement>();
        _mapEnemyObjects = new ArrayList<FEMapElement>();
        _mapElements = new ArrayList<FEMapElement>();
        _elementSorter = new Collection<FEMapElement>();

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
                    id = terrainObj.GetInt("ID", -99999);
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
                    elem = new FEMapElement();
                    elem.GetPosition().x = x;
                    elem.GetPosition().y = y;
                    unit = fePm.GetPlayerUnitOnID(playerPosition.GetInt("ID", -99999));
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
                FEProgressManager fePm = feManager.GetProgressDataBase();
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
                    elem = new FEMapElement();
                    elem.GetPosition().x = x;
                    elem.GetPosition().y = y;
                    unit = _enemyUnits.get(enemyPosition.GetInt("ID", -99999));
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
    public void LoadSavingData(String dataPath) {
    }

    /**
     出撃準備に突入する。
     スキップフラグが立っている場合は、準備を飛ばして戦闘を開始する。
     */
    public void PrepareSortie() {
        if (_isSkipPreparation) {
            StartSortie();
            return;
        }

        _sortieMode = FEConst.BATTLE_SORTIE_MODE_IN_PREPARATION;
    }

    /**
     戦闘を開始する。
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

        // ユニットの行動範囲を更新
        for (int i=0; i<_mapPlayerObjects.size(); i++) {
            _UpdateSelfActionRange(_mapPlayerObjects.get(i));
        }
        for (int i=0; i<_mapEnemyObjects.size(); i++) {
            _UpdateSelfActionRange(_mapEnemyObjects.get(i));
        }

        _sortieMode = FEConst.BATTLE_SORTIE_MODE_SORTIE;
        _operationMode = FEConst.BATTLE_OPE_MODE_NORMAL;
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
                    _UpdateOverallActionRange(elem);
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
        FEMapElement elem = GetMapElementOnPos(x, y);
        boolean isLeft = mouseButton == LEFT;
        switch(_operationMode) {
        case FEConst.BATTLE_OPE_MODE_NORMAL:
            if (isLeft) {
                if (elem == null) return;
                FEMapObject mapObj = elem.GetMapObject();
                if (!(mapObj instanceof FEUnit)) return;
                if (_mapPlayerObjects.contains(elem)) {
                    _operationMode = FEConst.BATTLE_OPE_MODE_ACTIVE;
                    _selectedUnit = (FEUnit)mapObj;
                    _selectedElement = elem;
                    _selectedElement.SetRunning(true);
                } else if (_mapEnemyObjects.contains(elem)) {
                    elem.SetDrawHazardAreas(!elem.IsDrawHazardAres());
                    _UpdateOverallHazardArea();
                }
            } else {
            }
            break;
        case FEConst.BATTLE_OPE_MODE_ACTIVE:
            if (isLeft) {
                if (IsInMap(x, y) && _actionRanges[y][x] == FEConst.BATTLE_MAP_MARKER_ACTION) {
                    FEClass unitClass = feManager.GetDataBase().GetUnitClasses().get(_selectedUnit.GetUnitClassID());
                    if (unitClass == null) {
                        _SetToNormalMode();
                        break;
                    }
                    PVector baseP = _selectedElement.GetPosition();
                    _unitRoute = _MakeRouteToAimPosition(_selectedElement, unitClass.GetClassType(), x, y, (int)baseP.x, (int)baseP.y, _selectedUnit.GetBaseParameter().GetMobility());
                    if (_unitRoute == null) {
                        _SetToNormalMode();
                    } else {
                        _basePosOfMovingUnit.x = baseP.x;
                        _basePosOfMovingUnit.y = baseP.y;

                        // 冗長なルートをカットする
                        int idx1 = 0, idx2 = 0;
                        boolean flag;
                        PVector pos1, pos2;
                        while (true) {
                            flag = false;
                            for (int i=0; i<_unitRoute.size()-1; i++) {
                                pos1 = _unitRoute.get(i);
                                idx2 = -1;
                                for (int j=i+1; j<_unitRoute.size(); j++) {
                                    pos2 = _unitRoute.get(j);
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
                                    _unitRoute.remove(idx1);
                                }
                            } else {
                                break;
                            }
                        }
                        _operationMode = FEConst.BATTLE_OPE_MODE_MOVING;
                    }
                }
            } else {
                _SetToNormalMode();
            }
            break;
        case FEConst.BATTLE_OPE_MODE_FINISH_MOVE:
            if (isLeft) {
                _SetToNormalMode();
                _UpdateAllActionRange();
                _ClearIntegerArray(_actionRanges);
                _UpdateOverallActionRange(_selectedElement);
                _elementSorter.SortList(_mapElements);
            } else {
                _selectedElement.GetPosition().x = _basePosOfMovingUnit.x;
                _selectedElement.GetPosition().y = _basePosOfMovingUnit.y;
                _SetToNormalMode();
            }
            break;
        }
    }

    private void _SetToNormalMode() {
        _operationMode = FEConst.BATTLE_OPE_MODE_NORMAL;
        _selectedUnit = null;
        _selectedElement.SetRunning(false);
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
    private void _UpdateOverallActionRange(FEMapElement elem) {
        for (int i=0; i<_mapHeight; i++) {
            for (int j=0; j<_mapWidth; j++) {
                if (elem.GetActionRange()[i][j]) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_ACTION;
                } else if (elem.GetAttackRange()[i][j]) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_ATTACK;
                } else if (elem.GetCaneRange()[i][j]) {
                    _actionRanges[i][j] = FEConst.BATTLE_MAP_MARKER_CANE;
                }
            }
        }
    }

    /**
     自軍、敵軍全てのユニットの行動範囲を更新する。
     */
    private void _UpdateAllActionRange() {
        for (int i=0; i<_mapElements.size(); i++) {
            _UpdateSelfActionRange(_mapElements.get(i));
        }
    }

    /**
     指定したマップ要素の行動範囲マーカを更新する。
     */
    private void _UpdateSelfActionRange(FEMapElement elem) {
        if (elem == null) return;
        if (!(elem.GetMapObject() instanceof FEUnit)) return;
        FEUnit unit = (FEUnit)elem.GetMapObject();
        boolean isPlayerUnit;
        if (_sortieUnits.contains(unit)) {
            isPlayerUnit = true;
        } else if (_sortieEnemyUnits.contains(unit)) {
            isPlayerUnit = false;
        } else {
            return;
        }
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
        mov = unit.GetBaseParameter().GetMobility();
        minR = maxR = 0;
        FEActualItem aItem = unit.GetEquipWeapon();
        if (aItem != null) {
            FEWeapon wep = (FEWeapon)aItem.GetItem();
            minR = wep.GetMinRange();
            maxR = wep.GetMaxRange();
        }
        x = (int)elem.GetPosition().x;
        y = (int)elem.GetPosition().y;
        _SetRecursiveActionRange(elem, unitClass.GetClassType(), isPlayerUnit, x, y, mov, minR, maxR, 0);
    }

    private void _SetRecursiveActionRange(FEMapElement elem, int classType, boolean isPlayerUnit, int x, int y, int remain, int minR, int maxR, int caneR) {
        if (!IsInMap(x, y)) return;
        if (remain < 0) return;

        FETerrain ter = GetTerrains()[y][x];
        FETerrainEffect terE = feManager.GetDataBase().GetTerrainEffects().get(ter.GetEffectID());
        if (terE == null) return;
        if (!terE.IsMovable()) return;

        FEMapElement otherElem = GetMapElementOnPos(x, y);
        if (otherElem != null && otherElem.GetMapObject() instanceof FEUnit) {
            if (_sortieUnits.contains(otherElem.GetMapObject()) && !isPlayerUnit) return;
            if (_sortieEnemyUnits.contains(otherElem.GetMapObject()) && isPlayerUnit) return;
        }

        elem.GetActionRange()[y][x] = true;
        _SetRange(x, y, minR, maxR, elem.GetAttackRange());
        if (caneR > 0) {
            _SetRange(x, y, 1, caneR, elem.GetCaneRange());
        }

        int cost = terE.GetMoveConts().get(classType);
        _SetRecursiveActionRange(elem, classType, isPlayerUnit, x, y - 1, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, isPlayerUnit, x - 1, y, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, isPlayerUnit, x, y + 1, remain - cost, minR, maxR, caneR);
        _SetRecursiveActionRange(elem, classType, isPlayerUnit, x + 1, y, remain - cost, minR, maxR, caneR);
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
                    if (a < 0 || a >= target.length || b < 0 || b >= target[0].length) continue;
                    target[y+i][x+j] = true;
                }
            }
        }
    }

    private ArrayList<PVector> _MakeRouteToAimPosition(FEMapElement elem, int classType, int aimX, int aimY, int x, int y, int remain) {
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
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x, y - 1, remain - cost);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x - 1, y, remain - cost);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x, y + 1, remain - cost);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        aim =  _MakeRouteToAimPosition(elem, classType, aimX, aimY, x + 1, y, remain - cost);
        if (aim != null) {
            aim.add(new PVector(x, y));
            return aim;
        }
        return null;
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
        id = json.GetInt("ID", -99999);
        if (id != -99999) {
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
        int value = json.GetInt("Weapon Class ID", -99999);
        if (value != -99999) {
            wcm.SetWeaponClassID(value);
        } else {
            dialog.Show("エラー", "武器タイプIDが設定されていないデータがあります。\njson = " + json);
            throw new Exception();
        }
        wcm.SetAttackCorrect(json.GetInt("Attack", 0));
        wcm.SetDefenseCorrect(json.GetInt("Defense", 0));
        wcm.SetAccuracyCorrect(json.GetInt("Accuracy", 0));
        wcm.SetAvoidCorrect(json.GetInt("Avoid", 0));
        wcm.SetCriticalCorrect(json.GetInt("Critical", 0));
        wcm.SetCriticalAvoidCorrect(json.GetInt("Critical Avoid", 0));
    }

    /**
     パラメータに変更の可能性がないため退避処理を設けていない。
     */
    public void LoadUnitParameter(FEUnitParameter prm, JsonObject json) {
        if (prm == null || json == null) return;
        prm.SetHp(json.GetInt("HP", -1));
        prm.SetAttack(json.GetInt("ATK", -1));
        prm.SetMAttack(json.GetInt("MAT", -1));
        prm.SetTech(json.GetInt("TEC", -1));
        prm.SetSpeed(json.GetInt("SPD", -1));
        prm.SetLucky(json.GetInt("LUC", -1));
        prm.SetDefense(json.GetInt("DEF", -1));
        prm.SetMDefense(json.GetInt("MDF", -1));
        prm.SetMobility(json.GetInt("MOV", -1));
        prm.SetProficiency(json.GetInt("PRO", -1));
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
        int value = json.GetInt("Weapon Class ID", -99999);
        if (value != -99999) {
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
                wep.GetGrantingStates().put(state.GetInt("State ID", -99999), state.GetInt("Accuracy", 0));
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
        JsonArray array = json.GetJsonArray("Learnable Skills");
        if (array != null) {
            JsonObject skill;
            int id;
            for (int i=0; i<array.Size(); i++) {
                skill = array.GetJsonObject(i);
                if (skill == null) continue;
                id = skill.GetInt("Skill ID", -99999);
                if (id != -99999) {
                    cls.GetLearnabeSkills().put(id, skill.GetInt("Level", -99999));
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
        int classID = json.GetInt("Class ID", -99999);
        if (classID != -99999) {
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
                id = array.GetInt(i, -99999);
                if (id != -99999) {
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
                actItem = feManager.GetDataBase().CreateItem(item.GetInt("ID", -99999), item.GetBoolean("Is Item", true));
                actItem.SetEndurance(item.GetInt("Endurance", 0));
                actItem.SetExchangeable(item.GetBoolean("Is Exchangeable", true));
                if (actItem != null) {
                    unit.GetItemList().add(actItem);
                }
            }
        }
        int idx = json.GetInt("Equip Weapon Index", -99999);
        if (idx != -99999) {
            unit.SetEquipWeapon(unit.GetItemList().get(idx));
        }
    }

    public void LoadOtherUnit(FEOtherUnit unit, JsonObject json) throws Exception {
        if (unit == null || json == null) return;
        LoadUnit(unit, json);
    }
}