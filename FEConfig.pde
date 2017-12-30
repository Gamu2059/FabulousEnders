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
    
    public Config() {
        JsonObject json = new JsonObject();
        json.Load("data/config/config.json");
        
        _gridSpeed = json.GetInt("Grid Speed", -1);
        _messageSpeed = json.GetInt("Message Speed", -1);
        _isShowBattle = json.GetBoolean("Is Show Battle", true);
    }
}