/**
 剣、斧、槍、弓、魔法、杖などの種類。
 */
public class FEWeaponClass {
    private String _name;
    public String GetName() {
        return _name;
    }

    /**
     マウスオーバー時に表示する説明
     */
    private String _explain;
    public String GetExplain() {
        return _explain;
    }

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

    private HashMap<FEWeaponClass, FEWeaponCompatibility> _compatibility;
    public HashMap<FEWeaponClass, FEWeaponCompatibility> GetCompatibility() {
        return _compatibility;
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

public class FEUnitParameter {
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
}

/**
 ゲーム内のユニットすべての基本となるクラス。
 */
public class FEUnitBase {
    private String _name;
    public String GetName() {
        return _name;
    }
    public void SetName(String value) {
        _name = value;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }
    public void SetExplain(String value) {
        _explain = value;
    }

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

    private String _mapImageFolderPath;
    public String GetMapImageFolderPath() {
        return _mapImageFolderPath;
    }
    public void SetMapImageFolderPath(String value) {
        _mapImageFolderPath = value;
    }

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
    private FEUnitClass _unitClass;
    public FEUnitClass GetUnitClass() {
        return _unitClass;
    }
    public void SetUnitClass(FEUnitClass value) {
        _unitClass = value;
    }

    private int _level;
    public int GetLevel() {
        return _level;
    }
    public void SetLevel(int value) {
        _level = value;
    }

    // 戦闘中に使用するパラメータの現在値
    private FEUnitParameter _parameter;
    public FEUnitParameter GetParameter() {
        return _parameter;
    }

    // 戦闘中には使用しない各パラメータの基準値
    private FEUnitParameter _baseParameter;
    public FEUnitParameter GetBaseParameter() {
        return _baseParameter;
    }

    private FEUnitParameter _growthRate;
    public FEUnitParameter GetGrowthRate() {
        return _growthRate;
    }

    private ArrayList<FEItemBase> _itemList;
    public ArrayList<FEItemBase> GetItemList() {
        return _itemList;
    }

    private FEWeapon _equipWeapon;
    public FEWeapon GetEquipWeapon() {
        return _equipWeapon;
    }
    public void SetEquipWeapon(FEItemBase item) {
        if (!(item instanceof FEWeapon)) return;
        if (!_itemList.contains(item)) return;
        _equipWeapon = (FEWeapon)item;
    }

    public FEUnitBase() {
        _itemList = new ArrayList<FEItemBase>();
    }
}

/**
 行動パターンを持つユニットのクラス。
 */
public class FEOtherUnit extends FEUnitBase {
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
 */
public class FEUnitClass {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

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

    private int _movingType;
    public int GetMovingType() {
        return _movingType;
    }

    /**
     タイル効果を考慮するかどうか
     */
    private boolean _isConsiderTileEffect;
    public boolean IsConsiderTileEffect() {
        return _isConsiderTileEffect;
    }

    private ArrayList<FEWeaponClass> _wearableWeaponTypes;
    public ArrayList<FEWeaponClass> GetWearableWeaponTypes() {
        return _wearableWeaponTypes;
    }

    private HashMap<Integer, FEUnitSkill> _learnabeSkills;
    public HashMap<Integer, FEUnitSkill> GetLearnabeSkills() {
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
 */
public class FEItemBase {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

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
     */
    private HashMap<FEState, Integer> _stateGrant;
    public HashMap<FEState, Integer> GetStateGrant() {
        return _stateGrant;
    }
}

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

public class FEUnitSkill {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

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

public class FEState {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

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
 地形情報。
 そのままマップのデータとして使われる。
 */
public class FETerrain {
    private String _name;
    public String GetName() {
        return _name;
    }

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
 地形効果
 */
public class FETerrainEffect {
    private String _name;
    public String GetName() {
        return _name;
    }

    private int _avoid;
    public int GetAvoid() {
        return _avoid;
    }

    private int _defense;
    public int GetDefense() {
        return _defense;
    }

    private int _mDefense;
    public int GetMDefense() {
        return _mDefense;
    }

    private int _recover;
    public int GetRecover() {
        return _recover;
    }

    private int[] _moveCosts;
    public int[] GetMoveConts() {
        return _moveCosts;
    }

    private boolean _isMovable;
    public boolean IsMovable() {
        return _isMovable;
    }
}