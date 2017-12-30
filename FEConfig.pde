public class ClassType {
    private String _name;
    public String GetName() {
        return _name;
    }

    private boolean _isArmor;
    public boolean IsArmor() {
        return _isArmor;
    }

    private boolean _isRider;
    public boolean IsRider() {
        return _isRider;
    }

    private boolean _isFlyer;
    public boolean IsFlyer() {
        return _isFlyer;
    }

    public ClassType(String name, boolean isArmor, boolean isRider, boolean isFlyer) {
        _name = name;
        _isArmor = isArmor;
        _isRider = isRider;
        _isFlyer = isFlyer;
    }
}

/**
 剣、斧、槍、弓、魔法、杖などの種類。
 */
public class WeaponType {
    private String _name;
    public String GetName() {
        return _name;
    }

    private String _imagePath;
    public String GetImagePath() {
        return _imagePath;
    }

    // 命中した場合のみ耐久値が減少するかどうか
    private boolean _isWearOnHit;
    public boolean IsWearOnHit() {
        return _isWearOnHit;
    }

    public WeaponType(String name, String imagePath, boolean isWearOnHit) {
        _name = name;
        _imagePath = imagePath;
        _isWearOnHit = isWearOnHit;
    }
}

/**
 ゲーム内で設定を変更することができるコンフィグパラメータを保持するクラス。
 */
public class Config {
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

    // リアル戦闘画面を表示するかどうか
    private boolean _isShowBattle;
    public boolean IsShowBattle() {
        return _isShowBattle;
    }
    public void SetShowBattle(boolean value) {
        _isShowBattle = value;
    }
}

/**
 ゲーム内で設定を変更することができないコンフィグパラメータを保持するクラス。
 */
public class ConfigStatic {
    private int _maxMoney;
    public int GetMaxMoney() {
        return _maxMoney;
    }

    private int _maxExp;
    public int GetMaxExp() {
        return _maxExp;
    }

    private int _maxHaveSkills;
    public int GetMaxHaveSkills() {
        return _maxHaveSkills;
    }

    private int _maxHaveItems;
    public int GetMaxHaveItems() {
        return _maxHaveItems;
    }

    private int _maxStockItems;
    public int GetMaxStockItems() {
        return _maxStockItems;
    }

    private int _maxAppearEnemies;
    public int GetMaxAppearEnemies() {
        return _maxAppearEnemies;
    }

    private int _minGainExp;
    public int GetMinGainExp() {
        return _minGainExp;
    }

    private int _leaderGainExp;
    public int GetLeaderGainExp() {
        return _leaderGainExp;
    }

    private int _subLeaderGainExp;
    public int GetSubLeaderGainExp() {
        return _subLeaderGainExp;
    }

    private float _criticalHitRate;
    public float GetCriticalHitRate() {
        return _criticalHitRate;
    }

    private float _specialHitRate;
    public float GetSpecialHitRate() {
        return _specialHitRate;
    }

    private int _maxLevel;
    public int GetMaxLevel() {
        return _maxLevel;
    }

    private UnitParameter _maxParameter;
    public int GetMaxHp() {
        return _maxParameter.GetHp();
    }
    public int GetMaxAttack() {
        return _maxParameter.GetAttack();
    }
    public int GetMaxMAttack() {
        return _maxParameter.GetMAttack();
    }
    public int GetMaxTech() {
        return _maxParameter.GetTech();
    }
    public int GetMaxSpeed() {
        return _maxParameter.GetSpeed();
    }
    public int GetMaxHappiness() {
        return _maxParameter.GetHappiness();
    }
    public int GetMaxDefense() {
        return _maxParameter.GetDefense();
    }
    public int GetMaxMDefense() {
        return _maxParameter.GetMDefense();
    }
    public int GetMaxMobility() {
        return _maxParameter.GetMobility();
    }
    public int GetMaxProficiency() {
        return _maxParameter.GetProficiency();
    }

    public ConfigStatic() {
        JsonObject json = new JsonObject();
        json.Load("data/config/config.json");

        _maxParameter = new UnitParameter();

        _maxMoney = json.GetInt("Max Money", -1);
        _maxExp = json.GetInt("Max Exp", -1);
        _maxHaveSkills = json.GetInt("Max Have Skills", -1);
        _maxHaveItems = json.GetInt("Max Have Items", -1);
        _maxStockItems = json.GetInt("Max Stock Items", -1);
        _maxAppearEnemies = json.GetInt("Max Appear Enemies", -1);
        _minGainExp = json.GetInt("Min Gain Exp", -1);
        _leaderGainExp = json.GetInt("Leader Gain Exp", -1);
        _subLeaderGainExp = json.GetInt("Sub Leader Gain Exp", -1);
        _criticalHitRate = json.GetInt("Critical Hit Rate", -1);
        _specialHitRate = json.GetInt("Special Hit Rate", -1);
        _maxLevel = json.GetInt("Max Level", -1);
        _maxParameter.SetHp(json.GetInt("Max Hp", -1));
        _maxParameter.SetAttack(json.GetInt("Max Atk", -1));
        _maxParameter.SetMAttack(json.GetInt("Max Mat", -1));
        _maxParameter.SetTech(json.GetInt("Max Tec", -1));
        _maxParameter.SetSpeed(json.GetInt("Max Spd", -1));
        _maxParameter.SetHappiness(json.GetInt("Max Hap", -1));
        _maxParameter.SetDefense(json.GetInt("Max Def", -1));
        _maxParameter.SetMDefense(json.GetInt("Max Mdf", -1));
        _maxParameter.SetMobility(json.GetInt("Max Mov", -1));
        _maxParameter.SetProficiency(json.GetInt("Max Pro", -1));
    }
}