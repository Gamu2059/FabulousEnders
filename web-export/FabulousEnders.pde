/**
 接頭辞について。
 FE ... FabulousEnders上で使用するクラスファイル群。
 P  ... システム上で使用するクラスファイル群。
 */

import java.util.*;
import java.lang.reflect.*;
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

void setup() {
    size(880, 480);
    try {
        InitManager();
        SetScenes();
        sceneManager.LoadScene(SceneID.SID_FE_BATTLE_MAP);

        sceneManager.Start();
        //FESceneBattleMap map = (FESceneBattleMap)sceneManager.GetScene(SceneID.SID_FE_BATTLE_MAP);
        //map.LoadMap("data/map/test.json");
        
        saveStrings("data/test.json", new String[]{"hoge"});
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
    public static final int SYSTEM_MAP_GRID_PX = 40;
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
    public static final int SKILL_REF_HP = -2000;
    public static final int SKILL_REF_ATK = -2001;
    public static final int SKILL_REF_MAT = -2002;
    public static final int SKILL_REF_TEC = -2003;
    public static final int SKILL_REF_SPD = -2004;
    public static final int SKILL_REF_LUC = -2005;
    public static final int SKILL_REF_DEF = -2006;
    public static final int SKILL_REF_MDF = -2007;
    public static final int SKILL_REF_MOV = -2008;
    public static final int SKILL_REF_PRO = -2009;
    public static final int SKILL_REF_PROBABILITY = -2010;
    
    // スキルの特徴
    // 先制攻撃
    public static final int SKILL_FET_PREEMPTIVE = -2100;
    // 連続攻撃
    public static final int SKILL_FET_CONTINUOUS = -2101;
    // 再攻撃
    public static final int SKILL_FET_REATTACK = -2102;
    // ダメージ吸収(攻撃側スキル)
    public static final int SKILL_FET_ABSORPTION = -2103;
    // 物理ダメージ半減
    public static final int SKILL_FET_HALVING_PHYSICS = -2104;
    // 魔法ダメージ半減
    public static final int SKILL_FET_HALVING_MAGIC = -2105;
    // 物理ダメージ無効化
    public static final int SKILL_FET_INVALIDATE_PHYSICS = -2106;
    // 魔法ダメージ無効化
    public static final int SKILL_FET_INVALIDATE_MAGIC = -2107;
    // 反撃
    public static final int SKILL_FET_COUNTER_ATTACK = -2108;
    // 必中
    public static final int SKILL_FET_HITTING = -2109;
    // 反撃会心必中
    public static final int SKILL_FET_COUNTER_CRITICAL = -2110;
    // 経験値倍増
    public static final int SKILL_FET_DOUBLE_EXP = -2111;
    // 行動回復(相手に対して)
    public static final int SKILL_FET_RECOVER_MOBILITY = -2112;
    // 再行動
    public static final int SKILL_FET_REACT = -2113;
    // 再移動
    public static final int SKILL_FET_REMOVE = -2114;
    // 指揮C
    public static final int SKILL_FET_COMMAND_C = -2115;
    // 指揮B
    public static final int SKILL_FET_COMMAND_B = -2116;
    // 指揮A
    public static final int SKILL_FET_COMMAND_A = -2117;
    // 指揮S
    public static final int SKILL_FET_COMMAND_S = -2118;
    // 防御半減攻撃
    public static final int SKILL_FET_DEFENSE_HALF = -2119;
    // 防御無視攻撃
    public static final int SKILL_FET_DEFENSE_INVALIDATE = -2120;
    
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
    // 種類
    public static final int ITEM_KIND_CANT_USE = -4000;
    public static final int ITEM_KIND_RECOVER_HP = -4001;
    public static final int ITEM_KIND_DOPING = -4002;
    public static final int ITEM_KIND_CLASS_CHANGE = -4002;
    public static final int ITEM_KIND_LEARN_SKILL = -4003;
    public static final int ITEM_KIND_UNLOCK = -4004;
    public static final int ITEM_KIND_GAIN_STATE = -4005;
    
    // 使用範囲
    public static final int ITEM_RANGE_OWN = -4100;
    public static final int ITEM_RANGE_REGION = -4101;
    public static final int ITEM_RANGE_ALL = -4102;
    
    // 使用フィルタ
    public static final int ITEM_FILTER_OWN = -4200;
    public static final int ITEM_FILTER_OTHER = -4201;
    
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
}
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

        // テスト環境のみ
        StartGame();
    }

    /**
     ゲームを最初からプレイする。
     */
    public void StartGame() {
        try {
            _progressDataBase.Load("data/database/star.json");
        } 
        catch(Exception e) {
            println(111);
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

    public void Load(String dataPath) throws Exception {
        JsonObject json = new JsonObject();
        json.Load(dataPath);
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
        _elem.put(name, elem.toString());
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
                if (elem == null) {
                    continue;
                }
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
    
    public static final int CID_FE_MAP_OBJECT_IMAGE = 10000;
    public static final int CID_FE_MAP_OBJECT_DATA = 10001;
}

public final class SceneID {
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
    private JsonObject _mapData;

    private SceneObject _backObj;
    private SceneObjectImage _backImg;

    /**
     プレイヤーユニットオブジェクト
     */
    private ArrayList<SceneObject> _playerUnits;

    /**
     敵ユニットオブジェクト
     */
    private ArrayList<SceneObject> _enemyUnits;

    /**
     イベントオブジェクト
     */
    private ArrayList<FEMapObjectBase> _events;

    public FESceneBattleMap() {
        super(SceneID.SID_FE_BATTLE_MAP);

        _mapData = new JsonObject();

        _events = new ArrayList<FEMapObjectBase>();

        _backObj = new SceneObject("Back Image", this);
        _backImg = new SceneObjectImage(_backObj, null);
        SceneObjectTransform _objT = _backObj.GetTransform();
        _objT.SetAnchor(0, 0, 0, 0);
        _objT.SetPivot(0, 0);
    }

    /**
     マップデータを読み込み、現在のマップをリセットする。
     戦闘開始ではない。
     */
    public void LoadMap(String dataPath) {
        _mapData.Load(dataPath);

        // 背景設定
        _backImg.SetUsingImageName(_mapData.GetString("Back Image", null));

        // サイズ設定
        JsonObject pos = _mapData.GetJsonObject("Map Size");
        int x, y;
        x = pos.GetInt("x", -1);
        y = pos.GetInt("y", -1);
        SceneObjectTransform _objT = _backObj.GetTransform();
        _objT.SetSize(x * FEConst.SYSTEM_MAP_GRID_PX, y * FEConst.SYSTEM_MAP_GRID_PX);
        //_backScr.ReSetScroller();

        // イベントオブジェクト設定
        _events.clear();
        JsonArray eventArray = _mapData.GetJsonArray("Event Datas");
        if (eventArray == null) return;
        JsonObject event;
        for (int i=0; i<eventArray.Size(); i++) {
            event = eventArray.GetJsonObject(i);
            FEMapObjectBase obj = new FEMapObjectBase(event.GetString("Name", "No Name"), this, event);
            obj.GetTransform().SetParent(_backObj.GetTransform(), true);
        }
    }

    //private void _ResetSettedFlag(boolean[][] flags) {
    //    for (int i=0; i<flags.length; i++) {
    //        for (int j=0; j<flags[0].length; j++) {
    //            flags[i][j] = false;
    //        }
    //    }
    //}
}

/**
 マップ上に存在するオブジェクトのベースクラス。
 */
public class FEMapObjectBase extends SceneObject {
    private FEMapObjectData _data;
    public FEMapObjectData GetData() {
        return _data;
    }

    public FEMapObjectBase(String name, FESceneBattleMap scene, JsonObject json) {
        super(name, scene);

        SceneObjectTransform objT = GetTransform();
        objT.SetAnchor(0, 0, 0, 0);
        objT.SetPivot(0, 0);
        objT.SetSize(FEConst.SYSTEM_MAP_GRID_PX, FEConst.SYSTEM_MAP_GRID_PX);
        objT.SetTranslation(json.GetInt("x", 0) * FEConst.SYSTEM_MAP_GRID_PX, json.GetInt("y", 0) * FEConst.SYSTEM_MAP_GRID_PX);

        _data = new FEMapObjectData(this);
        FEMapObjectImage img = new FEMapObjectImage(this);

        img.SetBaseFolderPath(json.GetString("Image Folder Path", null));
        img.SetAnimation(json.GetBoolean("Is Animation", false));
        img.SetFixedDirection(json.GetBoolean("Is Fixed Direction", true));
    }
}



/**
 マップオブジェクトの基本情報を保持するコンポーネント。
 */
public class FEMapObjectData extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_DATA;
    }

    /**
     マップ上の座標
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }

    /**
     他のオブジェクトがすり抜けられるかどうか
     */
    private boolean _isSlipable;
    public boolean IsSlipable() {
        return _isSlipable;
    }
    public void SetSlipable(boolean value) {
        _isSlipable = value;
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

    public FEMapObjectData(FEMapObjectBase obj) {
        super();

        if (obj == null) return;
        obj.AddBehavior(this);
    }

    protected void _OnDestroy() {
        ;
    }
}

/**
 マップオブジェクトのアニメーションを司るコンポーネント。
 */
public class FEMapObjectImage extends SceneObjectImage {
    public int GetID() {
        return ClassID.CID_FE_MAP_OBJECT_IMAGE;
    }

    /**
     イメージの保存されているフォルダのパス
     */
    private String _baseFolderPath;
    public String GetBaseFolderPath() {
        return _baseFolderPath;
    }
    public void SetBaseFolderPath(String value) {
        _baseFolderPath = value;
    }

    /**
     アニメーションさせるかどうか
     */
    private boolean _isAnimation;
    public boolean IsAnimation() {
        return _isAnimation;
    }
    public void SetAnimation(boolean value) {
        _isAnimation = value;
    }

    /**
     向きを固定するかどうか
     */
    private boolean _isFixedDirection;
    public boolean IsFixedDirection() {
        return _isFixedDirection;
    }
    public void SetFixedDirection(boolean value) {
        _isFixedDirection = value;
    }

    // タイマーコンポーネント
    SceneObjectTimer _timer;

    FEMapObjectBase _obj;

    private String _timerLabel;
    private int _index;

    public FEMapObjectImage(FEMapObjectBase obj) {
        super(obj, null);

        _obj = obj;

        _timer = new SceneObjectTimer(obj);
        _timerLabel = "FE Map Object Image Animation";
        _timer.GetTimers().Add(_timerLabel, new ITimer() {
            public void OnInit() {
                _index = (_index + 1) % 4;
                int id = _index % 2 == 0 ? _index : 1;
                if (_baseFolderPath == null) return;
                String dir;
                switch(_obj.GetData().GetDirection()) {
                case FEConst.MAP_OBJ_DIR_UP:
                    dir = "U";
                    break;
                case FEConst.MAP_OBJ_DIR_RIGHT:
                    dir = "R";
                    break;
                case FEConst.MAP_OBJ_DIR_DOWN:
                    dir = "D";
                    break;
                case FEConst.MAP_OBJ_DIR_LEFT:
                    dir = "L";
                    break;
                default:
                    dir = "N";
                    break;
                }
                SetUsingImageName(_baseFolderPath + "/" + dir + id + ".png");
            }

            public void OnTimeOut() {
                if (!_isAnimation) return;
                _timer.ResetTimer(_timerLabel, 0.5);
                _timer.Start(_timerLabel);
            }
        }
        );
    }

    public void Start() {
        super.Start();
        _timer.ResetTimer(_timerLabel, 0.5);
        _timer.Start(_timerLabel);
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
        for (int i=0;i<_children.size();i++) {
            trans = _children.get(i);
            if (!trans.IsAutoChangePriority()) continue;
            trans._priority = priority;
            trans._SetPriorityRecursive(priority + 1);
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
        rect(0, 0, _size.x, _size.y);
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

    public void OnDisabledActive() {
        super.OnDisabledActive();
        _isOverlappedMouse = false;
        if (_img != null) {
            DrawColor d = _img.GetColorInfo();
            _img.GetColorInfo().SetColor(d.GetRedOrHue()*1.25, d.GetGreenOrSaturation()*1.25, d.GetBlueOrBrightness()*1.25);
        }
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
