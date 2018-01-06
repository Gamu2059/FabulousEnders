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
    private String _iconImagePath;
    public String GetIconImagePath() {
        return _iconImagePath;
    }
    public void SetIconImagePath(String value) {
        _iconImagePath = value;
    }

    /**
     武器タイプ
     */
    private int _weaponType;
    public int GetWeaponType() {
        return _weaponType;
    }
    public void SetWeaponType(int value) {
        _weaponType = value;
    }

    /** 
     命中した場合のみ耐久値が減少するかどうか
     */
    private boolean _isWearOnHit;
    public boolean IsWearOnHit() {
        return _isWearOnHit;
    }
    public void SetWearOnHit(boolean value) {
        _isWearOnHit = value;
    }

    /**
     武器相性
     */
    private HashMap<Integer, FEWeaponCompatibility> _compatibility;
    public HashMap<Integer, FEWeaponCompatibility> GetCompatibility() {
        return _compatibility;
    }

    public FEWeaponClass() {
        _compatibility = new HashMap<Integer, FEWeaponCompatibility>();
    }
}

/**
 武器同士の相性特性。
 */
public class FEWeaponCompatibility {
    private int _weaponClassID;
    public int GetWeaponClassID() {
        return _weaponClassID;
    }
    public void SetWeaponClassID(int value) {
        _weaponClassID = value;
    }

    private boolean _isBadCompatibility;
    public boolean IsBadCompatibility() {
        return _isBadCompatibility;
    }
    public void SetBadCompatibility(boolean value) {
        _isBadCompatibility = value;
    }

    private int _attackCorrect;
    public int GetAttackCorrect() {
        return _attackCorrect;
    }
    public void SetAttackCorrect(int value) {
        _attackCorrect = value;
    }

    private int _defenseCorrect;
    public int GetDefenseCorrect() {
        return _defenseCorrect;
    }
    public void SetDefenseCorrect(int value) {
        _defenseCorrect = value;
    }

    private int _accuracyCorrect;
    public int GetAccuracyCorrect() {
        return _accuracyCorrect;
    }
    public void SetAccuracyCorrect(int value) {
        _accuracyCorrect = value;
    }

    private int _avoidCorrect;
    public int GetAvoidCorrect() {
        return _avoidCorrect;
    }
    public void SetAvoidCorrect(int value) {
        _avoidCorrect = value;
    }

    private int _criticalCorrect;
    public int GetCriticalCorrect() {
        return _criticalCorrect;
    }
    public void SetCriticalCorrect(int value) {
        _criticalCorrect = value;
    }

    private int _criticalAvoidCorrect;
    public int GetCriticalAvoidCorrect() {
        return _criticalAvoidCorrect;
    }
    public void SetCriticalAvoidCorrect(int value) {
        _criticalAvoidCorrect = value;
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
     属するクラス
     ID保持
     */
    private int _unitClassID;
    public int GetUnitClassID() {
        return _unitClassID;
    }
    public void SetUnitClassID(int value) {
        _unitClassID = value;
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

    /**
     クラス、装備中の武器、アイテムによる成長率補正
     */
    private FEUnitParameter _correctGrowthRate;
    public FEUnitParameter GetCorrectGrowthRate() {
        return _correctGrowthRate;
    }

    /**
     ユニット自身が習得しているスキルのリスト
     ID保持
     */
    private ArrayList<Integer> _learnSkillList;
    public ArrayList<Integer> GetLearnSkillList() {
        return _learnSkillList;
    }
    public void SetLearnSkillList(ArrayList<Integer> value) {
        _learnSkillList = value;
    }

    /**
     ユニット自身、クラス、装備中の武器、アイテム、ステート、スキルの中から実際に有効と判断されたスキルのリスト
     現在のスキルリスト
     ID保持
     */
    private ArrayList<Integer> _skillList;
    public ArrayList<Integer> GetSkillList() {
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
    /**
     武器を装備する。
     もし手持ちのアイテムの中から選んだものなのであれば、先頭に持ってきて装備する。
     全体の持ち物の中から選んだものなのであれば、持てるかどうかの判定をしてから先頭に持ってきて装備する。
     */
    public void SetEquipWeapon(FEActualItem item) {
        if (item == null) return;
        if (!(item.GetItem() instanceof FEWeapon)) return;
        if (_itemList.contains(item)) {
            if (_itemList.indexOf(item) > 0) {
                _itemList.remove(item);
                _itemList.add(0, item);
            }
        } else {
            if (_itemList.size() >= FEConst.CONFIG_MAX_HAVE_ITEMS) return;
            _itemList.add(0, item);
        }
        _equipWeapon = item;
    }
    /**
     現在装備している武器を武装解除する。
     */
    public void DetachWeapon() {
        _equipWeapon = null;
    }

    public FEUnit() {
        _baseParameter = new FEUnitParameter();
        _correctParameter = new FEUnitParameter();
        _parameter = new FEUnitParameter();
        _baseGrowthRate = new FEUnitParameter();
        _correctGrowthRate = new FEUnitParameter();
        _learnSkillList = new ArrayList<Integer>();
        _skillList = new ArrayList<Integer>();
        _itemList = new ArrayList<FEActualItem>();
    }

    public void CopyTo(FEUnit own) {
        if (own == null) return;
        super.CopyTo(own);
        own.SetOrganization(GetOrganization());
        own.SetFaceImagePath(GetFaceImagePath());
        own.SetImportance(GetImportance());
        own.SetUnitClassID(GetUnitClassID());
        own.SetLevel(GetLevel());
        own.SetExp(GetExp());
        own.SetHp(GetHp());
        GetBaseParameter().CopyTo(own.GetBaseParameter());
        GetBaseGrowthRate().CopyTo(own.GetBaseGrowthRate());
        own.SetLearnSkillList((ArrayList<Integer>)GetLearnSkillList().clone());
        own.GetItemList().clear();
        FEActualItem item, toItem;
        for (int i=0; i<GetItemList().size(); i++) {
            item = GetItemList().get(i);
            toItem = feManager.GetDataBase().CreateItem(item.GetItem().GetID(), item.IsItem());
            if (toItem == null) continue;
            item.CopyTo(toItem);
            own.GetItemList().add(toItem);
        }
        int eIdx = GetItemList().indexOf(GetEquipWeapon());
        if (eIdx >= 0 && eIdx < GetItemList().size()) {
            own.SetEquipWeapon(own.GetItemList().get(eIdx));
        } else {
            own.DetachWeapon();
        }
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

    private int _classType;
    public int GetClassType() {
        return _classType;
    }
    public void SetClassType(int value) {
        _classType = value;
    }

    /**
     タイル効果を考慮するかどうか
     */
    private boolean _isConsiderTileEffect;
    public boolean IsConsiderTileEffect() {
        return _isConsiderTileEffect;
    }
    public void SetConsiderTileEffect(boolean value) {
        _isConsiderTileEffect = value;
    }

    /**
     装備可能な武器の武器クラス
     ID保持
     */
    private int[] _wearableWeaponTypes;
    public int[] GetWearableWeaponTypes() {
        return _wearableWeaponTypes;
    }
    public void SetWearableWeaponTypes(int[] value) {
        _wearableWeaponTypes = value;
    }

    /**
     習得できるスキル
     スキルID, 習得レベル で対応
     */
    private HashMap<Integer, Integer> _learnabeSkills;
    public HashMap<Integer, Integer> GetLearnabeSkills() {
        return _learnabeSkills;
    }
    public void SetLearnableSkills(HashMap<Integer, Integer> value) {
        _learnabeSkills = value;
    }

    /**
     杖を使うことができるかどうか
     */
    private boolean _canUseCane;
    public boolean CanUseCane() {
        return _canUseCane;
    }
    public void SetUseCane(boolean value) {
        _canUseCane = value;
    }

    /**
     上位クラスかどうか
     */
    private boolean _isAdvancedClass;
    public boolean IsAdvancedClass() {
        return _isAdvancedClass;
    }
    public void SetAdvancedClass(boolean value) {
        _isAdvancedClass = value;
    }

    private FEUnitParameter _changeBonus;
    public FEUnitParameter GetChangeBonus() {
        return _changeBonus;
    }

    private FEUnitParameter _growthBonus;
    public FEUnitParameter GetGrowthBonus() {
        return _growthBonus;
    }

    private FEUnitParameter _growthLimit;
    public FEUnitParameter GetGrowthLimit() {
        return _growthLimit;
    }

    public FEClass() {
        super();
        _changeBonus = new FEUnitParameter();
        _growthBonus = new FEUnitParameter();
        _growthLimit = new FEUnitParameter();
        _learnabeSkills = new HashMap<Integer, Integer>();
    }
}

/**
 ユニットが保持することができるアイテムの基本クラス。
 参照保持専用。
 */
public class FEItemBase extends FEData {
    private String _iconImagePath;
    public String GetIconImagePath() {
        return _iconImagePath;
    }
    public void SetIconImagePath(String value) {
        _iconImagePath = value;
    }

    /**
     使用エフェクト
     */
    private String _effectImagePath;
    public String GetEffectImagePath() {
        return _effectImagePath;
    }
    public void SetEffectImagePath(String value) {
        _effectImagePath = value;
    }

    private int _price;
    public int GetPrice() {
        return _price;
    }
    public void SetPrice(int value) {
        _price = value;
    }

    private int _weight;
    public int GetWeight() {
        return _weight;
    }
    public void SetWeight(int value) {
        _weight = value;
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

    private boolean _isSalable;
    public boolean IsSalable() {
        return _isSalable;
    }
    public void SetSalable(boolean value) {
        _isSalable = value;
    }

    private boolean _isImportant;
    public boolean IsImportant() {
        return _isImportant;
    }
    public void SetImportant(boolean value) {
        _isImportant = value;
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

    /**
     このアイテムを装備している間にだけ付与されるスキル。
     ID保持
     */
    private int[] _grantedSkills;
    public int[] GetGrantedSkills() {
        return _grantedSkills;
    }
    public void SetGrantedSkills(int[] value) {
        _grantedSkills = value;
    }

    public FEItemBase() {
        super();
        _paramBonus = new FEUnitParameter();
        _growthBonus = new FEUnitParameter();
    }
}

/**
 武器。
 参照保持専用。
 */
public class FEWeapon extends FEItemBase {
    /**
     武器クラス
     ID保持
     */
    private int _weaponClassID;
    public int GetWeaponClassID() {
        return _weaponClassID;
    }
    public void SetWeaponClassID(int value) {
        _weaponClassID = value;
    }

    private int _powerType;
    public int GetPowerType() {
        return _powerType;
    }
    public void SetPowerType(int value) {
        _powerType = value;
    }

    private int _power;
    public int GetPower() {
        return _power;
    }
    public void SetPower(int value) {
        _power = value;
    }

    private int _minRange;
    public int GetMinRange() {
        return _minRange;
    }
    public void SetMinRange(int value) {
        _minRange = value;
    }

    private int _maxRange;
    public int GetMaxRange() {
        return _maxRange;
    }
    public void SetMaxRange(int value) {
        _maxRange = value;
    }

    private int _accuracy;
    public int GetAccuracy() {
        return _accuracy;
    }
    public void SetAccuracy(int value) {
        _accuracy = value;
    }

    private int _critical;
    public int GetCritical() {
        return _critical;
    }
    public void SetCritical(int value) {
        _critical = value;
    }

    private int _attackNum;
    public int GetAttackNum() {
        return _attackNum;
    }
    public void SetAttackNum(int value) {
        _attackNum = value;
    }

    private int _wearableProficiency;
    public int GetWearableProficiency() {
        return _wearableProficiency;
    }
    public void SetWearableProficiency(int value) {
        _wearableProficiency = value;
    }

    /**
     特効が付くクラスタイプの配列
     */
    private int[] _specialAttack; 
    public int[] GetSpecialAttack() {
        return _specialAttack;
    }
    public void SetSpecialAttack(int[] value) {
        _specialAttack = value;
    }

    /**
     相手にステートを付与する確率
     ステートID, 付与パーセンテージで対応
     */
    private HashMap<Integer, Integer> _grantingStates;
    public HashMap<Integer, Integer> GetGrantingStates() {
        return _grantingStates;
    }
    public void SetGrantingStates(HashMap<Integer, Integer> value) {
        _grantingStates = value;
    }

    public FEWeapon() {
        super();
        _grantingStates = new HashMap<Integer, Integer>();
    }
}

/**
 アイテム。
 参照保持専用。
 */
public class FEItem extends FEItemBase {
    private boolean _isCane;
    public boolean IsCane() {
        return _isCane;
    }
    public void SetCane(boolean value) {
        _isCane = value;
    }

    private int _gainExp;
    public int GetGainExp() {
        return _gainExp;
    }
    public void SetGainExp(int value) {
        _gainExp = value;
    }

    /**
     射程
     */
    private int _range;
    public int GetRange() {
        return _range;
    }
    public void SetRange(int value) {
        _range = value;
    }

    /**
     射程にパラメータ参照を選んだ場合の参照するパラメータの判定値
     */
    private int _rangeRef;
    public int GetRangeRef() {
        return _rangeRef;
    }
    public void SEtRangeRef(int value) {
        _rangeRef = value;
    }

    /**
     参照するパラメータに掛ける倍率
     */
    private float _refRate;
    public float GetRefRate() {
        return _refRate;
    }
    public void SetRefRate(float value) {
        _refRate = value;
    }

    /**
     固有射程
     */
    private int _uniqueRange;
    public int GetUniqueRange() {
        return _uniqueRange;
    }
    public void SetUniqueRange(int value) {
        _uniqueRange = value;
    }

    /**
     誰に対して使用することができるか
     */
    private int _filter;
    public int GetFilter() {
        return _filter;
    }
    public void SetFilter(int value) {
        _filter = value;
    }

    private int _itemFeature;
    public int GetItemFeature() {
        return _itemFeature;
    }
    public void SetItemFeature(int value) {
        _itemFeature = value;
    }

    private JsonObject _itemFeatureParameter;
    public JsonObject GetItemFeatureParameter() {
        return _itemFeatureParameter;
    }
    public void SetItemFeatureParameter(JsonObject value) {
        _itemFeatureParameter = value;
    }

    public FEItem() {
        super();
    }
}

/**
 ユニットや持ち物の中で実際に使用するデータ。
 */
public class FEActualItem implements Copyable<FEActualItem> {
    /**
     アイテムかどうか
     falseの場合は、武器と看做す
     生成される段階で判断するのでSetterを設けない
     */
    private boolean _isItem;
    public boolean IsItem() {
        return _isItem;
    }

    /**
     アイテム内容
     参照保持(意図的)
     生成される段階で決定するのでSetterを設けない
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

    public FEActualItem(FEItemBase item, boolean isItem) {
        _item = item;
        _isItem = isItem;
        _endurance = _item.GetEndurance();
        _isExchangeable = _item.IsExchangeable();
    }

    public void CopyTo(FEActualItem own) {
        if (own == null) return;
        own._item = _item;
        own._isItem = _isItem;
        own._endurance = _endurance;
        own._isExchangeable = _isExchangeable;
    }
}

/**
 ユニットのスキル。
 参照保持専用。
 */
public class FESkill extends FEData {
    private String _iconImagePath;
    public String GetIconImagePath() {
        return _iconImagePath;
    }
    public void SetIconImagePath(String value) {
        _iconImagePath = value;
    }

    private int _activateReference;
    public int GetActivateReference() {
        return _activateReference;
    }
    public void SetActivateReference(int value) {
        _activateReference = value;
    }

    /**
     発動確率がパラメータ依存でない場合の固有確率
     */
    private int _uniqueActivateRate;
    public int GetUniqueActivateRate() {
        return _uniqueActivateRate;
    }
    public void SetUniqueActivateRate(int value) {
        _uniqueActivateRate = value;
    }

    private int _skillFeature;
    public int GetSkillFeature() {
        return _skillFeature;
    }
    public void SetSkillFeature(int value) {
        _skillFeature = value;
    }

    /**
     スキル機能パラメータ
     スキルによってパラメータの種類が異なるので柔軟に対応するためJSONで保持する
     */
    private JsonObject _skillFeatureParameter;
    public JsonObject GetSkillFeatureParameter() {
        return _skillFeatureParameter;
    }
    public void SetSkillFeatureParameter(JsonObject value) {
        _skillFeatureParameter = value;
    }

    public FESkill() {
        super();
    }
}

/**
 ユニットのステートを保持するクラス。
 参照保持専用。
 */
public class FEState extends FEData {
    private String _iconImagePath;
    public String GetIconImagePath() {
        return _iconImagePath;
    }
    public void SetIconImagePath(String value) {
        _iconImagePath = value;
    }

    private String _mapImagePath;
    public String GetMapImagePath() {
        return _mapImagePath;
    }
    public void SetMapImagePath(String value) {
        _mapImagePath = value;
    }

    private boolean _isBadState;
    public boolean IsBadState() {
        return _isBadState;
    }
    public void SetBadState(boolean value) {
        _isBadState = value;
    }

    private int _sustainTurn;
    public int GetSustainTurn() {
        return _sustainTurn;
    }
    public void SetSustainTurn(int value) {
        _sustainTurn = value;
    }

    /**
     自然回復(ターン開始時)
     */
    private int _recoverOnTimes;
    public int GetRecoverOnTimes() {
        return _recoverOnTimes;
    }
    public void SetRecoverOnTimes(int value) {
        _recoverOnTimes = value;
    }

    private int[] _sealedOption;
    public int[] GetSealedOption() {
        return _sealedOption;
    }
    public void SetSealedOption(int[] value) {
        _sealedOption = value;
    }

    private int _actOption;
    public int GetActOption() {
        return _actOption;
    }
    public void SetActOption(int value) {
        _actOption = value;
    }

    /**
     解除オプション
     */
    private int _releaseOption;
    public int GetReleaseOption() {
        return _releaseOption;
    }
    public void SetReleaseOption(int value) {
        _releaseOption = value;
    }

    /**
     解除にかかる回数
     */
    private int _releaseParameter;
    public int GetReleaseParameter() {
        return _releaseParameter;
    }
    public void SetReleaseParameter(int value) {
        _releaseParameter = value;
    }

    private FEUnitParameter _paramBonus;
    public FEUnitParameter GetParameterBonus() {
        return _paramBonus;
    }

    /**
     このステートに掛かっている間にだけ付与されるスキル。
     ID保持
     */
    private int[] _grantedSkills;
    public int[] GetGrantedSkills() {
        return _grantedSkills;
    }
    public void SetGrantedSkills(int[] value) {
        _grantedSkills = value;
    }

    public FEState() {
        super();
        _paramBonus = new FEUnitParameter();
    }
}

/**
 ユニットのステートとして実際に扱うデータ。
 */
public class FEActualState implements Copyable<FEActualState> {
    /**
     ステート内容
     参照保持(意図的)
     生成される段階で決定するのでSetterを設けない
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

    public FEActualState(FEState state) {
        _state = state;
        _remainTurn = _state.GetSustainTurn();
    }

    public void CopyTo(FEActualState own) {
        if (own == null) return;
        own._state = _state;
        own._remainTurn = _remainTurn;
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
        super();
        _moveCosts = new HashMap<Integer, Integer>();
    }
}

/**
 地形情報。
 参照保持専用。
 */
public class FETerrain extends FEData {
    /**
     地形効果
     ID保持
     */
    private int _effectID;
    public int GetEffectID() {
        return _effectID;
    }
    public void SetEffectID(int value) {
        _effectID = value;
    }

    /**
     基本的な地形は一枚絵で表示してしまうが、建物などを表示したい場合はこちら
     */
    private String _mapImagePath;
    public String GetMapImagePath() {
        return _mapImagePath;
    }
    public void SetMapImagePath(String value) {
        _mapImagePath = value;
    }

    public FETerrain() {
        super();
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