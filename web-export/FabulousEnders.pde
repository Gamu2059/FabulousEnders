/**
 接頭辞について。
 FE ... FabulousEnders上で使用するクラスファイル群。
 P  ... システム上で使用するクラスファイル群。
 */

import java.util.*;
import java.io.*;

// pjsで実行するときはfalseにする
boolean isProcessing = true;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
ImageManager imageManager;
FontManager fontManager;
TransformManager transformManager;

FEJsonUtility feJsonUtility;
FEManager feManager;

SceneDialog dialog;

void setup() {
    size(880, 480);
    try {
        InitManager();
        SetScenes();
        feManager.Init();

        sceneManager.LoadScene(SceneID.SID_FE_BATTLE_MAP);
        sceneManager.Start();
        feManager.StartGame();
        
        feManager.GetBattleMapManager().LoadMapData("test_map.json");
    } 
    catch(Exception e) {
        println(e);
    }
}

void InitManager() {
    inputManager = new InputManager();
    sceneManager = new SceneManager();
    imageManager = new ImageManager();
    fontManager = new FontManager();
    transformManager = new TransformManager();

    feJsonUtility = new FEJsonUtility();
    feManager = new FEManager();
}

void SetScenes() {
    dialog = new SceneDialog();
    sceneManager.AddScene(dialog);
    sceneManager.AddScene(new SceneTitle());
    sceneManager.AddScene(new SceneOneIllust());
    sceneManager.AddScene(new SceneGameOver());

    sceneManager.AddScene(new FESceneBattleMap());
}

void draw() {
    try {
        background(0);
        sceneManager.Update();
        inputManager.Update();
        //println(frameRate);
    } 
    catch(Exception e) {
        println(e);
    }
}

void keyPressed() {
    inputManager.KeyPressed();
}

void keyReleased() {
    inputManager.KeyReleased();
}

void mousePressed() {
    inputManager.MousePressed();
}

void mouseReleased() {
    inputManager.MouseReleased();
}

void mouseClicked() {
    inputManager.MouseClicked();
}

void mouseWheel() {
    inputManager.MouseWheel();
}

void mouseMoved() {
    inputManager.MouseMoved();
}

void mouseDragged() {
    inputManager.MouseDragged();
}

void mouseEntered() {
    inputManager.MouseEntered();
}

void mouseExited() {
    inputManager.MouseExited();
}

void mouseOver() {
    inputManager.MouseEntered();
}

void mouseOut() {
    inputManager.MouseExited();
}
public final class ActionEvent {
    private PHash<IEvent> _events;
    public PHash<IEvent> GetEvents() {
        return _events;
    }

    public ActionEvent() {
        _events = new PHash<IEvent>();
    }

    public void InvokeEvent(String label) {
        IEvent e = _events.Get(label);
        if (e != null) {
            e.Event();
        }
    }

    public void InvokeAllEvents() {
        for (String label : _events.GetElements().keySet()) {
            InvokeEvent(label);
        }
    }
}
public class Collection<R extends Comparable> {
    /**
     配列のソートを行う。
     */
    public void SortArray(R[] o) {
        if (o == null) return;
        _QuickSort(o, 0, o.length-1);
    }

    /**
     リストのソートを行う。
     */
    public void SortList(ArrayList<R> o) {
        if (o == null) return;
        _QuickSort(o, 0, o.size()-1);
    }

    /**
     軸要素の選択
     順に見て、最初に見つかった異なる2つの要素のうち、
     大きいほうの番号を返します。
     全部同じ要素の場合は -1 を返します。
     */
    private int _Pivot(R[] o, int i, int j) {
        int k = i+1;
        while (k <= j && o[i].compareTo(o[k]) == 0) k++;
        if (k > j) return -1;
        if (o[i].compareTo(o[k]) >= 0) return i;
        return k;
    }

    private int _Pivot(ArrayList<R> o, int i, int j) {
        int k = i+1;
        while (k <= j && o.get(i).compareTo(o.get(k)) == 0) k++;
        if (k > j) return -1;
        if (o.get(i).compareTo(o.get(k)) >= 0) return i;
        return k;
    }

    /**
     クイックソート
     配列oの、o[i]からo[j]を並べ替えます。
     */
    private void _QuickSort(R[] o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o[p]);
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    private void _QuickSort(ArrayList<R> o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o.get(p));
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    /**
     パーティション分割
     o[i]～o[j]の間で、x を軸として分割します。
     x より小さい要素は前に、大きい要素はうしろに来ます。
     大きい要素の開始番号を返します。
     */
    private int _Partition(R[] o, int i, int j, R x) {
        int l=i, r=j;
        // 検索が交差するまで繰り返します
        while (l<=r) {
            // 軸要素以上のデータを探します
            while (l<=j && o[l].compareTo(x) < 0)  l++;
            // 軸要素未満のデータを探します
            while (r>=i && o[r].compareTo(x) >= 0) r--;
            if (l>r) break;
            R t=o[l];
            o[l]=o[r];
            o[r]=t;
            l++; 
            r--;
        }
        return l;
    }

    private int _Partition(ArrayList<R> o, int i, int j, R x) {
        int l=i, r=j;
        while (l<=r) {
            while (l<=j && o.get(l).compareTo(x) < 0)  l++;
            while (r>=i && o.get(r).compareTo(x) >= 0) r--;
            if (l>r) break;
            R t=o.get(l);
            o.set(l, o.get(r));
            o.set(r, t);
            l++; 
            r--;
        }
        return l;
    }
}
public final class DrawColor {
    private boolean _isRGB;
    public boolean IsRGB() {
        return _isRGB;
    }
    /**
     カラーモードを設定する。
     trueの場合はRGB表現、falseの場合はHSB表現にする。
     */
    public void SetColorMode(boolean value) {
        _isRGB = value;
    }

    private float _p1, _p2, _p3, _alpha;

    public float GetRedOrHue() {
        return _p1;
    }
    public void SetRedOrHue(float value) {
        if (_isRGB && value > PConst.MAX_RED) {
            value = PConst.MAX_RED;
        } else if (!_isRGB && value > PConst.MAX_HUE) {
            value = PConst.MAX_HUE;
        }
        _p1 = value;
    }

    public float GetGreenOrSaturation() {
        return _p2;
    }
    public void SetGreenOrSaturation(float value) {
        if (_isRGB && value > PConst.MAX_GREEN) {
            value = PConst.MAX_GREEN;
        } else if (!_isRGB && value > PConst.MAX_SATURATION) {
            value = PConst.MAX_SATURATION;
        }
        _p2 = value;
    }

    public float GetBlueOrBrightness() {
        return _p3;
    }
    public void SetBlueOrBrightness(float value) {
        if (_isRGB && value > PConst.MAX_BLUE) {
            value = PConst. MAX_BLUE;
        } else if (!_isRGB && value > PConst.MAX_BRIGHTNESS) {
            value = PConst.MAX_BRIGHTNESS;
        }
        _p3 = value;
    }

    public float GetAlpha() {
        return _alpha;
    }
    public void SetAlpha(float value) {
        if (value > PConst.MAX_ALPHA) {
            value = PConst.MAX_ALPHA;
        }
        _alpha = value;
    }

    /**
     モードにより返ってくる値が異なる可能性があります。
     */
    public color GetColor() {
        _ChangeColorMode();
        return color(GetRedOrHue(), GetGreenOrSaturation(), GetBlueOrBrightness(), GetAlpha());
    }
    public void SetColor(float p1, float p2, float p3) {
        SetRedOrHue(p1);
        SetGreenOrSaturation(p2);
        SetBlueOrBrightness(p3);
    }
    public void SetColor(float p1, float p2, float p3, float p4) {
        SetColor(p1, p2, p3);
        SetAlpha(p4);
    }

    public DrawColor() {
        _InitParameterOnConstructor(true, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
    }

    public DrawColor(boolean isRGB) {
        if (_isRGB) {
            _InitParameterOnConstructor(_isRGB, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
        } else {
            _InitParameterOnConstructor(_isRGB, PConst.MAX_HUE, PConst.MAX_SATURATION, PConst.MAX_BRIGHTNESS, PConst.MAX_ALPHA);
        }
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, PConst.MAX_ALPHA);
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3, float p4) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, p4);
    }

    private void _InitParameterOnConstructor(boolean isRGB, float p1, float p2, float p3, float p4) {
        SetColorMode(isRGB);
        SetColor(p1, p2, p3, p4);
    }

    private void _ChangeColorMode() {
        if (_isRGB) {
            colorMode(RGB, PConst.MAX_RED, PConst.MAX_GREEN, PConst.MAX_BLUE, PConst.MAX_ALPHA);
        } else {
            colorMode(HSB, PConst.MAX_HUE, PConst.MAX_SATURATION, PConst.MAX_BRIGHTNESS, PConst.MAX_ALPHA);
        }
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (!(o instanceof DrawColor)) {
            return false;
        }
        DrawColor d = (DrawColor) o;
        return 
            IsRGB() == d.IsRGB() && 
            GetRedOrHue() == d.GetRedOrHue() && 
            GetGreenOrSaturation() == d.GetGreenOrSaturation() && 
            GetBlueOrBrightness() == d.GetBlueOrBrightness() && 
            GetAlpha() == d.GetAlpha();
    }
}
public class FEConst {
    public static final String CONFIG_PATH = "data/config/";
    public static final String DATABASE_PATH = "data/database/";
    public static final String SAVE_PATH = "data/save/";
    public static final String MAP_PATH = "data/map/";
    
    public static final int SYSTEM_MAP_GRID_PX = 40;
    public static final int SYSTEM_MAP_OBJECT_PX = 60;
    public static final int SYSTEM_MAP_MAX_HEIGHT = 50;
    public static final int SYSTEM_MAP_MAX_WIDTH = 50;
    
    //////////////////////////////////////////////////////
    // Static Config
    //////////////////////////////////////////////////////
    public static final int CONFIG_MAX_GOLD = 999999;
    public static final int CONFIG_MAX_EXP = 999999;
    public static final int CONFIG_MAX_HAVE_ITEMS = 5;
    public static final int CONFIG_MAX_STOCK_ITEMS = 200;
    public static final int CONFIG_MAX_APPEAR_ENEMIES = 50;
    public static final int CONFIG_MIN_GAIN_EXP = 1;
    public static final int CONFIG_LEADER_GAIN_EXP = 50;
    public static final int CONFIG_SUB_LEADER_GAIN_EXP = 30;
    public static final float CONFIG_CRITICAL_HIT_RATE = 3f;
    public static final float CONFIG_SPECIAL_HIT_RATE = 2f;
    public static final int CONFIG_MAX_LEVEL = 30;
    public static final int CONFIG_MAX_HP = 99;
    public static final int CONFIG_MAX_ATK = 40;
    public static final int CONFIG_MAX_MAT = 40;
    public static final int CONFIG_MAX_TEC = 40;
    public static final int CONFIG_MAX_SPD = 40;
    public static final int CONFIG_MAX_LUC = 40;
    public static final int CONFIG_MAX_DEF = 40;
    public static final int CONFIG_MAX_MDF = 40;
    public static final int CONFIG_MAX_MOV = 20;
    public static final int CONFIG_MAX_PRO = 30;
    
    //////////////////////////////////////////////////////
    // Class Type
    //////////////////////////////////////////////////////
    public static final int CLASS_TYPE_NORMAL = -200;
    public static final int CLASS_TYPE_SORCERER = -201;
    public static final int CLASS_TYPE_ARMOR = -202;
    public static final int CLASS_TYPE_RIDER = -203;
    public static final int CLASS_TYPE_FLYER = -204;
    
    //////////////////////////////////////////////////////
    // Weapon Type
    //////////////////////////////////////////////////////
    public static final int WEAPON_TYPE_FIGHTER = -300;
    public static final int WEAPON_TYPE_SORCERER = -301;
    public static final int WEAPON_TYPE_ARCHER = -302;
    
    //////////////////////////////////////////////////////
    // Difficulty
    //////////////////////////////////////////////////////
    public static final int DIFFICULTY_EASY = -1000;
    public static final int DIFFICULTY_NORMAL = -1001;
    public static final int DIFFICULTY_HARD = -1002;
    
    
    //////////////////////////////////////////////////////
    // Skill
    //////////////////////////////////////////////////////
    // スキル発動率の参照
    public static final int REF_HP = -2000;
    public static final int REF_ATK = -2001;
    public static final int REF_MAT = -2002;
    public static final int REF_TEC = -2003;
    public static final int REF_SPD = -2004;
    public static final int REF_LUC = -2005;
    public static final int REF_DEF = -2006;
    public static final int REF_MDF = -2007;
    public static final int REF_MOV = -2008;
    public static final int REF_PRO = -2009;
    public static final int REF_UNI = -2010;
    
    // スキルの特徴
    public static final int SKILL_FET_NONE = -2100;
    // 先制攻撃
    public static final int SKILL_FET_PREEMPTIVE = -2101;
    
    //////////////////////////////////////////////////////
    // State
    //////////////////////////////////////////////////////
    // 封印オプション
    public static final int STATE_SEALED_PHYSICS = -3000;
    public static final int STATE_SEALED_MAGIC = -3001;
    public static final int STATE_SEALED_CANE = -3002;
    public static final int STATE_SEALED_ITEM = -3003;
    
    // 行動制限オプション
    public static final int STATE_ACT_NONE = -3100;
    public static final int STATE_ACT_INACTIVITY = -3101;
    public static final int STATE_ACT_RUNWILDLY = -3102;
    public static final int STATE_ACT_AI = -3103;
    
    // 自動解除オプション
    public static final int STATE_RELEASE_NONE = -3200;
    public static final int STATE_RELEASE_BATTLE = -3201;
    public static final int STATE_RELEASE_ATTACK = -3202;
    public static final int STATE_RELEASE_BE_ATTACKED = -3203;
    
    //////////////////////////////////////////////////////
    // Item
    //////////////////////////////////////////////////////
    // アイテムの特徴
    public static final int ITEM_FET_NONE = -4000;
    public static final int ITEM_FET_RECOVER_HP = -4001;
    
    // 使用範囲
    public static final int ITEM_RANGE_OWN = -4100;
    public static final int ITEM_RANGE_REGION = -4101;
    public static final int ITEM_RANGE_ALL = -4102;
    
    // 使用フィルタ
    public static final int ITEM_FILTER_OWN = -4200;
    public static final int ITEM_FILTER_OTHER = -4201;
    
    //////////////////////////////////////////////////////
    // Weapon
    //////////////////////////////////////////////////////
    // 威力タイプ
    public static final int WEAPON_POWER_PHYSICS = -4500;
    public static final int WEAPON_POWER_MAGIC = -4501;
    public static final int WEAPON_POWER_UNKNOWN = -4502;
    
    //////////////////////////////////////////////////////
    // Map Object
    //////////////////////////////////////////////////////
    // 向き
    public static final int MAP_OBJ_DIR_UP = -5000;
    public static final int MAP_OBJ_DIR_DOWN = -5001;
    public static final int MAP_OBJ_DIR_RIGHT = -5002;
    public static final int MAP_OBJ_DIR_LEFT = -5003;
    
    //////////////////////////////////////////////////////
    // Unit
    //////////////////////////////////////////////////////
    // 行動パターン
    public static final int UNIT_ACT_ATTACK = -6000;
    public static final int UNIT_ACT_NOT_MOVE = -6001;
    
    // 攻撃優先
    public static final int UNIT_ATTACK_NORMAL = -6100;
    public static final int UNIT_ATTACK_ORGANIZATION = -6101;
    public static final int UNIT_ATTACK_PERSON = -6102;
    
    // 重要度
    public static final int UNIT_IMPORTANCE_NORMAL = -6200;
    public static final int UNIT_IMPORTANCE_SUB_LEADER = -6201;
    public static final int UNIT_IMPORTANCE_LEADER = -6202;
    
    //////////////////////////////////////////////////////
    // Battle Map
    //////////////////////////////////////////////////////
    // 先攻後攻(プレイヤーが)
    public static final int BATTLE_PHASE_FIRST = -7000;
    public static final int BATTLE_PHASE_AFTER = -7001;
    
    // 操作モード
    public static final int BATTLE_MAP_MODE_NORMAL = -7000;
    public static final int BATTLE_MAP_MODE_ACTIVE = -7001;
    public static final int BATTLE_MAP_MODE_MOVING = -7002;
    public static final int BATTLE_MAP_MODE_BACK_MENU = -7003;
}
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
        path = dataBaseFolderPath + "/terrain.json";
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
        path = dataBaseFolderPath + "/weapon_class.json";
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
        path = dataBaseFolderPath + "/state.json";
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
        path = dataBaseFolderPath + "/skill.json";
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
        path = dataBaseFolderPath + "/item.json";
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
        path = dataBaseFolderPath + "/weapon.json";
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
        path = dataBaseFolderPath + "/class.json";
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
        path = dataBaseFolderPath + "/unit.json";
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

    /**
     マップ規模
     */
    private PVector _mapSize;
    public PVector GetMapSize() {
        return _mapSize;
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
     自軍と敵軍のフェーズ判別
     */
    private int _phase;

    /**
     操作モード
     */
    private int _mode;

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

            // マップ基本情報
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
}
public final static class GeneralCalc {
    /**
     指定した座標同士のラジアン角を返す。
     座標2から座標1に向けての角度になるので注意。
     */
    public static float GetRad(float x1, float y1, float x2, float y2) {
        float y, x;
        y = y1 - y2;
        x = x1 - x2;
        if (y == 0 && x == 0) return 0;
        float a = atan(y/x);
        if (x < 0) a += PI;
        return a;
    }
}
public final class JsonArray extends JsonUtility {
    private ArrayList<String> _elem;

    public JsonArray() {
        _elem = new ArrayList<String>();
    }

    public JsonArray(String path) {
        this();
        Load(path);
    }

    public boolean IsNull() {
        return _elem == null;
    }

    public boolean IsEmpty() {
        return _elem.isEmpty();
    }

    public String GetString(int index, String defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }

        if (!_IsProper(obj, stringToken, stringToken)) {
            return defaultValue;
        }
        return _RemoveEscape(_RemoveSideString(obj));
    }

    public int GetInt(int index, int defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return int(obj);
    }

    public float GetFloat(int index, float defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return float(obj);
    }

    public boolean GetBoolean(int index, boolean defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        if (_elem.size()<=index) {
            return defaultValue;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return defaultValue;
        }
        return boolean(obj);
    }

    public JsonObject GetJsonObject(int index) {
        if (IsNull()) {
            return null;
        }
        if (_elem.size()<=index) {
            return null;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return null;
        }
        JsonObject jsonObj = new JsonObject();
        jsonObj.Parse(obj);
        return jsonObj;
    }

    public JsonArray GetJsonArray(int index) {
        if (IsNull()) {
            return null;
        }

        if (_elem.size()<=index) {
            return null;
        }
        String obj = _elem.get(index);
        if (obj == null) {
            return null;
        }
        JsonArray jsonArray = new JsonArray();
        jsonArray.Parse(obj);
        return jsonArray;
    }

    /**
     各パラメーターの追加
     */
    public void AddString(String elem) {
        AddElement(stringToken + elem + stringToken);
    }

    public void AddInt(int elem) {
        AddElement(elem);
    }

    public void AddFloat(float elem) {
        AddElement(elem);
    }

    public void AddBoolean(boolean elem) {
        AddElement(elem);
    }

    public void AddJsonObject(JsonObject elem) {
        AddElement(elem);
    }

    public void AddJsonArray(JsonArray elem) {
        AddElement(elem);
    }

    private void AddElement(Object elem) {
        _elem.add(elem.toString());
    }

    /**
     各パラメーターの設定
     */
    public void SetString(int index, String elem) {
        SetElement(index, stringToken + elem + stringToken);
    }

    public void SetInt(int index, int elem) {
        SetElement(index, elem);
    }

    public void SetFloat(int index, float elem) {
        SetElement(index, elem);
    }

    public void SetBoolean(int index, boolean elem) {
        SetElement(index, elem);
    }

    public void SetJsonObject(int index, JsonObject elem) {
        SetElement(index, elem);
    }

    public void SetJsonArray(int index, JsonArray elem) {
        SetElement(index, elem);
    }

    private void SetElement(int index, Object elem) {
        int elemSize=Size();
        if (index < 0) {
            println("IndexOutOfBoundsException : " + index);
        } else {
            if (elemSize <= index) {
                for (int i=index-elemSize; 0<=i; i--) {
                    _elem.add(null);
                }
            }
            _elem.set(index, elem.toString());
        }
    }

    public void RemoveElement(int index) {
        _elem.remove(index);
    }

    public void ClearElements() {
        _elem.clear();
    }

    public int Size() {
        return _elem.size();
    }

    /**
     指定した文字列からデータを生成し、それを自身に格納する。
     */
    public void Parse(String jsonContents) {
        if (jsonContents == null) return;

        // 最初が '[' 最後が ']' でなければ生成しない
        if (!_IsProper(jsonContents, beginArrayToken, endArrayToken)) return;

        _elem = _Split(trim(_RemoveSideString(jsonContents)));
    }

    /**
     Json文字列を ',' で区切ってリストで返す。
     */
    protected ArrayList<String> _Split(String jsonContents) {
        ArrayList<String> jsonPair = new ArrayList<String>();
        boolean isLiteral = false;
        int arrayDepth = 0, objectDepth = 0;
        char temp;
        int lastSplitIdx = 0;

        if (jsonContents.length()!=0) {
            for (int i=0; i<jsonContents.length(); i++) {
                temp = jsonContents.charAt(i);

                if (temp == stringToken) {
                    if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
                        isLiteral = !isLiteral;
                    }
                }
                if (!isLiteral) {
                    if (temp == beginArrayToken) {
                        arrayDepth++;
                    } else if (temp == endArrayToken) {
                        arrayDepth--;
                    } else if (temp == beginObjectToken) {
                        objectDepth++;
                    } else if (temp == endObjectToken) {
                        objectDepth--;
                    }
                }

                if (temp == commaToken && !isLiteral && arrayDepth==0 && objectDepth == 0) {
                    String elem=trim(jsonContents.substring(lastSplitIdx, i));
                    if (elem.equals("null")) {
                        elem=null;
                    }
                    jsonPair.add(elem);
                    lastSplitIdx = i + 1;
                }
            }
            jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));
        }
        return jsonPair;
    }

    public String toString() {
        try {
            String elem;
            String[] product = new String[_elem.size()];
            for (int i=0; i<_elem.size(); i++) {
                elem = _elem.get(i);
                if (elem == null) {
                    continue;
                }
                product[i] = elem;
            }
            return beginArrayToken + newLineToken + join(product, ",\n") + newLineToken + endArrayToken;
        } 
        catch(Exception e) {
            println(e);
            println("JsonArray can not express oneself!");
            return null;
        }
    }
}
public final class JsonObject extends JsonUtility {
    private HashMap<String, String> _elem;
    private ArrayList<String> _names;

    public JsonObject() {
        _elem = new HashMap<String, String>();
        _names = new ArrayList<String>();
    }

    public JsonObject(String path) {
        this();
        Load(path);
    }

    public boolean IsNull() {
        return _elem == null;
    }

    public boolean IsEmpty() {
        return _elem.isEmpty();
    }

    public boolean HasKey(String name) {
        return _elem.containsKey(name);
    }

    public String GetString(String name, String defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }

        if (!_IsProper(obj, stringToken, stringToken)) {
            return defaultValue;
        }
        return _RemoveEscape(_RemoveSideString(obj));
    }

    public int GetInt(String name, int defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return int(obj);
    }

    public float GetFloat(String name, float defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return float(obj);
    }

    public boolean GetBoolean(String name, boolean defaultValue) {
        if (IsNull()) {
            return defaultValue;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return defaultValue;
        }
        return boolean(obj);
    }

    public JsonObject GetJsonObject(String name) {
        if (IsNull()) {
            return null;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return null;
        }
        JsonObject jsonObj = new JsonObject();
        jsonObj.Parse(obj);
        return jsonObj;
    }

    public JsonArray GetJsonArray(String name) {
        if (IsNull()) {
            return null;
        }

        String obj = _elem.get(name);
        if (obj == null) {
            return null;
        }
        JsonArray jsonArray = new JsonArray();
        jsonArray.Parse(obj);
        return jsonArray;
    }

    public void SetString(String name, String elem) {
        SetElement(name, stringToken + elem + stringToken);
    }

    public void SetInt(String name, int elem) {
        SetElement(name, elem);
    }

    public void SetFloat(String name, float elem) {
        SetElement(name, elem);
    }

    public void SetBoolean(String name, boolean elem) {
        SetElement(name, elem);
    }

    public void SetJsonObject(String name, JsonObject elem) {
        SetElement(name, elem);
    }

    public void SetJsonArray(String name, JsonArray elem) {
        SetElement(name, elem);
    }

    private void SetElement(String name, Object elem) {
        if (!HasKey(name)) {
            _names.add(name);
        }
        if (elem == null) {
            _elem.put(name, null);
        } else {
            _elem.put(name, elem.toString());
        }
    }

    /**
     指定した文字列からデータを生成し、それを自身に格納する。
     */
    public void Parse(String jsonContents) {
        if (jsonContents == null) return;

        // 最初が '{' 最後が '}' でなければ生成しない
        if (!_IsProper(jsonContents, beginObjectToken, endObjectToken)) {
            return;
        }

        _elem.clear();
        _names.clear();

        ArrayList<String> jsonPair = _Split(_RemoveSideString(jsonContents));
        String[] pair = new String[2];
        char temp;

        for (int i=0, end=jsonPair.size(); i<end; i++) {
            String jsonElem = jsonPair.get(i);

            for (int j=0, end2=jsonElem.length(); j<end2; j++) {
                temp = jsonElem.charAt(j);

                if (temp == colonToken) {
                    pair[0] = trim(jsonElem.substring(0, j));
                    pair[1] = trim(jsonElem.substring(j+1));


                    if (_IsProper(pair[0], stringToken, stringToken)) {
                        pair[0] = _RemoveSideString(pair[0]);
                    } else {
                        println("Inappropriate name. There in no \"");
                        continue;
                    }
                    if (pair[1].equals("null")) {
                        pair[1]=null;
                    }
                    SetElement(pair[0], pair[1]);
                    break;
                }
            }
        }
    }

    /**
     Json文字列を ',' で区切ってリストで返す。
     */
    protected ArrayList<String> _Split(String jsonContents) {
        ArrayList<String> jsonPair = new ArrayList<String>();
        boolean isLiteral = false;
        int arrayDepth=0, objectDepth=0;
        char temp;
        int lastSplitIdx = 0;
        for (int i=0; i<jsonContents.length(); i++) {
            temp = jsonContents.charAt(i);

            if (temp == stringToken) {
                if (i == 0 || jsonContents.charAt(i - 1) != escapeToken) {
                    isLiteral = !isLiteral;
                }
            }
            if (!isLiteral) {
                if (temp == beginArrayToken) {
                    arrayDepth++;
                } else if (temp == endArrayToken) {
                    arrayDepth--;
                } else if (temp == beginObjectToken) {
                    objectDepth++;
                } else if (temp == endObjectToken) {
                    objectDepth--;
                }
            }

            if (temp == commaToken && !isLiteral && arrayDepth==0&&objectDepth==0) {
                jsonPair.add(trim(jsonContents.substring(lastSplitIdx, i)));
                lastSplitIdx = i + 1;
            }
        }
        jsonPair.add(trim(jsonContents.substring(lastSplitIdx)));

        return jsonPair;
    }

    public String toString() {
        try {
            String name, elem;
            String[] product = new String[_names.size()];
            for (int i=0, end=_names.size(); i<end; i++) {
                name = _names.get(i);
                elem = _elem.get(name);
                product[i] = stringToken + _InsertEscape(name) + stringToken + " : " + elem;
            }
            return beginObjectToken + newLineToken + join(product, ",\n") + newLineToken + endObjectToken;
        } 
        catch(Exception e) {
            println(e);
            println("JsonObject can not express oneself!");
            return null;
        }
    }
}
public abstract class JsonUtility {
    // pjsでなぜかchar型と直接的な比較を行うと失敗するので、このような冗長な定義をしています。
    public final char beginObjectToken = "{".charAt(0);
    public final char endObjectToken = "}".charAt(0);
    public final char beginArrayToken = "[".charAt(0);
    public final char endArrayToken = "]".charAt(0);
    public final char stringToken = "\"".charAt(0);
    public final char escapeToken = "\\".charAt(0);
    public final char commaToken = ",".charAt(0);
    public final char colonToken = ":".charAt(0);
    public final String newLineToken = "\n";

    public void Load(String path) {
        try {
            String[] jsonText = loadStrings(path);
            String json = join(trim(jsonText), "");
            Parse(json);
        } 
        catch (Exception e) {
            println(e);
        }
    }

    /**
     例外が発生した場合にキャッチせずに投げる。
     */
    public void LoadWithThrowException(String path) throws Exception {
        String[] jsonText = loadStrings(path);
        String json = join(trim(jsonText), "");
        Parse(json);
    }

    public void Save(String path) {
        try {
            saveStrings(path, new String[]{this.toString()});
        } 
        catch(Exception e) {
            println(e);
        }
    }

    public void SaveWithThrowException(String path) throws Exception {
        saveStrings(path, new String[]{this.toString()});
    }

    public abstract void Parse(String content);
    protected abstract ArrayList<String> _Split(String content);

    protected boolean _IsProper(String content, char beginToken, char endToken) {
        if (content.length()==0) {
            return false;
        }
        return content.charAt(0) == beginToken && content.charAt(content.length() - 1) == endToken;
    }

    protected String _InsertEscape(String content) {
        if (content == null) return null;

        ArrayList<String> product = new ArrayList<String>();
        int lastSplitIndex = 0;
        char temp;
        for (int i=0; i<content.length(); i++) {
            temp = content.charAt(i);

            if (temp == escapeToken || temp == stringToken) {
                product.add(content.substring(lastSplitIndex, i) + escapeToken);
                lastSplitIndex = i;
            }
        }
        product.add(content.substring(lastSplitIndex, content.length()));
        String[] proArray = new String[product.size()];
        for (int i=0; i< proArray.length; i++) {
            proArray[i] = product.get(i);
        }

        return join(proArray, "");
    }

    protected String _RemoveEscape(String content) {
        if (content == null) return null;

        ArrayList<String> product = new ArrayList<String>();
        int lastSplitIndex = 0;
        char temp, temp2;
        for (int i=0; i<content.length(); i++) {
            temp = content.charAt(i);

            if (temp == escapeToken && i < content.length() - 1) {
                temp2 = content.charAt(i + 1);
                if (temp2 == escapeToken || temp2 == stringToken) {
                    product.add(content.substring(lastSplitIndex, i));
                    lastSplitIndex = i + 1;
                }
            }
        }
        product.add(content.substring(lastSplitIndex, content.length()));
        String[] proArray = new String[product.size()];
        for (int i=0; i< proArray.length; i++) {
            proArray[i] = product.get(i);
        }
        return join(proArray, "");
    }

    protected String _RemoveSideString(String content) {
        if (content == null) return null;
        return content.substring(1, content.length() - 1);
    }
}
/**
 定数を定義するクラス。
 pjsでもエンジンでも扱える共通の値。
 */
public final class PConst {
    // 色
    public static final int MAX_RED = 255;
    public static final int MAX_GREEN = 255;
    public static final int MAX_BLUE = 255;
    public static final int MAX_HUE = 360;
    public static final int MAX_SATURATION = 100;
    public static final int MAX_BRIGHTNESS = 100;
    public static final int MAX_ALPHA = 255;
    
    // 画像のルートパス
    public static final String IMAGE_PATH = "data/image/";
}

/**
ObjectBehavior及びサブクラスを特定するためのIDを定義する責任を持つ。
*/
public final class ClassID {
    // Basic Behavior
    public static final int CID_BEHAVIOR = 0;
    public static final int CID_TRANSFORM = 1;
    public static final int CID_DRAW_BACK = 2;
    public static final int CID_DRAW_BASE = 3;
    public static final int CID_IMAGE = 4;
    public static final int CID_TEXT = 5;
    public static final int CID_BUTTON = 6;
    
    public static final int CID_TOGGLE_BUTTON = 7;
    public static final int CID_DRAG_HANDLER = 8;
    public static final int CID_TIMER = 9;
    public static final int CID_DURATION = 10;
    
    public static final int CID_TITLE_BUTTON = 1000;
    public static final int CID_TITLE_DUST_EFFECT = 1001;
    public static final int CID_TITLE_DUST_IMAGE = 1002;
    public static final int CID_TITLE_BUTTON_BACK = 1003;
    
    public static final int CID_FE_MAP_OBJECT_DRAWER = 10000;
    public static final int CID_FE_MAP_MOUSE_CURSOR = 10001;
    public static final int CID_FE_MAP_UNIT_VIEWER = 10002;
}

public final class SceneID {
    public static final String SID_DIALOG = "Dialog";
    public static final String SID_TITLE = "Title";
    public static final String SID_GAMEOVER = "Gameover";
    public static final String SID_ILLUST = "One Illust";
    public static final String SID_FE_BATTLE_MAP = "FE Battle Map";
}

public final class Key {
    // 使用するキーの総数
    public final static int KEY_NUM = 45;

    // キーコード定数
    public final static int KEYCODE_0 = 48;
    public final static int KEYCODE_A = 65;

    // 数字
    public final static int _0 = 0;
    public final static int _1 = 1;
    public final static int _2 = 2;
    public final static int _3 = 3;
    public final static int _4 = 4;
    public final static int _5 = 5;
    public final static int _6 = 6;
    public final static int _7 = 7;
    public final static int _8 = 8;
    public final static int _9 = 9;

    // アルファベット
    public final static int _A = 10;
    public final static int _B = 11;
    public final static int _C = 12;
    public final static int _D = 13;
    public final static int _E = 14;
    public final static int _F = 15;
    public final static int _G = 16;
    public final static int _H = 17;
    public final static int _I = 18;
    public final static int _J = 19;
    public final static int _K = 20;
    public final static int _L = 21;
    public final static int _M = 22;
    public final static int _N = 23;
    public final static int _O = 24;
    public final static int _P = 25;
    public final static int _Q = 26;
    public final static int _R = 27;
    public final static int _S = 28;
    public final static int _T = 29;
    public final static int _U = 30;
    public final static int _V = 31;
    public final static int _W = 32;
    public final static int _X = 33;
    public final static int _Y = 34;
    public final static int _Z = 35;

    // 特殊キー
    public final static int _UP = 36;
    public final static int _DOWN = 37;
    public final static int _RIGHT = 38;
    public final static int _LEFT = 39;
    public final static int _ENTER = 40;
    //public final static int _ESC = 41;
    public final static int _DEL = 42;
    public final static int _BACK = 43;
    public final static int _SHIFT = 44;
}
public final class PHash<R> {
    private HashMap<String, R> _elements;
    public HashMap<String, R> GetElements() {
        return _elements;
    }

    public PHash() {
        _elements = new HashMap<String, R>();
    }

    public void Add(String label, R elem) {
        if (ContainsKey(label)) return;
        Set(label, elem);
    }

    public void Set(String label, R elem) {
        if (elem == null) return;
        GetElements().put(label, elem);
    }

    public R Get(String label) {
        return GetElements().get(label);
    }

    public R Remove(String label) {
        return GetElements().remove(label);
    }

    public void RemoveAll() {
        GetElements().clear();
    }

    public boolean ContainsKey(String label) {
        return GetElements().containsKey(label);
    }
}
public interface Copyable<R> {
    public void CopyTo(R copy);
}

public interface IEvent {
    public void Event();
}

public interface ITimer {
    public void OnInit();
    public void OnTimeOut();
}

public interface IDuration {
    public void OnInit();
    public void OnUpdate();
    public void OnEnd();
    public boolean IsContinue();
}
/**
 平面上のある領域の基準点を保持する責任を持つ。
 */
public class Pivot {
    private PVector _pivot;
    public PVector GetPivot() {
        return _pivot;
    }
    public void SetPivot(PVector value) {
        if (value == null) return;
        _pivot.set(value.x, value.y);
    }
    public void SetPivot(float x, float y) {
        if (x < 0 || 1 < x || y < 0 || 1 < y) return;
        _pivot.set(x, y);
    }

    public final static float P_LEFT = 0;
    public final static float P_CENTER = 0.5;
    public final static float P_RIGHT = 1;
    public final static float P_TOP = 0;
    public final static float P_BOTTOM = 1;

    public Pivot() {
        _InitParametersOnConstructor(null);
    }

    public Pivot(PVector value) {
        _InitParametersOnConstructor(value);
    }

    public Pivot(float x, float y) {
        _InitParametersOnConstructor(new PVector(x, y));
    }

    private void _InitParametersOnConstructor(PVector pivot) {
        _pivot = new PVector(P_LEFT, P_TOP);
        if (pivot == null) pivot = new PVector(P_LEFT, P_TOP);
        SetPivot(pivot);
    }

    public float GetX() {
        return GetPivot().x;
    }

    public float GetY() {
        return GetPivot().y;
    }

    public void SetX(float value) {
        SetPivot(value, GetY());
    }

    public void SetY(float value) {
        SetPivot(GetX(), value);
    }
}

/**
 平面上のある領域の基準点を二つ保持する責任を持つ。
 */
public class Anchor {
    private Pivot _min, _max;

    public PVector GetMin() {
        return _min.GetPivot();
    }
    public void SetMin(PVector value) {
        if (value == null) return;
        SetMin(value.x, value.y);
    }

    public void SetMin(float x, float y) {
        float temp;
        if (x > GetMax().x) {
            temp = GetMax().x;
            _max.SetX(x);
            x = temp;
        }
        if (y > GetMax().y) {
            temp = GetMax().y;
            _max.SetY(y);
            y = temp;
        }
        _min.SetPivot(x, y);
    }

    public PVector GetMax() {
        return _max.GetPivot();
    }
    public void SetMax(PVector value) {
        if (value == null) return;
        SetMax(value.x, value.y);
    }

    public void SetMax(float x, float y) {
        float temp;
        if (x < GetMin().x) {
            temp = GetMin().x;
            _min.SetX(x);
            x = temp;
        }
        if (y < GetMin().y) {
            temp = GetMin().y;
            _min.SetY(y);
            y = temp;
        }
        _max.SetPivot(x, y);
    }

    public Anchor() {
        _InitParametersOnConstructor(Pivot.P_LEFT, Pivot.P_TOP, Pivot.P_RIGHT, Pivot.P_BOTTOM);
    }

    public Anchor(float minX, float minY, float maxX, float maxY) {
        _InitParametersOnConstructor(minX, minY, maxX, maxY);
    }

    private void _InitParametersOnConstructor(float minX, float minY, float maxX, float maxY) {
        _min = new Pivot(minX, minY);
        _max = new Pivot(maxX, maxY);
    }

    public float GetMinX() {
        return GetMin().x;
    }
    public float GetMinY() {
        return GetMin().y;
    }
    public float GetMaxX() {
        return GetMax().x;
    }
    public float GetMaxY() {
        return GetMax().y;
    }
    public void SetMinX(float value) {
        SetMin(value, GetMinY());
    }
    public void SetMinY(float value) {
        SetMin(GetMinX(), value);
    }
    public void SetMaxX(float value) {
        SetMax(value, GetMaxY());
    }
    public void SetMaxY(float value) {
        SetMax(GetMaxX(), value);
    }
}
public final class InputManager {
    private boolean[] _pressedKeys;
    private boolean[] GetPressedKeys() {
        return _pressedKeys;
    }

    private boolean[] _clickedKeys;
    private boolean[] GetClickedKeys() {
        return _clickedKeys;
    }


    private ActionEvent _mousePressedHandler;
    public ActionEvent GetMousePressedHandler() {
        return _mousePressedHandler;
    }

    private ActionEvent _mouseReleasedHandler;
    public ActionEvent GetMouseReleasedHandler() {
        return  _mouseReleasedHandler;
    }

    private ActionEvent _mouseClickedHandler;
    public ActionEvent GetMouseClickedHandler() {
        return _mouseClickedHandler;
    }

    private ActionEvent _mouseWheelHandler;
    public ActionEvent GetMouseWheelHandler() {
        return _mouseWheelHandler;
    }

    private ActionEvent _mouseMovedHandler;
    public ActionEvent GetMouseMovedHandler() {
        return _mouseMovedHandler;
    }

    private ActionEvent _mouseDraggedHandler;
    public ActionEvent GetMouseDraggedHandler() {
        return _mouseDraggedHandler;
    }

    private ActionEvent _mouseEnteredHandler;
    public ActionEvent GetMouseEnteredHandler() {
        return _mouseEnteredHandler;
    }

    private ActionEvent _mouseExitedHandler;
    public ActionEvent GetMouseExitedHandler() {
        return _mouseExitedHandler;
    }

    private ActionEvent _keyPressedHandler;
    public ActionEvent GetKeyPressedHandler() {
        return _keyPressedHandler;
    }

    private ActionEvent _keyReleasedHandler;
    public ActionEvent GetKeyReleasedHandler() {
        return _keyReleasedHandler;
    }

    private ActionEvent _keyClickedHandler;
    public ActionEvent GetKeyClickedHandler() {
        return _keyClickedHandler;
    }

    /**
     マウス操作を何かしら行った場合、trueになる。
     キー操作を何かしら行った場合、falseになる。
     */
    private boolean _isMouseMode;
    public boolean IsMouseMode() {
        return _isMouseMode;
    }
    private void SetMouseMode(boolean value) {
        _isMouseMode = value;
    }

    private boolean _isMousePressed, _preMousePressed;

    public InputManager() {
        _pressedKeys = new boolean[Key.KEY_NUM];
        _clickedKeys = new boolean[Key.KEY_NUM];

        _mousePressedHandler = new ActionEvent();
        _mouseReleasedHandler = new ActionEvent();
        _mouseClickedHandler = new ActionEvent();
        _mouseWheelHandler = new ActionEvent();
        _mouseMovedHandler = new ActionEvent();
        _mouseDraggedHandler = new ActionEvent();
        _mouseEnteredHandler = new ActionEvent();
        _mouseExitedHandler = new ActionEvent();
        _keyPressedHandler = new ActionEvent();
        _keyReleasedHandler = new ActionEvent();
        _keyClickedHandler = new ActionEvent();

        _InitInputEvent();
    }

    private void _InitInputEvent() {
        GetMouseEnteredHandler().GetEvents().Add("Mouse Entered Window", new IEvent() { 
            public void Event() {
                if (isProcessing) {
                    println("Mouse Enterd on Window!");
                }
            }
        }
        );

        GetMouseExitedHandler().GetEvents().Add("Mouse Exited Window", new IEvent() {
            public void Event() {
                if (isProcessing) {
                    println("Mouse Exited from Window!");
                }
            }
        }
        );
    }

    /**
     シーンマネージャの後に呼び出される必要がある。
     */
    public void Update() {
        _preMousePressed = _isMousePressed;
    }

    public void KeyPressed() {
        SetMouseMode(false);
        int code = KeyCode2Key();
        if (code >= 0 && code < Key.KEY_NUM) {
            GetPressedKeys()[code] = true;
        }

        GetKeyPressedHandler().InvokeAllEvents();
    }

    public void KeyReleased() {
        SetMouseMode(false);
        int code = KeyCode2Key();
        if (code >= 0 && code < Key.KEY_NUM) {
            GetPressedKeys()[code] = false;
            GetClickedKeys()[code] = true;
        }

        GetKeyReleasedHandler().InvokeAllEvents();
        GetKeyClickedHandler().InvokeAllEvents();

        // クリックされたキーの判定は同フレームで消滅させる
        if (code >= 0 && code < Key.KEY_NUM) {
            GetClickedKeys()[code] = false;
        }
    }

    public void MousePressed() {
        _isMousePressed = true;
        SetMouseMode(true);
        GetMousePressedHandler().InvokeAllEvents();
    }

    public void MouseReleased() {
        _isMousePressed = false;
        SetMouseMode(true);
        GetMouseReleasedHandler().InvokeAllEvents();
    }

    public void MouseClicked() {
        SetMouseMode(true);
        GetMouseClickedHandler().InvokeAllEvents();
    }

    public void MouseWheel() {
        SetMouseMode(true);
        GetMouseWheelHandler().InvokeAllEvents();
    }

    public void MouseMoved() {
        SetMouseMode(true);
        GetMouseMovedHandler().InvokeAllEvents();
    }

    public void MouseDragged() {
        SetMouseMode(true);
        GetMouseDraggedHandler().InvokeAllEvents();
    }

    public void MouseEntered() {
        SetMouseMode(true);
        GetMouseEnteredHandler().InvokeAllEvents();
    }

    public void MouseExited() {
        SetMouseMode(true);
        GetMouseExitedHandler().InvokeAllEvents();
    }

    /**
     これを呼び出した時点で押されている最後のキーのキーコードをKey列挙定数に変換して返す。
     */
    public int KeyCode2Key() {
        switch(keyCode) {
        case UP:
            return Key._UP;
        case DOWN:
            return Key._DOWN;
        case RIGHT:
            return Key._RIGHT;
        case LEFT:
            return Key._LEFT;
        case ENTER:
            return Key._ENTER;
        case BACKSPACE:
            return Key._BACK;
        case DELETE:
            return Key._DEL;
        case SHIFT:
            return Key._SHIFT;
        default:
            int k = keyCode;
            if (k >= Key.KEYCODE_0 && k < Key.KEYCODE_0 + 10) {
                // 数字
                return Key._0 + k - Key.KEYCODE_0;
            } else if (k >= Key.KEYCODE_A && k < Key.KEYCODE_A + 26) {
                // アルファベット
                return Key._A + k - Key.KEYCODE_A;
            } else {
                return -1;
            }
        }
    }

    private boolean _CheckOutOfKeyBounds(int i) {
        return i < 0 || i >= Key.KEY_NUM;
    }

    /**
     引数で与えられた列挙定数のキーが押されている状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsPressedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetPressedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーだけが押されている状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsPressedKeyOnly(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (i == input) {
                continue;
            } else if (GetPressedKeys()[i]) {
                return false;
            }
        }
        return GetPressedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーがクリックされた状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsClickedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetClickedKeys()[input];
    }

    /**
     引数で与えられた列挙定数のキーだけがクリックされた状態ならtrueを、そうでなければfalseを返す。
     通常の判定処理よりも高速である。
     */
    public boolean IsClickedKeyOnly(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (i == input) {
                continue;
            } else if (GetClickedKeys()[i]) {
                return false;
            }
        }
        return GetClickedKeys()[input];
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーが押されている状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsPressedKeys(int[] inputs) {
        if (inputs == null) {
            return false;
        }
        for (int i=0; i<inputs.length; i++) {
            if (_CheckOutOfKeyBounds(inputs[i])) {
                return false;
            } else if (!GetPressedKeys()[inputs[i]]) {
                return false;
            }
        }
        return true;
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーがクリックされた状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsClickedKeys(int[] inputs) {
        if (inputs == null) {
            return false;
        }
        for (int i=0; i<inputs.length; i++) {
            if (_CheckOutOfKeyBounds(inputs[i])) {
                return false;
            } else if (!GetClickedKeys()[inputs[i]]) {
                return false;
            }
        }
        return true;
    }

    public boolean IsMouseDown() {
        return _isMousePressed && !_preMousePressed;
    }

    public boolean IsMouseStay() {
        return _isMousePressed && _preMousePressed;
    }

    public boolean IsMouseUp() {
        return !_isMousePressed && _preMousePressed;
    }
}

public final class FontManager {
    private HashMap<String, PFont> _fonts;
    private HashMap<String, PFont> GetFontHash() {
        return _fonts;
    }

    public FontManager() {
        _fonts = new HashMap<String, PFont>();
    }

    public PFont GetFont(String path) {
        if (GetFontHash().containsKey(path)) {
            return GetFontHash().get(path);
        }
        PFont font =  createFont(path, 100, true);
        if (font != null) {
            GetFontHash().put(path, font);
        }
        return font;
    }
}

public final class ImageManager {
    private HashMap<String, PImage> _images;
    private HashMap<String, PImage> GetImageHash() {
        return _images;
    }

    public ImageManager() {
        _images = new HashMap<String, PImage>();
    }

    public PImage GetImage(String path) {
        path = PConst.IMAGE_PATH + path;
        if (GetImageHash().containsKey(path)) {
            return GetImageHash().get(path);
        }
        PImage image = requestImage(path);
        if (image != null) {
            GetImageHash().put(path, image);
        }
        return image;
    }
}

public class TransformManager {
    public static final int MAX_DEPTH = 32;

    private int _depth;

    public TransformManager() {
        _depth = 0;
    }

    public boolean PushDepth() {
        if (_depth >= MAX_DEPTH) return false;
        _depth++;
        return true;
    }

    public boolean PopDepth() {
        if (_depth < 0) return false;
        _depth--;
        return true;
    }

    public void ResetDepth() {
        _depth = 0;
    }
}

public class SceneManager {
    /**
     保持しているシーン。
     */
    private HashMap<String, Scene> _scenes;
    public HashMap<String, Scene> GetScenes() {
        return _scenes;
    }

    /**
     実際に描画するシーンのリスト。
     シーンの優先度によって描画順が替わる。
     */
    private ArrayList<Scene> _drawScenes;
    public ArrayList<Scene> GetDrawScenes() {
        return _drawScenes;
    }

    /**
     入力を受け付けることができるシーン。
     */
    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }

    /**
     ソートに用いる。
     */
    private Collection<Scene> _collection;

    private SceneObjectTransform _transform, _dummyTransform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    public SceneManager () {
        _scenes = new HashMap<String, Scene>();
        _drawScenes = new ArrayList<Scene>();
        _collection = new Collection<Scene>();

        _transform = new SceneObjectTransform();
        _transform.SetSize(width, height);
        _transform.SetPivot(0, 0);

        _dummyTransform = new SceneObjectTransform();
    }

    /**
     シーンマップから描画シーンリストにシーンを追加する。
     */
    public void LoadScene(String sceneName) {
        // シーンマップに存在しないなら何もしない
        if (!_scenes.containsKey(sceneName)) return;
        Scene s = _scenes.get(sceneName);

        // 既に描画リストに存在するなら何もしない
        if (_drawScenes.contains(s)) return;

        s.Load();
    }

    /**
     描画シーンリストからシーンを外す。
     */
    public void ReleaseScene(String sceneName) {
        // シーンマップに存在しないなら何もしない
        if (!_scenes.containsKey(sceneName)) return;
        Scene s = _scenes.get(sceneName);

        // 描画リストに存在しないなら何もしない
        if (!_drawScenes.contains(s)) return;        

        s.Release();
    }

    /**
     描画シーンを全て外す。
     */
    public void ReleaseAllScenes() {
        for (int i=0; i<_drawScenes.size(); i++) {
            ReleaseScene(_drawScenes.get(i).GetName());
        }
    }

    public void Start() {
        _InitScenes();
    }

    /**
     フレーム更新を行う。
     */
    public void Update() {
        _OnUpdate();
        _OnTransform();
        _OnSorting();
        _OnCheckMouseActiveScene();
        _OnDraw();
        _OnCheckScene();
    }

    private void _OnUpdate() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Update();
        }
    }

    private void _OnTransform() {

        GetTransform().TransformMatrixOnRoot();
    }

    private void _OnSorting() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Sorting();
        }
    }

    private void _OnCheckMouseActiveScene() {
        if (!inputManager.IsMouseMode()) return;
        if (_drawScenes == null) return;
        Scene s;
        boolean f = false;
        for (int i=_drawScenes.size()-1; i>=0; i--) {
            s = _drawScenes.get(i);
            if (s.IsAbleActiveScene()) {
                f = true;
                // 現在のASが次のASになるならば、何もせずに処理を終わる。
                if (s == _activeScene) break;

                if (_activeScene != null) {
                    _activeScene.OnDisabledActive();
                }
                _activeScene = s;
                _activeScene.OnEnabledActive();
                return;
            }
        }
        // 何もアクティブにならなければアクティブシーンも無効化する
        if (!f) {
            if (_activeScene != null) {
                _activeScene.OnDisabledActive();
                _activeScene = null;
            }
        }
        if (_activeScene != null) {
            _activeScene.CheckMouseActiveObject();
        }
    }

    private void _OnDraw() {
        if (_drawScenes == null) return;
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            s.Draw();
        }
    }

    /**
     シーンの読込と解放を処理する。
     */
    private void _OnCheckScene() {
        Scene s;
        for (int i=0; i<_drawScenes.size(); i++) {
            s = _drawScenes.get(i);
            if (!s.IsReleaseFlag()) continue;

            _drawScenes.remove(s);
            s.OnDisabled();
            s.GetTransform().SetParent(_dummyTransform, false);
        }
        boolean f = false;
        for (String n : _scenes.keySet()) {
            s = _scenes.get(n);
            if (!s.IsLoadFlag()) continue;

            _drawScenes.add(s);
            s.OnEnabled();
            s.GetTransform().SetParent(_transform, false);
            f = true;
        }
        if (f) {
            _collection.SortList(_drawScenes);
        }
    }

    /**
     シーンインスタンスを初期化する。
     主にシーンそのもののソーティングと、シーン内のソーティングなどである。
     */
    private void _InitScenes() {
        if (_scenes == null) return;
        Scene s;
        for (String name : _scenes.keySet()) {
            s = _scenes.get(name);
            s.InitScene();
        }

        if (_drawScenes == null) return;
        _collection.SortList(_drawScenes);
    }

    /**
     シーンマップにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        if (scene == null) return false;
        if (GetScene(scene.GetName()) != null) return false;
        _scenes.put(scene.GetName(), scene);
        scene.GetTransform().SetParent(_dummyTransform, false);
        return true;
    }

    /**
     シーンマップの中からnameと一致する名前のシーンを返す。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene GetScene(String name) {
        return _scenes.get(name);
    }

    /**
     シーンマップの中からnameと一致するシーンを削除する。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene RemoveScene(String name) {
        return _scenes.remove(name);
    }
}
public class Scene implements Comparable<Scene> {
    private String _name;
    public String GetName() {
        return _name;
    }

    /**
     ソートするのに用いる。
     */
    private Collection<SceneObject> _collection;

    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    private SceneObjectDrawBack _drawBack;
    public SceneObjectDrawBack GetDrawBack() {
        return _drawBack;
    }

    /**
     描画優先度。
     トランスフォームのものとは使用用途が異なるので分けている。
     */
    private int _scenePriority;
    public int GetScenePriority() {
        return _scenePriority;
    }
    public void SetScenePriority(int value) {
        _scenePriority = value;
    }

    /**
     読込待ちの場合、trueを返す。
     */
    private boolean _isLoadFlag;
    public final boolean IsLoadFlag() {
        return _isLoadFlag;
    }
    public final void Load() {
        _isLoadFlag = true;
    }

    /**
     解放待ちの場合、trueを返す。
     */
    private boolean _isReleaseFlag;
    public final boolean IsReleaseFlag() {
        return _isReleaseFlag;
    }
    public final void Release() {
        _isReleaseFlag = true;
    }

    /**
     オブジェクトの優先度変更が発生している場合はtrueになる。
     これがtrueでなければソートはされない。
     */
    private boolean _isNeedSorting;
    public void SetNeedSorting(boolean value) {
        _isNeedSorting = value;
    }

    public Scene (String name) {
        _name = name;
        _collection = new Collection<SceneObject>();
        _objects = new ArrayList<SceneObject>();

        _transform = new SceneObjectTransform();
        _drawBack = new SceneObjectDrawBack();
    }

    /**
     シーンの初期化を行う。
     ゲーム開始時に呼び出される。
     */
    public void InitScene() {
        _isNeedSorting = true;
        Sorting();
    }

    /**
     シーンマネージャの描画リストに追加された時に呼び出される。
     */
    public void OnEnabled() {
        _isLoadFlag = false;
        _OnStart();
    }

    /**
     シーンマネージャの描画リストから外された時に呼び出される。
     */
    public void OnDisabled() {
        _isReleaseFlag = false;
        _OnStop();
    }

    /**
     シーンマネージャのアクティブシーンになった時に呼び出される。
     */
    public void OnEnabledActive() {
        CheckMouseActiveObject();
    }

    /**
     シーンマネージャのノンアクティブシーンになった時に呼び出される。
     */
    public void OnDisabledActive() {
        if (_activeObject != null) {
            _activeObject.OnDisabledActive();
            _activeObject = null;
        }
    }

    public boolean IsAbleActiveScene() {
        return _transform.IsInRegion(mouseX, mouseY);
    }

    public void Update() {
        _OnStart();
        _OnUpdate();
    }

    /**
     フレームの最初に呼び出される。
     Stopと異なり、オブジェクトごとにタイミングが異なるのでフレーム毎に呼び出される。
     */
    protected void _OnStart() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Start();
            }
        }
    }

    /**
     フレームの最後に呼び出される。
     一度しか呼び出されない。
     オブジェクトの有効フラグに関わらず必ず呼び出す。
     */
    protected void _OnStop() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            s.Stop();
        }
    }

    /**
     毎フレーム呼び出される。
     入力待ちやオブジェクトのアニメーション処理を行う。
     */
    protected void _OnUpdate() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Update();
            }
        }
    }

    /**
     オブジェクトのトランスフォームの優先度によってソートする。
     毎度処理していると重くなるのフラグが立っている時のみ処理する。
     */
    public void Sorting() {
        if (!_isNeedSorting) return;
        _isNeedSorting = false;
        _collection.SortList(GetObjects());
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     ただし、マウス操作している時だけしか判定しない。
     */
    public void CheckMouseActiveObject() {
        if (!inputManager.IsMouseMode()) return;
        SceneObject s;
        boolean f = false;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsAbleActiveObject()) {
                f = true;
                // 現在のMAOが次のMAOになるならば、何もせずに処理を終わる。
                if (s == _activeObject) return;

                if (_activeObject != null) {
                    _activeObject.OnDisabledActive();
                }
                _activeObject = s;
                _activeObject.OnEnabledActive();
                return;
            }
        }
        // 何もアクティブにならなければアクティブオブジェクトも無効化する
        if (!f) {
            if (_activeObject != null) {
                _activeObject.OnDisabledActive();
            }
            _activeObject = null;
        }
    }

    /**
     ドローバックとイメージ系の振る舞いを持つオブジェクトの描画を行う。
     */
    public void Draw() {
        _DrawScene();

        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Draw();
            }
        }
    }

    /**
     シーン背景を描画する。
     */
    private void _DrawScene() {
        noStroke();
        fill(GetDrawBack().GetBackColorInfo().GetColor());
        GetTransform().GetTransformProcessor().TransformProcessing();
        PVector s = GetTransform().GetSize();
        rect(0, 0, s.x, s.y);
    }

    /**
     毎回オブジェクトのSetParentを呼び出すのが面倒なので省略のために用意。
     */
    public final void AddChild(SceneObject o) {
        if (o == null) return;

        o.GetTransform().SetParent(GetTransform(), true);
    }

    /**
     自身のリストにオブジェクトを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) return false;
        object.SetScene(this);
        return _objects.add(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを返す。
     負数を指定した場合、後ろからindex番目のオブジェクトを返す。
     
     @return index番目のオブジェクト 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject GetObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のオブジェクトを返す。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject GetObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したオブジェクトが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public final boolean RemoveObject(SceneObject object) {
        return _objects.remove(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを削除する。
     負数を指定した場合、後ろからindex番目のオブジェクトを削除する。
     
     @return index番目のオブジェクト 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject RemoveObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.remove(index);
    }

    /**
     自身のリストの中からnameと一致するオブジェクトを削除する。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject RemoveObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return _objects.remove(i);
            }
        }
        return null;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (!(o instanceof Scene)) {
            return false;
        }
        Scene s = (Scene) o;
        return GetName().equals(s.GetName());
    }

    public int compareTo(Scene o) {
        return GetScenePriority() - o.GetScenePriority();
    }
}
/**
 戦闘マップ及びマップイベントを描画するシーン。
 */
public class FESceneBattleMap extends Scene {
    private SceneObject mapImageObj, terrainImageObj, hazardAreaObj, actionRangeObj, mapElementObj, cursorObj, unitViewObj;

    private SceneObjectImage mapImage;

    private FEMapMouseCursor mapCursor;
    public FEMapMouseCursor GetMapCursor() {
        return mapCursor;
    }

    public FESceneBattleMap() {
        super(SceneID.SID_FE_BATTLE_MAP);

        SceneObjectTransform objT;

        mapImageObj = new SceneObject("Map Image Object", this);
        mapImage = new SceneObjectImage(mapImageObj, null);
        objT = mapImageObj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        mapCursor = new FEMapMouseCursor(mapImageObj);

        mapElementObj = new SceneObject("Map Element Object", this);
        objT = mapElementObj.GetTransform();
        objT.SetParent(mapImageObj.GetTransform(), true);
        objT.SetPriority(objT.GetPriority() + 4);
        new FEMapObjectDrawer(mapElementObj);

        unitViewObj = new SceneObject("Unit View Object", this);
        new FEMapUnitViewer(unitViewObj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        FEBattleMapManager bm = feManager.GetBattleMapManager();
        SceneObjectTransform objT = mapImageObj.GetTransform();

        objT.SetSize(bm.GetMapSize().x * FEConst.SYSTEM_MAP_GRID_PX, bm.GetMapSize().y * FEConst.SYSTEM_MAP_GRID_PX);
        mapImage.SetUsingImageName(bm.GetMapImagePath());
    }
}

/**
 ユニットオブジェクトの描画を行う振る舞い。
 */
public class FEMapObjectDrawer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_DRAWER;
    }

    private FEBattleMapManager bm;
    private int offset;

    private SceneObjectTimer timer;
    private String timerLabel;
    private int cnt, normalIdx, runIdx;

    public FEMapObjectDrawer(SceneObject obj) {
        super();

        timer = new SceneObjectTimer(obj);
        timerLabel = "FEMapObjectDrawer CountTimer";

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        bm = feManager.GetBattleMapManager();
        offset = (FEConst.SYSTEM_MAP_GRID_PX - FEConst.SYSTEM_MAP_OBJECT_PX) / 2;
        cnt = 0;

        timer.GetTimers().Add(timerLabel, new ITimer() {
            public void OnInit() {
                cnt = ++cnt % 2;
                runIdx = ++runIdx % 6;
                if (cnt == 0) {
                    normalIdx = ++normalIdx % 6;
                }
            }

            public void OnTimeOut() {
                timer.ResetTimer(timerLabel, 0.1);
                timer.Start(timerLabel);
            }
        }
        );
        timer.ResetTimer(timerLabel, 0.1);
        timer.Start(timerLabel);
    }

    public void Draw() {
        super.Draw();

        FEMapElement e;
        FEMapObject o;
        PVector pos;
        int x, y;
        String imgPath;
        for (int i=0; i<bm.GetMapElements().size(); i++) {
            e = bm.GetMapElements().get(i);
            o = e.GetMapObject();
            if (o == null) continue;
            if (o.GetMapImageFolderPath() == null) continue;

            imgPath = o.GetMapImageFolderPath() + "/N" + _DrawIdx(runIdx) + ".png";
            if (imageManager.GetImage(imgPath) == null) continue;
            pos = e.GetPosition();
            x = int(pos.x);
            y = int(pos.y);
            x = x * FEConst.SYSTEM_MAP_GRID_PX + offset;
            y = y * FEConst.SYSTEM_MAP_GRID_PX + offset;
            image(imageManager.GetImage(imgPath), x, y, FEConst.SYSTEM_MAP_OBJECT_PX, FEConst.SYSTEM_MAP_OBJECT_PX);
        }
    }

    private int _DrawIdx(int idx) {
        switch(idx) {
        case 4:
        case 5:
            return 0;
        case 1:
        case 2:
            return 2;
        default:
            return 1;
        }
    }
}

/**
 マウス座標を戦闘マップ座標の相対座標に変換する。
 */
public class FEMapMouseCursor extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_MOUSE_CURSOR;
    }

    private float _x, _y;
    public float GetX() {
        return _x;
    }
    public float GetY() {
        return _y;
    }

    private int _mapX, _mapY;
    public int GetMapX() {
        return _mapX;
    }
    public int GetMapY() {
        return _mapY;
    }

    private SceneObjectTransform _objT;
    private PMatrix2D _objM;
    private float[] _in, _out;
    private int _mapW, _mapH;

    public FEMapMouseCursor(SceneObject obj) {
        super();    
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
        _in = new float[2];
        _out = new float[2];
        _mapW = (int)feManager.GetBattleMapManager().GetMapSize().x;
        _mapH = (int)feManager.GetBattleMapManager().GetMapSize().y;
    }

    /**
     UpdateはTransformする前なので、その直後のDrawで正確な逆演算を行う。
     */
    public void Draw() {
        super.Draw();
        if (_objT == null) return;
        _objM = _objT.GetMatrix().get();
        if (!_objM.invert()) return;
        _in[0] = mouseX;
        _in[1] = mouseY;
        _objM.mult(_in, _out);
        _in[0] = _out[0];
        _in[1] = _out[1];
        _objM.mult(_in, _out);
        _x = _out[0];
        _y = _out[1];

        _mapX = _mapY = -999;
        for (int i=0; i<_mapW; i++) {
            if (_IsInGrid(i, _x)) {
                _mapX = i;
                break;
            }
        }
        for (int i=0; i<_mapH; i++) {
            if (_IsInGrid(i, _y)) {
                _mapY = i;
                break;
            }
        }

        stroke(200, 0, 0);
        strokeWeight(2);
        rect(_mapX * FEConst.SYSTEM_MAP_GRID_PX + 2, _mapY * FEConst.SYSTEM_MAP_GRID_PX + 2, FEConst.SYSTEM_MAP_GRID_PX - 4, FEConst.SYSTEM_MAP_GRID_PX - 4);
    }

    private boolean _IsInGrid(int idx, float p) {
        return FEConst.SYSTEM_MAP_GRID_PX * idx <= p && p < FEConst.SYSTEM_MAP_GRID_PX * (idx + 1);
    }
}

/**
 マップを参照してカーソルが重なったところにいるキャラクタの概要を表示する。
 */
public class FEMapUnitViewer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_UNIT_VIEWER;
    }

    private FEMapMouseCursor _mapCur;
    private SceneObjectTransform _objT;

    private SceneObject _prmBackObj, _faceBackObj;
    private SceneObjectDrawBack _prmBack, _faceBack;
    private SceneObjectImage _faceImg;

    public FEMapUnitViewer(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }

    public void Start() {
        super.Start();

        GetObject().SetActivatable(false);
        _objT = GetObject().GetTransform();
        _objT.AddPriority(500);
        _objT.SetAnchor(1, 0.5, 1, 0.5);
        _objT.SetPivot(1, 0.5);
        _objT.SetSize(320, 70);
        FESceneBattleMap sbm = (FESceneBattleMap) GetObject().GetScene();
        _mapCur = sbm.GetMapCursor();

        SceneObjectTransform objT;
        SceneObjectDrawBack objD;

        _prmBackObj = new SceneObject("Unit Parameter Viewer Back", sbm);
        _prmBackObj.SetActivatable(false);
        objT = _prmBackObj.GetTransform();
        objT.SetParent(_objT, true);
        objT.SetSize(240, 0);
        objT.SetAnchor(1, 0, 1, 1);
        objT.SetPivot(1, 0.5);
        objT.SetTranslation(-5, 0);
        _prmBack = _prmBackObj.GetDrawBack();
        _prmBack.SetCorner(7);
        _prmBack.SetEnable(true, false);

        SceneObject _prmFrontObj = new SceneObject("Unit Parameter Viewer Front", sbm);
        _prmFrontObj.SetActivatable(false);
        objT = _prmFrontObj.GetTransform();
        objT.SetParent(_prmBackObj.GetTransform(), true);
        objT.SetAnchor(0, 1, 1, 1);
        objT.SetPivot(0.5, 1);
        objT.SetOffsetMin(4, 0);
        objT.SetOffsetMax(-4, 0);
        objT.SetTranslation(0, -4);
        objT.SetSize(0, 35);
        objD = _prmFrontObj.GetDrawBack();
        objD.SetCorner(7);
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(255, 250, 220);

        _faceBackObj = new SceneObject("Unit Face Viewer Back", sbm);
        _faceBackObj.SetActivatable(false);
        objT  = _faceBackObj.GetTransform();
        objT.SetParent(_objT, true);
        objT.SetSize(70, 0);
        objT.SetAnchor(1, 0, 1, 1);
        objT.SetPivot(1, 0.5);
        objT.SetTranslation(-250, 0);
        _faceBack = _faceBackObj.GetDrawBack();
        _faceBack.SetCorner(7);
        _faceBack.SetEnable(true, false);

        SceneObject _faceFrontObj = new SceneObject("Unit Face Viewer Front", sbm);
        _faceFrontObj.SetActivatable(false);
        objT = _faceFrontObj.GetTransform();
        objT.SetParent(_faceBackObj.GetTransform(), true);
        objT.SetOffsetMin(4, 4);
        objT.SetOffsetMax(-4, -4);
        objD = _faceFrontObj.GetDrawBack();
        objD.SetEnable(true, false);
        objD.GetBackColorInfo().SetColor(40, 10, 10);
        _faceImg = new SceneObjectImage(_faceFrontObj, null);
    }

    public void Update() {
        super.Update();
        if (_mapCur == null) {
            _objT.SetScale(0, 0);
            return;
        }
        FEMapElement elem = feManager.GetBattleMapManager().GetMapElementOnPos(_mapCur.GetMapX(), _mapCur.GetMapY());
        if (elem == null) {
            _objT.SetScale(0, 0);
        } else {
            if (!(elem.GetMapObject() instanceof FEUnit)) {
                _objT.SetScale(0, 0);
                return;
            }
            _objT.SetScale(1, 1);

            boolean f = _mapCur.GetMapY() < feManager.GetBattleMapManager().GetMapSize().y / 2;
            _objT.SetTranslation(0, (f?1:-1) * ((height - _objT.GetSize().y) / 2 - 5));
            FEUnit unit = (FEUnit)elem.GetMapObject();
            if (unit.GetFaceImagePath() == null) {
                _faceBackObj.GetTransform().SetScale(0, 0);
            } else {
                _faceBackObj.GetTransform().SetScale(1, 1);
                _faceImg.SetUsingImageName(unit.GetFaceImagePath());
            }
            _prmBack.GetBackColorInfo().SetColor(20, 60, 130);
            _faceBack.GetBackColorInfo().SetColor(20, 60, 130);
            //if (feManager.GetBattleMapManager().GetSortieUnits().contains(unit)) {
            //    _prmBack.GetBackColorInfo().SetColor(20, 60, 130);
            //    _faceBack.GetBackColorInfo().SetColor(20, 60, 130);
            //} else if (feManager.GetBattleMapManager().GetSortieEnemyUnits().contains(unit)) {
            //    _prmBack.GetBackColorInfo().SetColor(150, 0, 20);
            //    _faceBack.GetBackColorInfo().SetColor(150, 0, 20);
            //}
        }
    }
}
/**
 ダイアログメッセージを表示するためだけのシーン。
 */
public class SceneDialog extends Scene {
    private SceneObject _back, _header, _contents, _buttonObj;
    private SceneObjectText _headerText, _contentsText;
    private SceneObjectButton _button;

    public SceneDialog() {
        super(SceneID.SID_DIALOG);

        SceneObjectTransform objT;
        SceneObjectDrawBack objD;

        _back = new SceneObject("Dialog Back", this);
        objT = _back.GetTransform();
        objT.SetAnchor(0.5, 0.5, 0.5, 0.5);
        objT.SetPivot(0.5, 0.5);
        objT.SetSize(320, 200);
        objD = _back.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(240, 240, 240);

        _header = new SceneObject("Header", this);
        objT = _header.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        objT.SetSize(0, 40);
        objD = _header.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(200, 200, 200);
        _headerText = new SceneObjectText();
        _header.AddBehavior(_headerText);
        _headerText.SetAlign(CENTER, CENTER);
        _headerText.SetFontSize(14);
        _headerText.GetColorInfo().SetColor(0, 0, 0);

        _contents = new SceneObject("Contents", this);
        objT = _contents.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetOffsetMin(0, 40);
        objT.SetOffsetMax(0, -40);
        objD = _contents.GetDrawBack();
        _contentsText = new SceneObjectText();
        _contents.AddBehavior(_contentsText);
        _contentsText.SetAlign(CENTER, CENTER);
        _contentsText.SetFontSize(14);
        _contentsText.GetColorInfo().SetColor(0, 0, 0);

        _buttonObj = new SceneObject("Button", this);
        objT = _buttonObj.GetTransform();
        objT.SetParent(_back.GetTransform(), true);
        objT.SetAnchor(0.5, 1, 0.5, 1);
        objT.SetPivot(0.5, 1);
        objT.SetSize(60, 30);
        objT.SetTranslation(0, -10);
        objD = _buttonObj.GetDrawBack();
        objD.SetEnable(true);
        objD.GetBackColorInfo().SetColor(255, 255, 255);
        SceneObjectText t = new SceneObjectText(_buttonObj, "ＯＫ");
        t.SetAlign(CENTER, CENTER);
        t.SetFontSize(12);
        t.GetColorInfo().SetColor(0, 0, 0);
        _button = new SceneObjectButton(_buttonObj, "System Dialog Button");
        _button.GetDecideHandler().GetEvents().Add("Hide", new IEvent() {
            public void Event() {
                Hide();
            }
        }
        );
    }

    public void OnEnabled() {
        super.OnEnabled();
        GetDrawBack().GetBackColorInfo().SetColor(200, 200, 200, 100);
        SetScenePriority(9999);
    }

    public void Show(String message) {
        Show("", message);
    }

    public void Show(String title, String message) {
        _headerText.SetText(title);
        _contentsText.SetText(message);
        sceneManager.LoadScene(SceneID.SID_DIALOG);
    }

    public void Hide() {
        sceneManager.ReleaseScene(SceneID.SID_DIALOG);
        background(0);
        exit();
    }
}
public final class SceneGameOver extends Scene {
    private String gameOverBack, gameOverLabel, clickLabel, adjustLayer;
    private String[] sword;

    public SceneGameOver() {
        super(SceneID.SID_GAMEOVER);
        GetDrawBack().GetBackColorInfo().SetColor(0, 0, 0);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        gameOverBack = "GameOverBack";
        gameOverLabel = "GameOverLabel";
        clickLabel = "ClickLabel";
        adjustLayer = "GameOverAdjustLayer";
        sword = new String[7];
        for (int i=0; i<sword.length; i++) {
            sword[i] = "sword" + i;
        }

        SceneObject obj;
        SceneObjectTransform objT;
        SceneObjectButton btn;
        SceneObjectDuration dur;
        SceneObjectTimer timer;

        // クリックしたらタイトルに戻るボタン
        obj = new SceneObject("TitleBackButton", this);
        obj.GetTransform().SetPriority(10);
        btn = new SceneObjectButton(obj, "GameOver TitleBackButton");
        btn.GetDecideHandler().GetEvents().Add("Go Title", new IEvent() {
            public void Event() {
                SceneTitle t = (SceneTitle)sceneManager.GetScene(SceneID.SID_TITLE);
                t.GoTitle();
            }
        }
        );

        // フレームアウト調整レイヤー
        obj = new SceneObject(adjustLayer, this);
        obj.GetTransform().SetPriority(9);
        obj.GetDrawBack().SetEnable(true);
        obj.GetDrawBack().SetEnableBorder(false);
        obj.GetDrawBack().GetBackColorInfo().SetColor(1, 1, 1);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Clean Out", new IDuration() {
            private SceneObjectDrawBack drawBack;
            private SceneObjectDuration duration;
            private float settedTime;
            public void OnInit() {
                drawBack = GetObject(adjustLayer).GetDrawBack();
                drawBack.GetBackColorInfo().SetAlpha(255);
                drawBack.SetEnable(true);
                duration = (SceneObjectDuration)GetObject(adjustLayer).GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = duration.GetSettedTimer("Clean Out");
            }
            public boolean IsContinue() {
                return drawBack.GetBackColorInfo().GetAlpha() > 0;
            }
            public void OnUpdate() {
                float a = drawBack.GetBackColorInfo().GetAlpha();
                if (settedTime <= 0) {
                    OnEnd();
                } else {
                    drawBack.GetBackColorInfo().SetAlpha(a - 255/(frameRate*settedTime));
                }
            }
            public void OnEnd() {
                drawBack.SetEnable(false);
                drawBack.GetBackColorInfo().SetAlpha(0);
            }
        }
        );

        // 背景
        obj = new SceneObject(gameOverBack, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 1, 0);
        objT.SetPivot(0.5, 0);
        new SceneObjectImage(obj, "gameover/back.png");
        dur = new SceneObjectDuration(obj);
        dur.SetUseTimer("Back Gradation", false);
        dur.GetDurations().Set("Back Gradation", new IDuration() {
            private SceneObject _obj;
            private SceneObjectTransform _objT;
            private float settedTime;
            public void OnInit() {
                _obj = GetObject(gameOverBack);
                _objT = _obj.GetTransform();
                _objT.SetSize(0, 0);
                SceneObjectImage img = (SceneObjectImage)_obj.GetBehaviorOnID(ClassID.CID_IMAGE);
                img.GetColorInfo().SetAlpha(255);
                SceneObjectDuration _dur = (SceneObjectDuration)_obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Back Gradation");
            }
            public boolean IsContinue() {
                return _objT.GetSize().y < height;
            }
            public void OnUpdate() {
                float y = _objT.GetSize().y;
                if (settedTime <= 0) {
                    _objT.SetSize(0, height);
                } else {
                    _objT.SetSize(0, y + height/(frameRate*settedTime));
                }
            }
            public void OnEnd() {
            }
        }
        );


        // 剣
        for (int i=0; i<sword.length; i++) {
            obj = new SceneObject(sword[i]);
            AddObject(obj);
            objT = obj.GetTransform();
            objT.SetAnchor(0.5, 0.5, 0.5, 0.5);
            new SceneObjectImage(obj, "gameover/" + sword[i] + ".png");
            if (i == 0) {
                AddChild(obj);
                objT.SetPriority(3);
            } else {
                objT.SetParent(GetObject(sword[0]).GetTransform(), true);
            }
        }

        obj = GetObject(sword[0]);
        dur = new SceneObjectDuration(obj);
        timer = new SceneObjectTimer(obj);
        timer.GetTimers().Add("Fire Start Event", new ITimer() {
            public void OnInit() {
            }
            public void OnTimeOut() {
                SceneObjectDuration dur = (SceneObjectDuration)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_DURATION);
                dur.ResetTimer("Rotate Sword", 1);
                dur.SetUseTimer("Rotate Sword", true);
                dur.Start("Rotate Sword");
            }
        }
        );
        dur.GetDurations().Add("Rotate Sword", new IDuration() {
            private SceneObjectTransform _objT;
            private SceneObjectImage _img;
            private SceneObjectDuration _dur;
            private float settedTime;

            public void OnInit() {
                _objT = GetObject(sword[0]).GetTransform();
                _objT.SetSize(131, 388);
                _objT.SetTranslation(0, -100);
                _objT.SetScale(4, 4);
                _objT.SetRotate(-1);
                _img = (SceneObjectImage)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_IMAGE);
                _img.GetColorInfo().SetColor(0, 0, 0, 255);
                _dur = (SceneObjectDuration)GetObject(sword[0]).GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Rotate Sword");
            }
            public boolean IsContinue() {
                return true;
            }
            public void OnUpdate() {
                float r = _objT.GetRotate();
                _objT.SetRotate(r + 2/(frameRate * settedTime));
                float x, y;
                x = _objT.GetScale().x - 3/(frameRate * settedTime);
                y = _objT.GetScale().y - 3/(frameRate * settedTime);
                _objT.SetScale(x, y);
            }
            public void OnEnd() {
                GetDrawBack().GetBackColorInfo().SetColor(0, 0, 0);
                _img.GetColorInfo().SetAlpha(1);
                _dur = (SceneObjectDuration)GetObject(gameOverBack).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Back Gradation", 1);
                _dur.Start("Back Gradation");

                _dur = (SceneObjectDuration)GetObject(gameOverLabel).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Down", 1.5);
                _dur.Start("Down");

                _dur = (SceneObjectDuration)GetObject(clickLabel).GetBehaviorOnID(ClassID.CID_DURATION);
                _dur.ResetTimer("Up", 1.5);
                _dur.Start("Up");

                SceneObject obj;
                for (int i=1; i<sword.length; i++) {
                    obj = GetObject(sword[i]);
                    _objT = obj.GetTransform();
                    _objT.SetSize(131, 388);
                    _img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
                    _img.GetColorInfo().SetAlpha(100);
                    switch(i) {
                    case 1:
                        _objT.SetTranslation(10, -10);
                        _objT.SetRotate(radians(10));
                        break;
                    case 2:
                        _objT.SetTranslation(-5, -10);
                        _objT.SetRotate(radians(-10));
                        break;
                    case 3:
                        _objT.SetTranslation(5, 10);
                        _objT.SetRotate(radians(18));
                        break;
                    case 4:
                        _objT.SetTranslation(-10, 0);
                        _objT.SetRotate(radians(-10));
                        break;
                    case 5:
                        _objT.SetTranslation(25, 15);
                        _objT.SetRotate(radians(8));
                        break;
                    case 6:
                        _objT.SetTranslation(-5, 40);
                        _objT.SetRotate(radians(-5));
                        break;
                    }
                }
            }
        }
        );

        // ゲームオーバーテキスト
        obj = new SceneObject(gameOverLabel, this);
        new SceneObjectImage(obj, "gameover/gameover.png");
        objT = obj.GetTransform();
        objT.SetPriority(8);
        objT.SetSize(547, 100);
        objT.SetAnchor(0.5, 0, 0.5, 0);
        objT.SetPivot(0.5, 0);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Down", new IDuration() {
            private SceneObjectTransform _objT;
            private DrawColor _draw;
            private SceneObjectDuration _dur;
            private float settedTime;
            public void OnInit() {
                SceneObject obj = GetObject(gameOverLabel);
                _objT = obj.GetTransform();
                _objT.SetTranslation(0, 50);
                _draw = ((SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Down");
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                if (settedTime <= 0) {
                    _objT.SetTranslation(0, 80);
                    _draw.SetColor(0, 155, 205, 255);
                } else {
                    PVector t = _objT.GetTranslation();
                    color c = _draw.GetColor();
                    float d = frameRate * settedTime;
                    _objT.SetTranslation(t.x, t.y + 30/d);
                    _draw.SetColor(red(c) - 255/d, green(c) - 100/d, blue(c) - 50/d, alpha(c) + 255/d);
                }
            }
            public void OnEnd() {
                _objT.SetTranslation(0, 80);
                _draw.SetAlpha(255);
                _dur.Start("Flash");
            }
        }
        );
        dur.SetUseTimer("Down", true);
        dur.GetDurations().Add("Flash", new IDuration() {
            private DrawColor _draw;
            private float _rad;
            public void OnInit() {
                _draw = ((SceneObjectImage)GetObject(clickLabel).GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _rad = 0;
            }
            public boolean IsContinue() {
                return true;
            }
            public void OnUpdate() {
                _draw.SetAlpha(100 * cos(_rad) + 155);
                _rad += PI/frameRate;
                _rad %= TWO_PI;
            }
            public void OnEnd() {
            }
        }
        );

        // クリックテキスト
        obj = new SceneObject(clickLabel, this);
        new SceneObjectImage(obj, "gameover/click.png");
        objT = obj.GetTransform();
        objT.SetPriority(8);
        objT.SetSize(327, 37);
        objT.SetAnchor(0.5, 1, 0.5, 1);
        objT.SetPivot(0.5, 1);
        dur = new SceneObjectDuration(obj);
        dur.GetDurations().Add("Up", new IDuration() {
            private SceneObjectTransform _objT;
            private DrawColor _draw;
            private SceneObjectDuration _dur;
            private float settedTime;
            public void OnInit() {
                SceneObject obj = GetObject(clickLabel);
                _objT = obj.GetTransform();
                _objT.SetTranslation(0, -70);
                _draw = ((SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE)).GetColorInfo();
                _dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
                settedTime = _dur.GetSettedTimer("Up");
            }
            public boolean IsContinue() {
                return false;
            }
            public void OnUpdate() {
                if (settedTime <= 0) {
                    _objT.SetTranslation(0, -100);
                    _draw.SetColor(0, 155, 205, 255);
                } else {
                    PVector t = _objT.GetTranslation();
                    _objT.SetTranslation(t.x, t.y - 30/(frameRate * settedTime));
                    _draw.SetAlpha(_draw.GetAlpha() + 255/(frameRate * settedTime));
                }
            }
            public void OnEnd() {
                _objT.SetTranslation(0, -100);
                _draw.SetAlpha(255);
            }
        }
        );
        dur.SetUseTimer("Up", true);
    }

    public void OnEnabled() {
        super.OnEnabled();

        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);

        SceneObject obj;
        SceneObjectTransform objT;
        SceneObjectImage img;
        SceneObjectDuration dur;
        SceneObjectTimer timer;

        obj = GetObject(gameOverBack);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);

        obj = GetObject(adjustLayer);
        obj.GetDrawBack().GetBackColorInfo().SetAlpha(255);
        dur = (SceneObjectDuration)obj.GetBehaviorOnID(ClassID.CID_DURATION);
        dur.ResetTimer("Clean Out", 1);
        dur.Start("Clean Out");

        for (int i=1; i<sword.length; i++) {
            obj = GetObject(sword[i]);
            objT = obj.GetTransform();
            objT.SetTranslation(0, 0);
            objT.SetSize(0, 0);
            img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
            img.GetColorInfo().SetAlpha(1);
        }

        obj = GetObject(sword[0]);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        timer = (SceneObjectTimer)obj.GetBehaviorOnID(ClassID.CID_TIMER);
        timer.ResetTimer("Fire Start Event", 1);
        timer.Start("Fire Start Event");

        obj = GetObject(gameOverLabel);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        img.GetColorInfo().SetColor(255, 255, 255);

        obj = GetObject(clickLabel);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
        img.GetColorInfo().SetAlpha(1);
        img.GetColorInfo().SetColor(255, 255, 255);
    }

    public void OnDisabled() {
        super.OnDisabled();
    }

    public void GoGameOver() {
        sceneManager.ReleaseAllScenes();
        sceneManager.LoadScene(SceneID.SID_GAMEOVER);
    }
}
public class SceneObject implements Comparable<SceneObject> {
    private String _name;
    public String GetName() {
        return _name;
    }

    private ArrayList<SceneObjectBehavior> _behaviors;
    public ArrayList<SceneObjectBehavior> GetBehaviors() {
        return _behaviors;
    }

    private Scene _scene;
    public Scene GetScene() {
        return _scene;
    }
    public void SetScene(Scene value) {
        if (value == null) return;
        _scene = value;
    }

    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    private SceneObjectDrawBack _drawBack;
    public SceneObjectDrawBack GetDrawBack() {
        return _drawBack;
    }

    /**
     オブジェクトとして有効かどうかを管理するフラグ。
     */
    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public void SetEnable(boolean value) {
        _enable = value;
        if (_enable) {
            _OnEnable();
        } else {
            _OnDisable();
        }
        _SetEnableRecursive(value);
    }

    /**
    親オブジェクトの有効フラグが変更された時に同時に自身の有効フラグも変更するかどうか。
    trueの場合、自身の有効フラグも変更する。
    */
    private boolean _isAutoChangeEnable;
    public boolean IsAutoChangeEnable() {
        return _isAutoChangeEnable;
    }
    public void SetAutoChangeEnable(boolean value) {
        _isAutoChangeEnable = value;
    }
    
    private void _SetEnableRecursive(boolean value) {
        SceneObjectTransform trans = GetTransform();
        SceneObject obj;
        for (int i=0;i<trans.GetChildren().size();i++) {
            obj = trans.GetChildren().get(i).GetObject();
            if (!obj.IsAutoChangeEnable()) continue;
            obj.SetEnable(value);
        }
    }

    /**
     falseの場合、アクティブオブジェクトになり得ない。
     */
    private boolean _isActivatable;
    public boolean IsActivatable() {
        return _isActivatable;
    }
    public void SetActivatable(boolean value) {
        _isActivatable = value;
    }

    /**
     アクティブオブジェクトの時、trueを返す。
     */
    private boolean _isActiveObject;
    public boolean IsActiveObject() {
        return _isActiveObject;
    }

    public SceneObject(String name) {
        _InitParameterOnConstructor(name);
    }

    public SceneObject(String name, Scene scene) {
        _InitParameterOnConstructor(name);
        if (scene != null) {
            scene.AddObject(this);
            scene.AddChild(this);
        }
    }

    private void _InitParameterOnConstructor(String name) {
        _name = name;

        _behaviors = new ArrayList<SceneObjectBehavior>();
        _transform = new SceneObjectTransform();
        AddBehavior(_transform);

        _drawBack = new SceneObjectDrawBack();
        AddBehavior(_drawBack);
        
        // トランスフォームが設定されてからでないと例外を発生させてしまう
        SetEnable(true);
        SetActivatable(true);
        SetAutoChangeEnable(true);
    }

    public void Start() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable() && !b.IsStart()) {
                b.Start();
            }
        }
    }

    public void Stop() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            b.Stop();
        }
    }

    public void Update() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Update();
            }
        }
    }

    public void Draw() {
        GetTransform().GetTransformProcessor().TransformProcessing();

        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Draw();
            }
        }
    }

    public void Destroy() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            b.Destroy();
        }
        if (GetScene() == null) return;
        GetScene().RemoveObject(this);
    }

    public boolean IsAbleActiveObject() {
        return IsActivatable() && _transform.IsInRegion(mouseX, mouseY);
    }

    protected void _OnEnable() {
    }

    protected void _OnDisable() {
    }

    public void OnEnabledActive() {
        _isActiveObject = true;
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnEnabledActive();
            }
        }
    }

    public void OnDisabledActive() {
        _isActiveObject = false;
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnDisabledActive();
            }
        }
    }

    /**
     自身のリストに振る舞いを追加する。
     同じものが既に追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddBehavior(SceneObjectBehavior behavior) {
        if (IsHaveBehavior(behavior.GetID())) {
            return false;
        }
        behavior.SetObject(this);
        return _behaviors.add(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを返す。
     負数を指定した場合、後ろからindex番目の振る舞いを返す。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectBehavior GetBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.get(index);
    }

    /**
     自身のリストの中からIDに該当する振る舞いを返す。
     
     @return behaviorに該当するIDの振る舞い 存在しなければNull
     */
    public SceneObjectBehavior GetBehaviorOnID(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定した振る舞いが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveBehavior(SceneObjectBehavior behavior) {
        return _behaviors.remove(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを削除する。
     負数を指定した場合、後ろからindex番目の振る舞いを削除する。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectBehavior RemoveBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.remove(index);
    }

    /**
     自身のリストの中からIDに該当する振る舞いを削除する。
     
     @return behaviorに該当するIDの振る舞い 存在しなければNull
     */
    public SceneObjectBehavior RemoveBehaviorOnID(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return _behaviors.remove(i);
            }
        }
        return null;
    }

    public boolean IsHaveBehavior(int id) {
        SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.IsBehaviorAs(id)) {
                return true;
            }
        }
        return false;
    }

    /**
     自身が指定されたオブジェクトの親の場合、trueを返す。
     */
    public boolean IsParentOf(SceneObject s) {
        return _transform.IsParentOf(s.GetTransform());
    }

    /**
     自身が指定されたオブジェクトの子の場合、trueを返す。
     */
    public boolean IsChildOf(SceneObject s) {
        return _transform.IsChildOf(s.GetTransform());
    }

    /**
     自身の親のオブジェクトを取得する。
     ただし、有効フラグがfalseの場合、nullを返す。
     */
    public SceneObject GetParent() {
        SceneObject s = _transform.GetParent().GetObject();
        if (s == null) {
            return null;
        }
        return s;
    }

    public boolean equals(Object o) {
        return this == o;
    }

    public int compareTo(SceneObject o) {
        return GetTransform().compareTo(o.GetTransform());
    }
}
public class SceneObjectDragHandler extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DRAG_HANDLER;
    }

    private boolean _isActive, _isDragging, _preDragging;
    private String _eventLabel;

    private ActionEvent _draggedBeginHandler;
    public ActionEvent GetDraggedBeginHandler() {
        return _draggedBeginHandler;
    }

    private ActionEvent _draggedEndHandler;
    public ActionEvent GetDraggedEndHandler() {
        return _draggedEndHandler;
    }

    private ActionEvent _draggedActionHandler;
    public ActionEvent GetDraggedActionHandler() {
        return _draggedActionHandler;
    }

    private ActionEvent _enabledActiveHandler;
    public ActionEvent GetEnabledActiveHandler() {
        return _enabledActiveHandler;
    }

    private ActionEvent _disabledActiveHandler;
    public ActionEvent GetDisabledActiveHandler() {
        return _disabledActiveHandler;
    }

    public SceneObjectDragHandler(String eventLabel) {
        super();

        _eventLabel = eventLabel;
        _draggedBeginHandler = new ActionEvent();
        _draggedEndHandler = new ActionEvent();
        _draggedActionHandler = new ActionEvent();
        _enabledActiveHandler = new ActionEvent();
        _disabledActiveHandler = new ActionEvent();
    }

    public void OnEnabledActive() {
        super.OnEnabledActive();
        _isActive = true;
        GetEnabledActiveHandler().InvokeAllEvents();
    }

    public void OnDisabledActive() {
        super.OnDisabledActive();
        _isActive = false;
        GetDisabledActiveHandler().InvokeAllEvents();
    }

    public void Start() {
        super.Start();
        inputManager.GetMouseDraggedHandler().GetEvents().Add(_eventLabel, new IEvent() {
            public void Event() {
                if (!_isDragging) return;
                GetDraggedActionHandler().InvokeAllEvents();
            }
        }
        );
    }

    public void Update() {
        super.Update();

        if (_isActive) {
            if (inputManager.IsMouseDown()) {
                _isDragging = true;
                if (_isDragging != _preDragging) {
                    GetDraggedBeginHandler().InvokeAllEvents();
                }
            }
        }
        if (inputManager.IsMouseUp()) {
            _isDragging = false;
            if (_isDragging != _preDragging) {
                GetDraggedEndHandler().InvokeAllEvents();
            }
        }
        _preDragging = _isDragging;
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDragHandler is destroyed");
        }
    }
}
public abstract class SceneObjectBehavior {
    /**
     残念ながら全てのビヘイビアクラスがこれを継承して適切な値を返さなければならない。
     */
    public int GetID() {
        return ClassID.CID_BEHAVIOR;
    }

    /**
     振る舞いは一回だけオブジェクトを設定することができる。
     */
    private SceneObject _object;
    public SceneObject GetObject() {
        return _object;
    }
    public final void SetObject(SceneObject value) {
        if (_isSettedObject) return;
        if (value == null) return;
        _isSettedObject = true;
        _object = value;
    }
    private boolean _isSettedObject;

    public final Scene GetScene() {
        if (GetObject() == null) return null;
        return GetObject().GetScene();
    }

    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public final void SetEnable(boolean value) {
        _enable = value;
        if (_enable) {
            _OnEnabled();
        } else {
            _OnDisabled();
        }
    }

    private boolean _isStart;
    public boolean IsStart() {
        return _isStart;
    }

    public SceneObjectBehavior() {
        SetEnable(true);
    }

    public final boolean IsBehaviorAs(int id) {
        return GetID() == id;
    }

    public void Start() {
        _isStart = true;
    }

    public void Update() {
    }

    public void Draw() {
    }

    public void Stop() {
    }

    public final void Destroy() {
        //_OnDestroy();
        if (GetObject() == null) return;
        GetObject().RemoveBehavior(this);
    }

    protected abstract void _OnDestroy();

    protected void _OnEnabled() {
        _isStart = false;
    }

    protected void _OnDisabled() {
    }

    public void OnEnabledActive() {
    }

    public void OnDisabledActive() {
    }

    public boolean equals(Object o) {
        return this == o;
    }
}

public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    public int GetID() {
        return ClassID.CID_TRANSFORM;
    }

    private SceneObjectTransform _parent;
    public SceneObjectTransform GetParent() {
        return _parent;
    }
    /**
     親トランスフォームを設定する。
     自動的に前の親との親子関係は絶たれる。
     
     isPriorityChangeがtrueの場合、自動的に親の優先度より1だけ高い優先度がつけられる。
     */
    public void SetParent(SceneObjectTransform value, boolean isPriorityChange) {
        if (value == null) return;

        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        _parent = value;
        _parent._AddChild(this);
        if (isPriorityChange) {
            SetPriority(GetParent().GetPriority() + 1);
        }
    }

    private ArrayList<SceneObjectTransform> _children;
    public ArrayList<SceneObjectTransform> GetChildren() {
        return _children;
    }

    private Anchor _anchor;
    public Anchor GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(PVector min, PVector max) {
        if (_anchor == null) return;
        _anchor.SetMin(min);
        _anchor.SetMax(max);
    }
    public void SetAnchor(float minX, float minY, float maxX, float maxY) {
        if (_anchor == null) return;
        _anchor.SetMin(minX, minY);
        _anchor.SetMax(maxX, maxY);
    }

    private PVector _offsetMin, _offsetMax;
    public PVector GetOffsetMin() {
        return _offsetMin;
    }
    public void SetOffsetMin(float x, float y) {
        _offsetMin.set(x, y);
    }
    public PVector GetOffsetMax() {
        return _offsetMax;
    }
    public void SetOffsetMax(float x, float y) {
        _offsetMax.set(x, y);
    }


    private Pivot _pivot;
    public Pivot GetPivot() {
        return _pivot;
    }
    public void SetPivot(PVector value) {
        if (_pivot == null) return;
        _pivot.SetPivot(value);
    }
    public void SetPivot(float x, float y) {
        if (_pivot == null) return;
        _pivot.SetPivot(x, y);
    }

    /**
     優先度を自動的に変更するかどうかを許可するフラグ。
     trueの場合、自身の親の優先度が変更された時に自動的に親の優先度より1高い優先度になる。
     falseの場合、親の優先度によらず自身の優先度を保持し、自身の子にも伝播しない。
     */
    private boolean _isAutoChangePriority;
    public boolean IsAutoChangePriority() {
        return _isAutoChangePriority;
    }
    public void SetAutoChangePriority(boolean value) {
        _isAutoChangePriority = value;
    }

    /**
     優先度。
     階層構造とは概念が異なる。
     主に描画や当たり判定の優先度として用いられる。
     */
    private int _priority;
    public int GetPriority() {
        return _priority;
    }
    public void SetPriority(int value) {
        if (value >= 0 && _priority != value) {
            _priority = value;
            _SetPriorityRecursive(value + 1);

            if (GetScene() == null) return;
            GetScene().SetNeedSorting(true);
        }
    }
    private void _SetPriorityRecursive(int priority) {
        SceneObjectTransform trans;
        for (int i=0; i<_children.size(); i++) {
            trans = _children.get(i);
            if (!trans.IsAutoChangePriority()) continue;
            trans._priority = priority;
            trans._SetPriorityRecursive(priority + 1);
        }
    }
    public void AddPriority(int value) {
        if (value != 0) {
            SetPriority(_priority + value);
        }
    }

    private PMatrix2D _matrix, _inverse;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }

    private TransformProcessor _transformProcessor;
    public TransformProcessor GetTransformProcessor() {
        return _transformProcessor;
    }

    /**
     親空間での相対移動量、自空間での回転量、自空間でのスケール量を保持する。
     */
    private Transform _transform;
    public Transform GetTransform() {
        return _transform;
    }

    public PVector GetTranslation() {
        return _transform.GetTranslation();
    }
    public void SetTranslation(float x, float y) {
        _transform.SetTranslation(x, y);
    }

    public float GetRotate() {
        return _transform.GetRotate();
    }
    public void SetRotate(float rad) {
        _transform.SetRotate(rad);
    }

    public PVector GetScale() {
        return _transform.GetScale();
    }
    public void SetScale(float x, float y) {
        _transform.SetScale(x, y);
    }

    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    public SceneObjectTransform() {
        super();

        _transform = new Transform();
        _size = new PVector();

        _anchor = new Anchor();
        _pivot = new Pivot(0.5, 0.5);
        _offsetMin = new PVector();
        _offsetMax = new PVector();

        _isAutoChangePriority = true;
        _priority = 1;
        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
        _transformProcessor = new TransformProcessor();
    }

    public void InitTransform(float minAX, float minAY, float maxAX, float maxAY, float pX, float pY, float tX, float tY, float sX, float sY, float rad, float sizeX, float sizeY) {
        GetAnchor().SetMin(minAX, minAY);
        GetAnchor().SetMax(maxAX, maxAY);
        GetPivot().SetPivot(pX, pY);
        SetTranslation(tX, tY);
        SetScale(sX, sY);
        SetRotate(rad);
        SetSize(sizeX, sizeY);
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     */
    public void TransformMatrixOnRoot() {
        transformManager.ResetDepth();

        // これ以上階層を辿れない場合は変形させない
        if (!transformManager.PushDepth()) return;

        _transformProcessor.Init();
        _matrix.reset();

        _TransformMatrix();
        transformManager.PopDepth();
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     再帰的に呼び出される。
     */
    private void _TransformMatrixOnChild(TransformProcessor tp, PMatrix2D mat) {
        // これ以上階層を辿れない場合は変形させない
        if (!transformManager.PushDepth()) return;

        tp.CopyTo(_transformProcessor);
        _matrix = mat.get();

        _TransformMatrix();

        transformManager.PopDepth();
    }

    private void _TransformMatrix() {
        float x, y;
        x = GetTranslation().x;
        y = GetTranslation().y;
        if (GetParent() != null) {
            // アンカーの座標へ移動
            float aX, aY;
            aX = ((GetAnchor().GetMaxX() + GetAnchor().GetMinX()) * GetParent().GetSize().x + GetOffsetMin().x + GetOffsetMax().x) /2 ;
            aY = ((GetAnchor().GetMaxY() + GetAnchor().GetMinY()) * GetParent().GetSize().y + GetOffsetMin().y + GetOffsetMax().y) / 2;

            _transformProcessor.AddTranslate(aX, aY);
            _matrix.translate(aX, aY);

            if (GetAnchor().GetMaxX() != GetAnchor().GetMinX()) {
                aX = (GetAnchor().GetMaxX() - GetAnchor().GetMinX()) * GetParent().GetSize().x - GetOffsetMin().x + GetOffsetMax().x;
                x = 0;
                SetSize(aX, GetSize().y);
            }
            if (GetAnchor().GetMaxY() != GetAnchor().GetMinY()) {
                aY = (GetAnchor().GetMaxY() - GetAnchor().GetMinY()) * GetParent().GetSize().y - GetOffsetMin().y + GetOffsetMax().y;
                y = 0;
                SetSize(GetSize().x, aY);
            }
        }

        // 親空間での相対座標へ移動
        _transformProcessor.AddTranslate(x, y);
        _matrix.translate(x, y);

        // トランスフォームプロセッサへ追加する箇所を変更
        if (!_transformProcessor.NewDepth()) return;

        // 自空間での回転
        _transformProcessor.AddRotate(GetRotate());
        _matrix.rotate(GetRotate());

        // 自空間でのスケーリング
        _transformProcessor.AddScale(GetScale().x, GetScale().y);
        _matrix.scale(GetScale().x, GetScale().y);

        // ピボットの座標へ移動
        x = -GetPivot().GetX() * GetSize().x;
        y = -GetPivot().GetY() * GetSize().y;
        _transformProcessor.AddTranslate(x, y);
        _matrix.translate(x, y);

        // 再帰的に計算していく
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i)._TransformMatrixOnChild(_transformProcessor, _matrix);
            }
        }
    }

    /**
     指定座標がトランスフォームの領域内であればtrueを返す。
     */
    public boolean IsInRegion(float y, float x) {
        _inverse = _matrix.get();
        if (!_inverse.invert()) {
            println("逆アフィン変換ができません。");
            return false;
        }

        float[] _in, _out;
        _in = new float[]{y, x};
        _out = new float[2];
        _inverse.mult(_in, _out);
        return 0 <= _out[0] && _out[0] < _size.x && 0 <= _out[1] && _out[1] < _size.y;
    }

    public boolean IsParentOf(SceneObjectTransform t) {
        return this == t.GetParent();
    }

    public boolean IsChildOf(SceneObjectTransform t) {
        return _parent == t;
    }

    /**
     自身の子としてトランスフォームを追加する。
     ただし、既に子として存在している場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    private boolean _AddChild(SceneObjectTransform t) {
        if (GetChildren().contains(t)) {
            return false;
        }
        return _children.add(t);
    }

    public void AddChild(SceneObjectTransform t, boolean isChangePriority) {
        if (t == null) return;
        t.SetParent(this, isChangePriority);
    }

    /**
     自身のリストのindex番目のトランスフォームを返す。
     負数を指定した場合、後ろからindex番目のトランスフォームを返す。
     
     @return index番目のトランスフォーム 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectTransform GetChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.get(index);
    }

    /**
     自身のリストに指定したトランスフォームが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveChild(SceneObjectTransform t) {
        return _children.remove(t);
    }

    /**
     自身のリストのindex番目のトランスフォームを削除する。
     負数を指定した場合、後ろからindex番目のトランスフォームを削除する。
     
     @return index番目のトランスフォーム 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public SceneObjectTransform RemoveChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.remove(index);
    }

    /**
     自分以外の場合、falseを返す。
     */
    public boolean equals(Object o) {
        return this == o;
    }

    /**
     優先度によって比較を行う。
     */
    public int compareTo(SceneObjectTransform o) {
        return GetPriority() - o.GetPriority();
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectTransform is destroyed");
        }
    }
}

public class SceneObjectDrawBack extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DRAW_BACK;
    }

    private DrawColor _backColorInfo;
    public DrawColor GetBackColorInfo() {
        return _backColorInfo;
    }

    private DrawColor _borderColorInfo;
    public DrawColor GetBorderColorInfo() {
        return _borderColorInfo;
    }

    public void SetEnable(boolean enableBack, boolean enableBorder) {
        SetEnable(true);
        SetEnableBack(enableBack);
        SetEnableBorder(enableBorder);
    }

    /**
     背景の描画が有効かどうかを保持するフラグ。
     falseの場合、領域内部は透過される。
     */
    private boolean _enableBack;
    public boolean IsEnableBack() {
        return _enableBack;
    }
    public void SetEnableBack(boolean value) {
        _enableBack = value;
    }

    /**
     ボーダの描画が有効かどうかを保持するフラグ。
     falseの場合、領域周辺のボーダは描画されない。
     */
    private boolean _enableBorder;
    public boolean IsEnableBorder() {
        return _enableBorder;
    }
    public void SetEnableBorder(boolean value) {
        _enableBorder = value;
    }
    private float _borderSize;
    public float GetBorderSize() {
        return _borderSize;
    }
    public void SetBorderSize(float value) {
        _borderSize = value;
    }

    private int _borderType;
    public int GetBorderType() {
        return _borderType;
    }
    public void SetBorderType(int value) {
        _borderType = value;
    }

    /**
     四辺のカット半径
     */
    private float _tl, _tr, _bl, _br;
    public float GetTopLeft() {
        return _tl;
    }
    public void SetTopLeft(float value) {
        if (value >= 0) {
            _tl = value;
        }
    }
    public float GetTopRight() {
        return _tr;
    }
    public void SetTopRight(float value) {
        if (value >= 0) {
            _tr = value;
        }
    }
    public float GetBottomLeft() {
        return _bl;
    }
    public void SetBottomLeft(float value) {
        if (value >= 0) {
            _bl = value;
        }
    }
    public float GetBottomRight() {
        return _br;
    }
    public void SetBottomRight(float value) {
        if (value >= 0) {
            _br = value;
        }
    }
    public void SetCorner(float tl, float tr, float bl, float br) {
        SetTopLeft(tl);
        SetTopRight(tr);
        SetBottomLeft(bl);
        SetBottomRight(br);
    }
    public void SetCorner(float r) {
        SetCorner(r, r, r, r);
    }

    private PVector _size;

    public SceneObjectDrawBack() {
        DrawColor backInfo, borderInfo;
        backInfo = new DrawColor(true, 100, 100, 100, 255);
        borderInfo = new DrawColor(true, 0, 0, 0, 255);

        // 基本的に非表示
        SetEnable(false);

        _InitParameterOnConstructor(true, backInfo, true, borderInfo, 1, ROUND);
    }

    private void _InitParameterOnConstructor(boolean enableBack, DrawColor backInfo, boolean enableBorder, DrawColor borderInfo, float borderSize, int borderType) {
        _enableBack = enableBack;
        _backColorInfo = backInfo;

        _enableBorder = enableBorder;
        _borderColorInfo = borderInfo;
        _borderSize = borderSize;
        _borderType = borderType;

        _tl = _tr = _bl = _br = 0;
    }

    public void Start() {
        _size = GetObject().GetTransform().GetSize();
    }

    public void Draw() {
        if (_size == null) return;

        if (_enableBorder) {
            stroke(_borderColorInfo.GetColor());
            strokeWeight(_borderSize);
            strokeCap(_borderType);
        } else {
            noStroke();
        }
        if (_enableBack) {
            fill(_backColorInfo.GetColor());
        } else {
            fill(0, 0);
        }
        rect(0, 0, _size.x, _size.y, _tl, _tr, _bl, _br);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDrawBack is destroyed");
        }
    }
}

public abstract class SceneObjectDrawBase extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DRAW_BASE;
    }

    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public SceneObjectDrawBase() {
        _colorInfo = new DrawColor();
    }
}

public class SceneObjectText extends SceneObjectDrawBase {
    public int GetID() {
        return ClassID.CID_TEXT;
    }

    private String _text;
    public String GetText() {
        return _text;
    }
    public void SetText(String value) {
        _text = value == null ? "" : value;
    }

    private int _horizontalAlign;
    public int GetHorizontalAlign() {
        return _horizontalAlign;
    }
    public void SetHorizontalAlign(int value) {
        if (value == LEFT || value == CENTER || value == RIGHT) {
            _horizontalAlign = value;
            switch(value) {
            case LEFT:
                _xRate = 0;
                break;
            case CENTER:
                _xRate = 0.5;
                break;
            case RIGHT:
                _xRate = 1;
                break;
            default:
                _xRate = 0;
                break;
            }
        }
    }

    private int _verticalAlign;
    public int GetVerticalAlign() {
        return _verticalAlign;
    }
    public void SetVerticalAlign(int value) {
        if (value == TOP || value == CENTER || value == BOTTOM || value == BASELINE) {
            _verticalAlign = value;
            switch(value) {
            case TOP:
                _yRate = 0;
                break;
            case CENTER:
                _yRate = 0.5;
                break;
            case BOTTOM:
                _yRate = 1;
                break;
            default:
                _yRate = 0.8;
                break;
            }
        }
    }

    public void SetAlign(int value1, int value2) {
        SetHorizontalAlign(value1);
        SetVerticalAlign(value2);
    }

    /**
     フォントはマネージャから取得するので、参照を分散させないように文字列で対応する。
     */
    private String _usingFontName;
    public String GetUsingFontName() {
        return _usingFontName;
    }
    public void SetUsingFontName(String value) {
        _usingFontName = value;
    }

    private float _fontSize;
    public float GetFontSize() {
        return _fontSize;
    }
    public void SetFontSize(float value) {
        if (0 <= value && value <= 100) {
            _fontSize = value;
        }
    }

    private float _lineSpace;
    public float GetLineSpace() {
        return _lineSpace;
    }
    /**
     行間をピクセル単位で指定する。
     ただし、最初からフォントサイズと同じ大きさの行間が設定されている。
     */
    public void SetLineSpace(float value) {
        float space = _fontSize + value;
        if (0 <= space) {
            _lineSpace = space;
        }
    }

    /**
     文字列の描画モード。
     falseの場合、通常と同じように一斉に描画する。
     trueの場合、ゲームのセリフのように一文字ずつ描画する。
     ただし、trueの場合は、alignで設定されているのがLEFT TOP以外だと違和感のある描画になる。
     */
    private boolean _isDrawInOrder;
    public boolean IsDrawInOrder() {
        return _isDrawInOrder;
    }
    public void SetDrawInOrder(boolean value) {
        _isDrawInOrder = value;
    }

    private float _drawSpeed;
    public float GetDrawSpeed() {
        return _drawSpeed;
    }
    public void SetDrawSpeed(float value) {
        if (value <= 0 || value >= 60) {
            return;
        }
        _drawSpeed = value;
    }

    private float _deltaTime;
    private int _drawingIndex;
    private String _tempText;

    private PVector _objSize;
    private float _xRate, _yRate;


    public SceneObjectText() {
        super();
        _InitParameterOnConstructor("");
    }

    public SceneObjectText(String text) {
        super();
        _InitParameterOnConstructor(text);
    }

    public SceneObjectText(SceneObject o, String text) {
        super();   
        _InitParameterOnConstructor(text);
        if (o == null) return;
        o.AddBehavior(this);
    }

    private void _InitParameterOnConstructor(String text) {
        SetText(text);
        SetAlign(LEFT, TOP);
        SetFontSize(20);
        SetLineSpace(0);
        SetUsingFontName("MS Gothic");
    }

    public void Start() {
        super.Start();
        _objSize = GetObject().GetTransform().GetSize();
    }

    public void Update() {
        _deltaTime += 1/frameRate;
        if (_deltaTime >= 1/_drawSpeed) {
            _deltaTime = 0;
            if (_drawingIndex < GetText().length()) {
                _drawingIndex++;
            }
        }
    }

    public void Draw() {
        if (GetText() == null) return;
        fill(GetColorInfo().GetColor());
        textFont(fontManager.GetFont(GetUsingFontName()));
        textSize(GetFontSize());
        textAlign(GetHorizontalAlign(), GetVerticalAlign());
        textLeading(GetLineSpace());

        if (_isDrawInOrder) {
            _tempText = GetText().substring(0, _drawingIndex);
        } else {
            _tempText = GetText();
        }
        text(_tempText, _objSize.x * _xRate, _objSize.y * _yRate);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectText is destroyed");
        }
    }
}

public class SceneObjectImage extends SceneObjectDrawBase {
    public int GetID() {
        return ClassID.CID_IMAGE;
    }

    private String _usingImageName;
    public String GetUsingImageName() {
        return _usingImageName;
    }
    public void SetUsingImageName(String value) {
        if (value != null) {
            _usingImageName = value;
        }
    }

    //private boolean _isNormalized;
    //public boolean IsNormalized() {
    //    return _isNormalized;
    //}
    //public void SetNormalized(boolean value) {
    //    _isNormalized = value;
    //}

    //private PVector _offsetPos, _offsetSize;
    //public PVector GetOffsetPos() {
    //    return _offsetPos;
    //}
    //public void SetOffsetPos(float x, float y) {
    //    if (_offsetPos == null) return;
    //    _offsetPos.set(x, y);
    //}
    //public PVector GetOffsetSize() {
    //    return _offsetSize;
    //}
    //public void SetOffsetSize(float w, float h) {
    //    if (_offsetSize == null) return;
    //    _offsetSize.set(w, h);
    //}

    private PVector _objSize;

    public SceneObjectImage() {
        super();
    }

    public SceneObjectImage(String imagePath) {
        super();
        _InitParameterOnConstrucor(imagePath);
    }

    public SceneObjectImage(SceneObject o, String imagePath) {
        super();
        _InitParameterOnConstrucor(imagePath);
        if (o == null) return;
        o.AddBehavior(this);
    }

    private void _InitParameterOnConstrucor(String imagePath) {
        SetUsingImageName(imagePath);
        //_offsetPos = new PVector(0, 0);
        //_offsetSize = new PVector(width, height);
        //_isNormalized = false;
    }

    public void Update() {
        super.Update();
        if (_objSize != null) return;
        _SetObjectSize();
    }

    public void Draw() {
        super.Draw();

        PImage img = imageManager.GetImage(GetUsingImageName());
        if (img == null || _objSize == null) return;

        tint(GetColorInfo().GetColor());

        //int x, y, w, h;
        //x = int(GetOffsetPos().x * (IsNormalized()?img.width : 1));
        //y = int(GetOffsetPos().y * (IsNormalized()?img.height : 1));
        //w = int(GetOffsetSize().x * (IsNormalized()?img.width : 1));
        //h = int(GetOffsetSize().y * (IsNormalized()?img.height : 1));
        //image(img.get(x, y, w, h), 0, 0, _objSize.x, _objSize.y);
        image(img, 0, 0, _objSize.x, _objSize.y);
    }

    private void _SetObjectSize() {
        _objSize = GetObject().GetTransform().GetSize();
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectImage is destroyed");
        }
    }
}

public class SceneObjectButton extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_BUTTON;
    }

    private boolean _isOverlappedMouse;
    public boolean IsOverlappedMouse() {
        return _isOverlappedMouse;
    }

    private String _eventLabel;
    protected String GetEventLabel() {
        return _eventLabel;
    }

    private SceneObjectImage _img;

    private ActionEvent _decideHandler;
    public ActionEvent GetDecideHandler() {
        return _decideHandler;
    }

    private ActionEvent _enabledActiveHandler;
    public ActionEvent GetEnabledActiveHandler() {
        return _enabledActiveHandler;
    }

    private ActionEvent _disabledActiveHandler;
    public ActionEvent GetDisabledActiveHandler() {
        return _disabledActiveHandler;
    }

    public SceneObjectButton(String eventLabel) {
        super();
        _InitParameterOnConstructor(eventLabel);
    }

    public SceneObjectButton(SceneObject obj, String eventLabel) {
        super();
        _InitParameterOnConstructor(eventLabel);

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    private void _InitParameterOnConstructor(String eventLabel) {
        _eventLabel = eventLabel;
        _decideHandler = new ActionEvent();
        _enabledActiveHandler = new ActionEvent();
        _disabledActiveHandler = new ActionEvent();
    }

    public void OnEnabledActive() {
        super.OnEnabledActive();
        _isOverlappedMouse = true;
        DrawColor d;
        if (_img != null) {
            d = _img.GetColorInfo();
            d.SetColor(d.GetRedOrHue()*0.8, d.GetGreenOrSaturation()*0.8, d.GetBlueOrBrightness()*0.8);
        }
        d = GetObject().GetDrawBack().GetBackColorInfo();
        d.SetColor(d.GetRedOrHue()*0.8, d.GetGreenOrSaturation()*0.8, d.GetBlueOrBrightness()*0.8);
        GetEnabledActiveHandler().InvokeAllEvents();
    }

    public void OnDisabledActive() {
        super.OnDisabledActive();
        _isOverlappedMouse = false;
        DrawColor d;
        if (_img != null) {
            d = _img.GetColorInfo();
            d.SetColor(d.GetRedOrHue()*1.25, d.GetGreenOrSaturation()*1.25, d.GetBlueOrBrightness()*1.25);
        }
        d = GetObject().GetDrawBack().GetBackColorInfo();
        d.SetColor(d.GetRedOrHue()*1.25, d.GetGreenOrSaturation()*1.25, d.GetBlueOrBrightness()*1.25);
        GetDisabledActiveHandler().InvokeAllEvents();
    }

    public void Start() {
        super.Start();
        _img = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
        inputManager.GetMouseReleasedHandler().GetEvents().Set(_eventLabel, new IEvent() {
            public void Event() {
                if (!_isOverlappedMouse) return;
                GetDecideHandler().InvokeAllEvents();
            }
        }
        );
    }

    public void Update() {
        super.Update();
        if (_img != null) return;
        _img = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectButton is destroyed");
        }
    }
}
public final class TimerInfo {
    public float settedTime;
    public float currentTime;
    public boolean useTimer;
    public boolean haveBegun;
    public boolean isActive;
}

public class SceneObjectTimer extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TIMER;
    }

    private PHash<ITimer> _timers;
    public PHash<ITimer> GetTimers() {
        return _timers;
    }
    private PHash<TimerInfo> _infos;

    public SceneObjectTimer() {
        super();
        _InitParameterOnConstructor(null);
    }

    public SceneObjectTimer(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }

    private void _InitParameterOnConstructor(SceneObject obj) {
        _timers = new PHash<ITimer>();
        _infos = new PHash<TimerInfo>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_timers == null) return;
        TimerInfo i;
        for (String label : _timers.GetElements().keySet()) {
            if (!_IsContainsKey(label)) continue;
            i = _infos.Get(label);
            if (!i.isActive || !i.haveBegun) continue;
            i.settedTime -= 1/frameRate;
            if (i.settedTime <= 0) {
                End(label);
            }
        }
    }

    public void Stop() {
        super.Stop();
        for (String label : _infos.GetElements().keySet()) {
            End(label);
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectTimer is destroyed");
        }
    }

    //////////////////////////////////////////
    // 以下、操作系メソッド
    //////////////////////////////////////////

    private boolean _IsContainsKey(String label) {
        return _timers.ContainsKey(label) && _infos.ContainsKey(label);
    }

    private TimerInfo _GetTimerInfo(String label) {
        TimerInfo i = _infos.Get(label);
        if (i == null) {
            i = new TimerInfo();
            _infos.Add(label, i);
        }
        return i;
    }

    public void ResetTimer(String label, float timer) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.settedTime = timer;
    }

    public void Start(String label) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = true;
        if (!i.haveBegun) {
            i.haveBegun = true;
            _timers.Get(label).OnInit();
        }
    }

    public void Stop(String label) {
        if (!_timers.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = false;
    }

    public void End(String label) {
        if (!_infos.ContainsKey(label)) return;
        TimerInfo i = _infos.Get(label);
        i.isActive = false;
        i.haveBegun = false;
        _timers.Get(label).OnTimeOut();
    }
}

public class SceneObjectDuration extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DURATION;
    }

    private PHash<IDuration> _durations;
    public PHash<IDuration> GetDurations() {
        return _durations;
    }
    private PHash<TimerInfo> _infos;

    public SceneObjectDuration() {
        super();
        _InitParameterOnConstructor(null);
    }

    public SceneObjectDuration(SceneObject obj) {
        super();
        _InitParameterOnConstructor(obj);
    }

    private void _InitParameterOnConstructor(SceneObject obj) {
        _durations = new PHash<IDuration>();
        _infos = new PHash<TimerInfo>();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Update() {
        super.Update();

        if (_durations == null) return;
        TimerInfo i;
        IDuration d;
        boolean f;
        for (String label : _durations.GetElements().keySet()) {
            if (!_IsContainsKey(label)) continue;
            i = _infos.Get(label);
            d = _durations.Get(label);
            if (!i.isActive || !i.haveBegun) continue;

            if (i.useTimer) {
                i.currentTime -= 1/frameRate;
                f = i.currentTime <= 0;
            } else {
                f = !d.IsContinue();
            }
            if (f) {
                End(label);
                return;
            }
            d.OnUpdate();
        }
    }

    public void Stop() {
        super.Stop();
        for (String label : _infos.GetElements().keySet()) {
            End(label);
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectDuration is destroyed");
        }
    }

    //////////////////////////////////////////
    // 以下、操作系メソッド
    //////////////////////////////////////////

    private boolean _IsContainsKey(String label) {
        return _durations.ContainsKey(label) && _infos.ContainsKey(label);
    }

    private TimerInfo _GetTimerInfo(String label) {
        TimerInfo i = _infos.Get(label);
        if (i == null) {
            i = new TimerInfo();
            _infos.Add(label, i);
        }
        return i;
    }

    public void ResetTimer(String label, float timer) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.settedTime = timer;
        i.currentTime = timer;
        Stop(label);
    }

    public float GetSettedTimer(String label) {
        if (!_durations.ContainsKey(label)) return 0;
        TimerInfo i = _GetTimerInfo(label);
        return i.settedTime;
    }

    public void SetUseTimer(String label, boolean useTimer) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.useTimer = useTimer;
    }

    public void Start(String label) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = true;
        if (!i.haveBegun) {
            i.haveBegun = true;
            _durations.Get(label).OnInit();
        }
    }

    public void Stop(String label) {
        if (!_durations.ContainsKey(label)) return;
        TimerInfo i = _GetTimerInfo(label);
        i.isActive = false;
    }

    public void End(String label) {
        if (!_infos.ContainsKey(label)) return;
        TimerInfo i = _infos.Get(label);
        i.isActive = false;
        i.haveBegun = false;
        _durations.Get(label).OnEnd();
    }
}
public class SceneObjectToggleButton extends SceneObjectButton {
    public int GetID() {
        return ClassID.CID_TOGGLE_BUTTON;
    }

    private boolean _isOn;
    private String _offImg, _onImg;

    private SceneObjectImage _img;

    public SceneObjectToggleButton(String eventLabel, String offImg, String onImg) {
        super(eventLabel);
        _InitParametersOnConstructor(offImg, onImg);
    }

    public SceneObjectToggleButton(SceneObject o, String eventLabel, String offImg, String onImg) {
        super(eventLabel);
        _InitParametersOnConstructor(offImg, onImg);
        if (o == null) return;
        o.AddBehavior(this);
    }

    private void _InitParametersOnConstructor(String offImg, String onImg) {
        _isOn = true;
        _offImg = offImg;
        _onImg = onImg;
    }

    public void Start() {
        super.Start();

        SceneObjectBehavior beh = GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
        if (beh instanceof SceneObjectImage) {
            _img = (SceneObjectImage) beh;
        }

        GetDecideHandler().GetEvents().Add("Toggle", new IEvent() {
            public void Event() {
                _isOn = !_isOn;

                if (_img == null) return;
                if (_isOn) {
                    _img.SetUsingImageName(_onImg);
                } else {
                    _img.SetUsingImageName(_offImg);
                }
            }
        }
        );
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("SceneObjectToggleButton is destroyed");
        }
    }
}
/**
 背景に配置する一枚絵だけを表示するシーン。
 */
public final class SceneOneIllust extends Scene {
    private SceneObjectImage _backImage;
    public SceneObjectImage GetBackImage() {
        return _backImage;
    }

    public SceneOneIllust() {
        super(SceneID.SID_ILLUST);
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        SceneObject obj = new SceneObject("Background", this);
        _backImage = new SceneObjectImage(obj, null);
        
        SceneObjectTimer timer = new SceneObjectTimer(obj);
        timer.GetTimers().Add("hoge", new ITimer(){
            public void OnInit() {
                println(111);
                _backImage.SetUsingImageName(null);
            }
            
            public void OnTimeOut() {
                println("done");
                _backImage.SetUsingImageName("gameover/back.png");
            }
        });
    }

    public void OnEnabled() {
        super.OnEnabled();
        
        SceneObject o = GetObject("Background");
        SceneObjectTimer t = (SceneObjectTimer)o.GetBehaviorOnID(ClassID.CID_TIMER);
        t.ResetTimer("hoge", 1);
        t.Start("hoge");
    }

    public void OnDisabled() {
        super.OnDisabled();
    }
}
public final class SceneTitle extends Scene {
    private String titleBack, titleText, dustF, dustE, fire, buttonBack;
    private String[] titleButtons;

    public SceneTitle() {
        super(SceneID.SID_TITLE);
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(2);

        titleBack = "TitleBack";
        titleText = "TitleNext";
        dustF = "DustEffectF";
        dustE = "DustEffectE";
        fire = "FireEffect";
        buttonBack = "ButtonBack";
        titleButtons = new String[]{"TitleStart", "TitleLoad", "TitleOption"};

        SceneObject obj;
        SceneObjectTransform objT;

        // 背景
        obj = new SceneObject(titleBack, this);
        SceneObjectImage backImg = new SceneObjectImage(obj, "title/back.png");
        backImg.GetColorInfo().SetAlpha(50);
        obj.SetActivatable(false);

        // タイトル
        obj = new SceneObject(titleText, this);
        obj.GetTransform().SetPriority(10);
        obj.SetActivatable(false);
        new SceneObjectImage(obj, "title/title.png");

        // ボタンとか
        String[] paths = new String[]{"start", "load", "option"};

        for (int i=0; i<3; i++) {
            obj = new SceneObject(titleButtons[i], this);
            objT = obj.GetTransform();
            objT.SetPriority(20);
            objT.SetTranslation(0, -(2-i) * 50 - 20);
            objT.SetSize(180, 50);
            objT.SetAnchor(0.5, 1, 0.5, 1);
            objT.SetPivot(0.5, 1);
            new SceneObjectImage(obj, "title/"+ paths[i] +".png");
            TitleButton b = new TitleButton(obj, titleButtons[i]);
            b.GetDecideHandler().GetEvents().Add("Go GameOver", new IEvent() {
                public void Event() {
                    SceneGameOver g = (SceneGameOver)sceneManager.GetScene(SceneID.SID_GAMEOVER);
                    g.GoGameOver();
                }
            }
            );
        }

        // 塵エフェクト
        String[] dustPaths = new String[20];
        for (int i=0; i<20; i++) {
            dustPaths[i] = "title/dust/_" + i/10 + "_" + i%10 + ".png";
        }

        obj = new SceneObject(dustF, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(203, 118);
        objT.SetSize(100, 0);
        objT.SetRotate(-1.114);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 5, 15, radians(-92) - objT.GetRotate(), 70, dustPaths);

        obj = new SceneObject(dustE, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(277, 252);
        objT.SetSize(100, 0);
        objT.SetRotate(-1.114);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 5, 15, radians(-90) - objT.GetRotate(), 70, dustPaths);

        // 火の粉エフェクト
        String[] firePaths = new String[20];
        for (int i=0; i<20; i++) {
            firePaths[i] = "title/fire/_" + i/10 + "_" + i%10 + ".png";
        }

        obj = new SceneObject(fire, this);
        objT = obj.GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetTranslation(width/2, height);
        objT.SetSize(width, 0);
        obj.SetActivatable(false);
        new TitleDustEffect(obj, 0.1, 0.5, 0, -1, 10, 30, radians(45) - objT.GetRotate(), 30, firePaths);

        // ボタン背景
        obj = new SceneObject(buttonBack, this);
        new SceneObjectImage(obj, "title/menuback.png");
        new TitleButtonBack(obj);
    }

    public void OnEnabled() {
        super.OnEnabled();

        SceneObject obj;
        SceneObjectImage img;

        obj = GetObject(titleBack);
        img = (SceneObjectImage)obj.GetBehaviorOnID(ClassID.CID_IMAGE);
    }

    public void OnDisabled() {
        super.OnDisabled();
    }

    public void GoTitle() {
        sceneManager.ReleaseAllScenes();
        sceneManager.LoadScene(SceneID.SID_TITLE);
    }
}

public final class TitleButton extends SceneObjectButton {
    public int GetID() {
        return ClassID.CID_TITLE_BUTTON;
    }

    private SceneObjectImage _img;

    public TitleButton(SceneObject obj, String eventLabel) {
        super(obj, eventLabel);
        _SetEventOnConstructor();
    }

    private void _SetEventOnConstructor() {
        GetEnabledActiveHandler().GetEvents().Add("title button on enabled active", new IEvent() {
            public void Event() {
                _OnEnabledActive();
            }
        }
        );
        GetDisabledActiveHandler().GetEvents().Add("title button on disabled active", new IEvent() {
            public void Event() {
                _OnDisabledActive();
            }
        }
        );
    }

    public void Start() {
        super.Start();
        _img = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
        OnDisabledActive();
    }

    private void _OnEnabledActive() {
        if (_img == null) return;
        _img.GetColorInfo().SetAlpha(255);
    }

    private void _OnDisabledActive() {
        if (_img == null) return;
        _img.GetColorInfo().SetAlpha(100);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleButton is destroyed");
        }
    }
}

public final class TitleDustEffect extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TITLE_DUST_EFFECT;
    }

    // 次のエフェクトを生成するまでの最低スパンと最高スパン 単位は秒
    private float _minSpan, _maxSpan;
    private float _vX, _vY, _alphaD, _relatedRad, _minSize, _maxSize;
    private String[] _paths;

    private float _cntDwn;

    private SceneObjectTransform _objT;

    public TitleDustEffect(SceneObject obj, float minSpan, float maxSpan, float vX, float vY, float minSize, float maxSize, float relatedRad, float alphaD, String[] paths) {
        super();
        _minSpan = minSpan;
        _maxSpan = maxSpan;
        _minSize = minSize;
        _maxSize = maxSize;
        _paths = paths;
        _vX = vX;
        _vY = vY;
        _relatedRad = relatedRad;
        _alphaD = alphaD;

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
    }

    public void Update() {
        super.Update();

        _cntDwn -= 1/frameRate;
        if (_cntDwn <= 0) {
            _cntDwn = random(_minSpan, _maxSpan);

            // 生成処理
            _GenerateDustEffect();
        }
    }

    private void _GenerateDustEffect() {
        SceneObject obj;
        SceneObjectTransform t;
        float x, y, d;
        x = _objT.GetSize().x/2;
        y = _objT.GetSize().y/2;
        d = random(_minSize, _maxSize);

        obj = new SceneObject("Title Dust Effect " + random(1000));
        obj.SetActivatable(false);
        t = obj.GetTransform();

        GetObject().GetScene().AddObject(obj);
        t.SetParent(GetObject().GetTransform(), true);

        t.SetAnchor(0.5, 0.5, 0.5, 0.5);
        t.SetTranslation(random(-x, x), random(-y, y));
        t.SetSize(d, d);

        new TitleDustImage(obj, _paths[(int)random(_paths.length)], _vX, _vY, _relatedRad, random(0.01, 0.05), _alphaD);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleDustEffect is destroyed");
        }
    }
}

public final class TitleDustImage extends SceneObjectImage {
    public int GetID() {
        return ClassID.CID_TITLE_DUST_IMAGE;
    }

    private PVector _velocity;

    // 親オブジェクトの角度に対して相対的に飛んでいく角度
    private float _relatedRad;

    // 自身の角速度
    private float _radVelocity;

    // 1秒あたりの透明度増加量
    private float _alphaDuration;

    private SceneObjectTransform _objT;

    public TitleDustImage(SceneObject obj, String imagePath, float vX, float vY, float relatedRad, float rad, float alphaD) {
        super(obj, imagePath);
        _velocity = new PVector(vX, vY);
        _relatedRad = relatedRad;
        _radVelocity = rad;
        _alphaDuration = alphaD;
    }

    public void Start() {
        super.Start();
        _objT = GetObject().GetTransform();
    }

    public void Update() {
        super.Update();
        if (_objT == null) return;
        PVector t = _objT.GetTranslation();
        _objT.SetTranslation(t.x + _GetX(), t.y + _GetY());
        _objT.SetRotate(_objT.GetRotate() + _radVelocity);

        float a = GetColorInfo().GetAlpha() - _alphaDuration / frameRate;
        if (a > 0) {
            GetColorInfo().SetAlpha(a);
        } else {
            GetObject().Destroy();
        }
    }

    private float _GetX() {
        return _velocity.x * cos(_relatedRad) - _velocity.y * sin(_relatedRad);
    }

    private float _GetY() {
        return _velocity.x * sin(_relatedRad) + _velocity.y * cos(_relatedRad);
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleDustImage is destroyed");
        }
    }
}

public final class TitleButtonBack extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_TITLE_BUTTON_BACK;
    }

    private SceneObject _actObj;
    private SceneObjectTransform _objT;
    private SceneObjectImage _objImg;
    private float _rad;

    public TitleButtonBack(SceneObject obj) {
        super();
        if (obj == null) return;
        obj.AddBehavior(this);
    }

    public void Start() {
        super.Start();

        GetObject().SetActivatable(false);
        _objT = GetObject().GetTransform();
        _objT.SetAnchor(0.5, 1, 0.5, 1);
        _objT.SetSize(240, 20);
        _objT.SetPriority(15);

        _objImg = (SceneObjectImage)GetObject().GetBehaviorOnID(ClassID.CID_IMAGE);
    }

    public void Update() {
        super.Update();

        _actObj = GetObject().GetScene().GetActiveObject();
        if (_actObj != null) {
            _objT.SetScale(1, 1);
            PVector actPos = _actObj.GetTransform().GetTranslation();
            _objT.SetTranslation(actPos.x, actPos.y-10);
        } else {
            _objT.SetScale(0, 0);
        }

        if (_objImg != null) {
            _objImg.GetColorInfo().SetAlpha(abs(cos(_rad)) * 255);
            _rad += 2/frameRate;
            _rad %= TWO_PI;
        }
    }

    protected void _OnDestroy() {
        if (isProcessing) {
            println("TitleButtonBack is destroyed");
        }
    }
}
/** //<>// //<>// //<>// //<>// //<>// //<>//
 アフィン変換一回分の情報に責任を持つ。
 サイズは持たない。
 */
public class Transform implements Copyable<Transform> {
    private PVector _translation;
    public PVector GetTranslation() {
        return _translation;
    }
    public void SetTranslation(PVector value) {
        if (value == null) return;
        SetTranslation(value.x, value.y);
    }
    public void SetTranslation(float x, float y) {
        _translation.set(x, y);
    }

    private PVector _scale;
    public PVector GetScale() {
        return _scale;
    }
    public void SetScale(PVector value) {
        if (value == null) return;
        SetScale(value.x, value.y);
    }
    public void SetScale(float x, float y) {
        _scale.set(x, y);
    }

    private float _rotate;
    public float GetRotate() {
        return _rotate;
    }
    public void SetRotate(float value) {
        _rotate = value;
    }

    public Transform() {
        _InitParametersOnConstructor(null, null, 0);
    }

    public Transform(PVector position, PVector scale, float rotate) {
        _InitParametersOnConstructor(position, scale, rotate);
    }

    public Transform(float posX, float posY, float scaleX, float scaleY, float rotate) {
        _InitParametersOnConstructor(new PVector(posX, posY), new PVector(scaleX, scaleY), rotate);
    }

    private void _InitParametersOnConstructor(PVector position, PVector scale, float rotate) {
        if (position == null) {
            position = new PVector();
        }
        if (scale == null) {
            scale = new PVector(1, 1);
        }

        _translation = position;
        _scale = scale;
        _rotate = rotate;
    }

    public void Init() {
        SetTranslation(0, 0);
        SetRotate(0);
        SetScale(1, 1);
    }

    public void CopyTo(Transform t) {
        if (t == null) return;
        t.SetTranslation(GetTranslation());
        t.SetScale(GetScale());
        t.SetRotate(GetRotate());
    }

    public String toString() {
        return "translate : " + GetTranslation() + "\nrotate : " + GetRotate() + "\nscale : " + GetScale();
    }
}
/**
 トランスフォームの処理リストを順番に実行していくクラス。
 */
public class TransformProcessor implements Copyable<TransformProcessor> {
    private Transform[] _transforms;
    private int _selfDepth;

    public TransformProcessor() {
        _transforms = new Transform[TransformManager.MAX_DEPTH + 1];
        _selfDepth = 0;
        _transforms[0] = new Transform();
    }

    public void Init() {
        _selfDepth = 0;
    }

    public void AddTranslate(float x, float y) {
        PVector t = _transforms[_selfDepth].GetTranslation();
        _transforms[_selfDepth].SetTranslation(t.x + x, t.y + y);
    }

    public void AddRotate(float rad) {
        float r = _transforms[_selfDepth].GetRotate();
        _transforms[_selfDepth].SetRotate(r + rad);
    }

    public void AddScale(float x, float y) {
        PVector s = _transforms[_selfDepth].GetScale();
        _transforms[_selfDepth].SetScale(s.x * x, s.y * y);
    }

    public boolean NewDepth() {
        if (_selfDepth >= TransformManager.MAX_DEPTH + 1) {
            return false;
        }
        _selfDepth++;
        if (_transforms[_selfDepth] == null) {
            _transforms[_selfDepth] = new Transform();
        } else {
            _transforms[_selfDepth].Init();
        }
        return true;
    }

    public void TransformProcessing() {
        resetMatrix();
        Transform t;
        for (int i=0; i<=_selfDepth; i++) {
            t = _transforms[i];
            rotate(t.GetRotate());
            scale(t.GetScale().x, t.GetScale().y);
            translate(t.GetTranslation().x, t.GetTranslation().y);
        }
    }

    public void CopyTo(TransformProcessor tp) {
        if (tp == null) return;

        tp._selfDepth = _selfDepth;
        for (int i=0; i<=_selfDepth; i++) {
            if (tp._transforms[i] == null) {
                tp._transforms[i] = new Transform();
            }
            _transforms[i].CopyTo(tp._transforms[i]);
        }
    }
}
