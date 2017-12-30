public class UnitParameter {
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

    private int _hap;
    public int GetHappiness() {
        return _hap;
    }
    public void SetHappiness(int value) {
        _hap = value;
    }
    public void AddHappiness(int value) {
        _hap += value;
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
 ゲーム内の操作可能なユニット、敵ユニット、援軍ユニットすべての基本となるクラス。
 */
public class Unit {
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

    private int _importance;
    public int GetImportance() {
        return _importance;
    }
    public void SetImportance(int value) {
        _importance = value;
    }

    private int _class;

    private int _level;
    public int GetLevel() {
        return _level;
    }
    public void SetLevel(int value) {
        _level = value;
    }

    private UnitParameter _parameter;
    public UnitParameter GetParameter() {
        return _parameter;
    }

    private UnitParameter _growthRate;
    public UnitParameter GetGrowthRate() {
        return _growthRate;
    }

    private ArrayList<ItemBase> _itemList;
    public ArrayList<ItemBase> GetItemList() {
        return _itemList;
    }
}

/**
 ユニットが属するクラス。
 */
public class UnitClass {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _imageFolderPath;
    public String GetImageFolderPath() {
        return _imageFolderPath;
    }

    private String _motionFolderPath;
    public String GetMotionFolderPath() {
        return _motionFolderPath;
    }

    private ClassType _classType;
    public ClassType GetClassType() {
        return _classType;
    }

    private ArrayList<WeaponType> _wearableWeaponTypes;
    public ArrayList<WeaponType> GetWearableWeaponTypes() {
        return _wearableWeaponTypes;
    }

    private int _learnabeSkills;

    private UnitParameter _paramBonus;
    public UnitParameter GetParameterBonus() {
        return _paramBonus;
    }

    private UnitParameter _growthBonus;
    public UnitParameter GetGrowthBonus() {
        return _growthBonus;
    }
}

/**
 ユニットが保持することができるアイテムの基本クラス。
 */
public class ItemBase {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

    private int _price;
    public int GetPrice() {
        return _price;
    }

    private int _weigth;
    public int GetWeigth() {
        return _weigth;
    }

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

    private UnitParameter _paramBonus;
    public UnitParameter GetParameterBonus() {
        return _paramBonus;
    }

    private UnitParameter _growthBonus;
    public UnitParameter GetGrowthBonus() {
        return _growthBonus;
    }
}

public class Skill {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _explain;
    public String GetExplain() {
        return _explain;
    }

    // 戦闘用スキルかどうか
    private boolean _isBattleSkill;
    public boolean IsBattleSkill() {
        return _isBattleSkill;
    }

    

    // 発動率
    private float _activateRate;
    public float GetActivateRate() {
        return _activateRate;
    }
}