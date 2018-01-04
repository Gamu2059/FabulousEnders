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