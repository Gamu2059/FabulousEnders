public class FEData implements Copyable<FEData> {
    private String _name;
    public String GetName() {
        return _name;
    }
    public void SetName(String value) {
        _name = value;
    }

    private int _id;
    public int GetID() {
        return _id;
    }
    public void SetID(int value) {
        _id = value;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }
    public void SetExplain(String value) {
        _explain = value;
    }

    public void CopyTo(FEData own) {
        if (own == null) return;
        own.SetName(GetName());
        own.SetID(GetID());
        own.SetExplain(GetExplain());
    }
}

/**
 剣、斧、槍、弓、魔法、杖などの種類。
 参照保持専用。
 */
public class FEWeaponClass extends FEData {
    /**
     使用可能武器として表示する画像のパス
     */
    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    /**
     武器タイプ
     */
    private int _weaponType;
    public int GetWeaponType() {
        return _weaponType;
    }

    /** 
     命中した場合のみ耐久値が減少するかどうか
     */
    private boolean _isWearOnHit;
    public boolean IsWearOnHit() {
        return _isWearOnHit;
    }

    /**
     武器相性
     */
    private HashMap<FEWeaponClass, FEWeaponCompatibility> _compatibility;
    public HashMap<FEWeaponClass, FEWeaponCompatibility> GetCompatibility() {
        return _compatibility;
    }

    public FEWeaponClass() {
        _compatibility = new HashMap<FEWeaponClass, FEWeaponCompatibility>();
    }
}

/**
 武器同士の相性特性。
 */
public class FEWeaponCompatibility {
    private int _attackCorrect;
    public int GetAttackCorrect() {
        return _attackCorrect;
    }

    private int _defenseCorrect;
    public int GetDefenseCorrect() {
        return _defenseCorrect;
    }

    private int _accuracyCorrect;
    public int GetAccuracyCorrect() {
        return _accuracyCorrect;
    }

    private int _avoidCorrect;
    public int GetAvoidCorrect() {
        return _avoidCorrect;
    }

    private int _criticalCorrect;
    public int GetCriticalCorrect() {
        return _criticalCorrect;
    }

    private int _criticalAvoidCorrect;
    public int GetCriticalAvoidCorrect() {
        return _criticalAvoidCorrect;
    }
}

/**
 ユニットの基礎パラメータ。
 */
public class FEUnitParameter implements Copyable<FEUnitParameter> {
    private int _hp;
    public int GetHp() {
        return _hp;
    }
    public void SetHp(int value) {
        _hp = value;
    }
    public void AddHp(int value) {
        _hp += value;
    }

    private int _atk;
    public int GetAttack() {
        return _atk;
    }
    public void SetAttack(int value) {
        _atk = value;
    }
    public void AddAttack(int value) {
        _atk += value;
    }

    private int _mat;
    public int GetMAttack() {
        return _mat;
    }
    public void SetMAttack(int value) {
        _mat = value;
    }
    public void AddMAttack(int value) {
        _mat += value;
    }

    private int _tec;
    public int GetTech() {
        return _tec;
    }
    public void SetTech(int value) {
        _tec = value;
    }
    public void AddTech(int value) {
        _tec += value;
    }

    private int _spd;
    public int GetSpeed() {
        return _spd;
    }
    public void SetSpeed(int value) {
        _spd = value;
    }
    public void AddSpeed(int value) {
        _spd += value;
    }

    private int _luc;
    public int GetLucky() {
        return _luc;
    }
    public void SetLucky(int value) {
        _luc = value;
    }
    public void AddLucky(int value) {
        _luc += value;
    }

    private int _def;
    public int GetDefense() {
        return _def;
    }
    public void SetDefense(int value) {
        _def = value;
    }
    public void AddDefense(int value) {
        _def += value;
    }

    private int _mdf;
    public int GetMDefense() {
        return _mdf;
    }
    public void SetMDefense(int value) {
        _mdf = value;
    }
    public void AddMDefense(int value) {
        _mdf += value;
    }

    private int _mov;
    public int GetMobility() {
        return _mov;
    }
    public void SetMobility(int value) {
        _mov = value;
    }
    public void AddMobility(int value) {
        _mov += value;
    }

    private int _pro;
    public int GetProficiency() {
        return _pro;
    }
    public void SetProficiency(int value) {
        _pro = value;
    }
    public void AddProficiency(int value) {
        _pro += value;
    }

    public void CopyTo(FEUnitParameter own) {
        if (own == null) return;
        own._hp = _hp;
        own._atk = _atk;
        own._mat = _mat;
        own._tec = _tec;
        own._spd = _spd;
        own._luc = _luc;
        own._def = _def;
        own._mdf = _mdf;
        own._mov = _mov;
        own._pro = _pro;
    }
}

public class FEMapObject extends FEData {
    private String _mapImageFolderPath;
    public String GetMapImageFolderPath() {
        return _mapImageFolderPath;
    }
    public void SetMapImageFolderPath(String value) {
        _mapImageFolderPath = value;
    }

    public void CopyTo(FEMapObject own) {
        if (own == null) return;
        super.CopyTo(own);
        own.SetMapImageFolderPath(GetMapImageFolderPath());
    }
}

/**
 ゲーム内のユニットすべての基本となるクラス。
 */
public class FEUnit extends FEMapObject {
    /**
     所属組織
     */
    private String _organization;
    public String GetOrganization() {
        return _organization;
    }
    public void SetOrganization(String value) {
        _organization = value;
    }

    private String _faceImagePath;
    public String GetFaceImagePath() {
        return _faceImagePath;
    }
    public void SetFaceImagePath(String value) {
        _faceImagePath = value;
    }

    /**
     所属組織内での重要度
     敵AIの攻撃優先度などに用いられる
     */
    private int _importance;
    public int GetImportance() {
        return _importance;
    }
    public void SetImportance(int value) {
        _importance = value;
    }

    /**
     参照保持
     */
    private FEClass _unitClass;
    public FEClass GetUnitClass() {
        return _unitClass;
    }
    public void SetUnitClass(FEClass value) {
        _unitClass = value;
    }

    /**
     現在のレベル
     */
    private int _level;
    public int GetLevel() {
        return _level;
    }
    public void SetLevel(int value) {
        _level = value;
    }
    public void AddLevel(int value) {
        _level += value;
    }

    /**
     現在の経験値
     */
    private int _exp;
    public int GetExp() {
        return _exp;
    }
    public void SetExp(int value) {
        _exp = value;
    }
    public void AddExp(int value) {
        _exp += value;
    }

    /**
     現在の体力
     これは特別に変動が激しいので固有に定義
     */
    private int _hp;
    public int GetHp() {
        return _hp;
    }
    public void SetHp(int value) {
        _hp = value;
    }
    public void AddHp(int value) {
        _hp += value;
    }

    /**
     ユニット固有のパラメータ
     */
    private FEUnitParameter _baseParameter;
    public FEUnitParameter GetBaseParameter() {
        return _baseParameter;
    }
    public void SetBaseParameter(FEUnitParameter value) {
        _baseParameter = value;
    }

    /**
     クラス、装備中の武器、アイテム、ステート、スキル、地形効果によるパラメータ補正値
     */
    private FEUnitParameter _correctParameter;
    public FEUnitParameter GetCorrectParameter() {
        return _correctParameter;
    }

    /**
     現在のパラメータ
     */
    private FEUnitParameter _parameter;
    public FEUnitParameter GetParameter() {
        return _parameter;
    }

    /**
     ユニット固有の成長率
     */
    private FEUnitParameter _baseGrowthRate;
    public FEUnitParameter GetBaseGrowthRate() {
        return _baseGrowthRate;
    }
    public void SetBaseGrowthRate(FEUnitParameter value) {
        _baseGrowthRate = value;
    }

    /**
     クラス、装備中の武器、アイテムによる成長率補正
     */
    private FEUnitParameter _correctGrowthRate;
    public FEUnitParameter GetCorrectGrowthRate() {
        return _correctGrowthRate;
    }

    /**
     ユニット自身が習得しているスキルのリスト
     */
    private ArrayList<FESkill> _learnSkillList;
    public ArrayList<FESkill> GetLearnSkillList() {
        return _learnSkillList;
    }
    public void SetLearnSkillList(ArrayList<FESkill> value) {
        _learnSkillList = value;
    }

    /**
     ユニット自身、クラス、装備中の武器、アイテム、ステート、スキルの中から実際に有効と判断されたスキルのリスト
     現在のスキルリスト
     */
    private ArrayList<FESkill> _skillList;
    public ArrayList<FESkill> GetSkillList() {
        return _skillList;
    }

    /**
     現在のアイテムリスト
     */
    private ArrayList<FEActualItem> _itemList;
    public ArrayList<FEActualItem> GetItemList() {
        return _itemList;
    }

    /**
     現在の装備中の武器
     */
    private FEActualItem _equipWeapon;
    public FEActualItem GetEquipWeapon() {
        return _equipWeapon;
    }
    public void SetEquipWeapon(FEActualItem item) {
        if (!(item.GetItem() instanceof FEWeapon)) return;
        if (!_itemList.contains(item)) return;
        _equipWeapon = item;
    }

    public FEUnit() {
        _baseParameter = new FEUnitParameter();
        _correctParameter = new FEUnitParameter();
        _parameter = new FEUnitParameter();
        _baseGrowthRate = new FEUnitParameter();
        _correctGrowthRate = new FEUnitParameter();

        _learnSkillList = new ArrayList<FESkill>();
        _skillList = new ArrayList<FESkill>();

        _itemList = new ArrayList<FEActualItem>();

        _equipWeapon = new FEActualItem();
    }

    public void CopyTo(FEUnit own) {
        if (own == null) return;
        super.CopyTo(own);
        own.SetOrganization(GetOrganization());
        own.SetFaceImagePath(GetFaceImagePath());
        own.SetImportance(GetImportance());
        own.SetUnitClass(GetUnitClass());
        own.SetLevel(GetLevel());
        own.SetExp(GetExp());
        own.SetHp(GetHp());
        GetBaseParameter().CopyTo(own.GetBaseParameter());
        GetBaseGrowthRate().CopyTo(own.GetBaseGrowthRate());
        own.SetLearnSkillList((ArrayList<FESkill>)GetLearnSkillList().clone());
        own.GetItemList().clear();
        FEActualItem item;
        for (int i=0; i<GetItemList().size(); i++) {
            item = new FEActualItem();
            GetItemList().get(i).CopyTo(item);
            own.GetItemList().add(item);
        }
        GetEquipWeapon().CopyTo(own.GetEquipWeapon());
    }
}

/**
 行動パターンを持つユニットのクラス。
 */
public class FEOtherUnit extends FEUnit {
    private int _actionPattern;
    public int GetActionPattern() {
        return _actionPattern;
    }

    /**
     行動に影響するリージョンの配列
     */
    private int[] _regions;
    public int[] GetRegions() {
        return _regions;
    }

    /**
     攻撃対象にする組織
     */
    private String[] _attackOnOrg;
    public String[] GetAttackOnOrg() {
        return _attackOnOrg;
    }

    /**
     攻撃優先度オプション
     */
    private FEAttackPriority[] _attackPriority;
    public FEAttackPriority[] GetAttackPriority() {
        return _attackPriority;
    }
}

public class FEAttackPriority {
    private int _optionID;
    public int GetOptionID() {
        return _optionID;
    }

    private String _parameter;
    public String GetParameter() {
        return _parameter;
    }
}

/**
 ユニットが属するクラス。
 参照保持専用。
 */
public class FEClass extends FEData {
    private String _imageFolderPath;
    public String GetImageFolderPath() {
        return _imageFolderPath;
    }
    public void SetImageFolderPath(String value) {
        _imageFolderPath = value;
    }

    private int _classType;
    public int GetClassType() {
        return _classType;
    }

    /**
     タイル効果を考慮するかどうか
     */
    private boolean _isConsiderTileEffect;
    public boolean IsConsiderTileEffect() {
        return _isConsiderTileEffect;
    }

    /**
     参照保持
     */
    private ArrayList<FEWeaponClass> _wearableWeaponTypes;
    public ArrayList<FEWeaponClass> GetWearableWeaponTypes() {
        return _wearableWeaponTypes;
    }

    /**
     スキルは参照保持
     */
    private HashMap<Integer, FESkill> _learnabeSkills;
    public HashMap<Integer, FESkill> GetLearnabeSkills() {
        return _learnabeSkills;
    }

    /**
     杖を使うことができるかどうか
     */
    private boolean _canUseCane;
    public boolean CanUseCane() {
        return _canUseCane;
    }

    /**
     標準で再移動をサポートしているかどうか
     */
    private boolean _canReMove;
    public boolean CanReMove() {
        return _canReMove;
    }

    private FEUnitParameter _paramBonus;
    public FEUnitParameter GetParameterBonus() {
        return _paramBonus;
    }

    private FEUnitParameter _growthBonus;
    public FEUnitParameter GetGrowthBonus() {
        return _growthBonus;
    }
}

/**
 ユニットが保持することができるアイテムの基本クラス。
 参照保持専用。
 */
public class FEItemBase extends FEData {
    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    /**
     使用エフェクト
     */
    private String _usingEffectPath;
    public String GetUsingEffectPath() {
        return _usingEffectPath;
    }

    private int _price;
    public int GetPrice() {
        return _price;
    }

    private int _weigth;
    public int GetWeigth() {
        return _weigth;
    }

    /**
     耐久値
     */
    private int _endurance;
    public int GetEndurance() {
        return _endurance;
    }
    public void SetEndurance(int value) {
        _endurance = value;
    }
    public void AddEndurance(int value) {
        _endurance += value;
    }

    private boolean _isImportant;
    public boolean IsImportant() {
        return _isImportant;
    }

    private boolean _isExchangeable;
    public boolean IsExchangeable() {
        return _isExchangeable;
    }
    public void SetExchangeable(boolean value) {
        _isExchangeable = value;
    }

    private FEUnitParameter _paramBonus;
    public FEUnitParameter GetParameterBonus() {
        return _paramBonus;
    }

    private FEUnitParameter _growthBonus;
    public FEUnitParameter GetGrowthBonus() {
        return _growthBonus;
    }
}

/**
 武器。
 参照保持専用。
 */
public class FEWeapon extends FEItemBase {
    private FEWeaponClass _weaponClass;
    public FEWeaponClass GetWeaponClass() {
        return _weaponClass;
    }

    private int _power;
    public int GetPower() {
        return _power;
    }

    private int _minRange;
    public int GetMinRange() {
        return _minRange;
    }

    private int _maxRange;
    public int GetMaxRange() {
        return _maxRange;
    }

    private int _accuracy;
    public int GetAccuracy() {
        return _accuracy;
    }

    private int _critical;
    public int GetCritical() {
        return _critical;
    }

    private int _attackNum;
    public int GetAttackNum() {
        return _attackNum;
    }

    private int _wearableProficiency;
    public int GetWearableProficiency() {
        return _wearableProficiency;
    }

    /**
     特効が付くクラスタイプの配列
     */
    private int[] _specialAttack; 
    public int[] GetSpecialAttack() {
        return _specialAttack;
    }

    private boolean _isOneway;
    public boolean IsOneway() {
        return _isOneway;
    }

    private boolean _isMagical;
    public boolean IsMagical() {
        return _isMagical;
    }

    /**
     相手にステートを付与する確率
     ステートは参照保持
     */
    private HashMap<FEState, Integer> _stateGrant;
    public HashMap<FEState, Integer> GetStateGrant() {
        return _stateGrant;
    }
}

/**
 アイテム。
 参照保持専用。
 */
public class FEItem extends FEItemBase {
    private int _kind;
    public int GetKind() {
        return _kind;
    }

    private boolean _isCane;
    public boolean IsCane() {
        return _isCane;
    }

    private int _gainExp;
    public int GetGainExp() {
        return _gainExp;
    }

    private int _range;
    public int GetRange() {
        return _range;
    }

    private int _filter;
    public int GetFilter() {
        return _filter;
    }

    private int _useEffect;
    public int GetUseEffect() {
        return _useEffect;
    }
}

/**
 ユニットや持ち物の中で実際に使用するデータ。
 */
public class FEActualItem implements Copyable<FEActualItem> {
    /**
     アイテム内容
     参照保持
     */
    private FEItemBase _item;
    public FEItemBase GetItem() {
        return _item;
    }

    /**
     現在の耐久値
     */
    private int _endurance;
    public int GetEndurance() {
        return _endurance;
    }
    public void SetEndurance(int value) {
        _endurance = value;
    }
    public void AddEndurance(int value) {
        _endurance += value;
    }

    /**
     現在の交換可能状態
     */
    private boolean _isExchangeable;
    public boolean IsExchangeable() {
        return _isExchangeable;
    }
    public void SetExchangeable(boolean value) {
        _isExchangeable = value;
    }

    public FEActualItem() {
        _item = new FEItemBase();
    }

    public void Create(FEItemBase item) {
        _item = item;
        _endurance = item.GetEndurance();
        _isExchangeable = item.IsExchangeable();
    }

    public void CopyTo(FEActualItem own) {
        if (own == null) return;
        own.Create(_item);
    }
}

/**
 ユニットのスキル。
 参照保持専用。
 */
public class FESkill extends FEData {
    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    private int _activateReference;
    public int GetActivateReference() {
        return _activateReference;
    }

    /**
     発動確率がパラメータ依存でない場合の固有確率
     */
    private float _activateRate;
    public float GetActivateRate() {
        return _activateRate;
    }

    private int _skillFeature;
    public int GetSkillFeature() {
        return _skillFeature;
    }
}

/**
 ユニットのステートを保持するクラス。
 参照保持専用。
 */
public class FEState extends FEData {
    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    private boolean _isBadState;
    public boolean IsBadState() {
        return _isBadState;
    }

    private int _sustainTurn;
    public int GetSustainTurn() {
        return _sustainTurn;
    }

    /**
     自然回復(ターン開始時)
     */
    private int _recoverOnTimes;
    public int GetRecoverOnTimes() {
        return _recoverOnTimes;
    }

    private int[] _sealedOption;
    public int[] GetSealedOption() {
        return _sealedOption;
    }

    private int _actOption;
    public int GetActOption() {
        return _actOption;
    }

    /**
     解除オプション
     */
    private int _releaseOption;
    public int GetReleaseOption() {
        return _releaseOption;
    }

    /**
     解除にかかる回数
     */
    private int _releaseBy;
    public int GetReleaseBy() {
        return _releaseBy;
    }

    private FEUnitParameter _paramBonus;
    public FEUnitParameter GetParameterBonus() {
        return _paramBonus;
    }
}

/**
 ユニットのステートとして実際に扱うデータ。
 */
public class FEActualState implements Cloneable {
    /**
     ステート内容
     参照保持
     */
    private FEState _state;
    public FEState GetState() {
        return _state;
    }

    /**
     残り継続ターン
     */
    private int _remainTurn;
    public int GetRemainTurn() {
        return _remainTurn;
    }
    public void SetRemainTurn(int value) {
        _remainTurn = value;
    }
    public void AddRemainTurn(int value) {
        _remainTurn += value;
    }

    public FEActualState clone() {
        FEActualState own = new FEActualState();
        own._state = _state;
        own._remainTurn = _remainTurn;
        return own;
    }
}

/**
 地形効果
 参照保持専用。
 */
public class FETerrainEffect extends FEData {
    private int _avoid;
    public int GetAvoid() {
        return _avoid;
    }
    public void SetAvoid(int value) {
        _avoid = value;
    }

    private int _defense;
    public int GetDefense() {
        return _defense;
    }
    public void SetDefense(int value) {
        _defense = value;
    }

    private int _mDefense;
    public int GetMDefense() {
        return _mDefense;
    }
    public void SetMDefense(int value) {
        _mDefense = value;
    }

    private int _recover;
    public int GetRecover() {
        return _recover;
    }
    public void SetRecover(int value) {
        _recover = value;
    }

    /**
     クラスタイプに紐づけられる
     */
    private HashMap<Integer, Integer> _moveCosts;
    public HashMap<Integer, Integer> GetMoveConts() {
        return _moveCosts;
    }

    private boolean _isMovable;
    public boolean IsMovable() {
        return _isMovable;
    }
    public void SetMovable(boolean value) {
        _isMovable = value;
    }

    public FETerrainEffect() {
        _moveCosts = new HashMap<Integer, Integer>();
    }
}

/**
 地形情報。
 参照保持専用。
 */
public class FETerrain extends FEData {
    /**
     参照保持
     */
    private FETerrainEffect _effect;
    public FETerrainEffect GetEffect() {
        return _effect;
    }
    public void SetEffect(FETerrainEffect value) {
        _effect = value;
    }

    /**
     基本的な地形は一枚絵で表示してしまうが、建物などを表示したい場合はこちら
     */
    private String _mapImagePath;
    public String GetMapImagePath() {
        return _mapImagePath;
    }
}

/**
 戦闘マップ上で扱うオブジェクトの情報
 */
public class FEMapElement implements Comparable<FEMapElement> {
    /**
     マップのこの座標にある実体
     参照保持
     */
    private FEMapObject _mapObject;
    public FEMapObject GetMapObject() {
        return _mapObject;
    }
    public void SetMapObject(FEMapObject value) {
        _mapObject = value;
    }

    /**
     マップ上での座標
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }
    public void SetPosition(PVector value) {
        _position = value;
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

    /**
     アニメーションするかどうか
     */
    private boolean _isAnimaiton;
    public boolean IsAnimation() {
        return _isAnimaiton;
    }
    public void SetAnimation(boolean value) {
        _isAnimaiton = value;
    }

    /**
     向きを固定するかどうか
     */
    private boolean _isFixDirection;
    public boolean IsFixDirection() {
        return _isFixDirection;
    }
    public void SetFixDirection(boolean value) {
        _isFixDirection = value;
    }

    /**
     行動済みかどうか
     行動済みの場合、その時だけ強制的にアニメーションが停止される
     */
    private boolean _isAlready;
    public boolean IsAlready() {
        return _isAlready;
    }
    public void SetAlready(boolean value) {
        _isAlready = value;
    }

    public FEMapElement() {
        _position = new PVector();
    }
    
    public boolean IsSamePosition(int x, int y) {
        return x == _position.x && y == _position.y;
    }

    public int compareTo(FEMapElement e) {
        float n;
        n = GetPosition().y - e.GetPosition().y;
        if (n > 0) return 1;
        if (n < 0) return -1;
        n = GetPosition().x - e.GetPosition().x;
        if (n > 0) return 1;
        if (n < 0) return -1;
        return 0;
    }
}