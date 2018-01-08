public class FEConst {
    public static final String CONFIG_PATH = "data/config/";
    public static final String DATABASE_PATH = "data/database/";
    public static final String SAVE_PATH = "data/save/";
    public static final String MAP_PATH = "data/map/";
    
    public static final int SYSTEM_MAP_GRID_PX = 40;
    public static final int SYSTEM_MAP_OBJECT_PX = 60;
    public static final int SYSTEM_MAP_MAX_HEIGHT = 50;
    public static final int SYSTEM_MAP_MAX_WIDTH = 50;
    
    public static final int NOT_FOUND = -2954783;
    
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
    public static final float CONFIG_SPECIAL_HIT_RATE = 2.5f;
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
    public static final int BATTLE_SORTIE_MODE_NONE = -7000;
    public static final int BATTLE_SORTIE_MODE_IN_PREPARATION = -7001;
    public static final int BATTLE_SORTIE_MODE_SORTIE = -7002;
    
    // 先攻後攻(プレイヤーが)
    public static final int BATTLE_PHASE_FIRST = -7100;
    public static final int BATTLE_PHASE_AFTER = -7101;
    
    // 操作モード
    public static final int BATTLE_OPE_MODE_NORMAL = -7200;
    public static final int BATTLE_OPE_MODE_ACTIVE = -7201;
    public static final int BATTLE_OPE_MODE_MOVING = -7202;
    public static final int BATTLE_OPE_MODE_FINISH_MOVE = -7203;
    public static final int BATTLE_OPE_MODE_BACK_MENU = -7204;
    public static final int BATTLE_OPE_MODE_PRE_BATTLE = -7205;
    public static final int BATTLE_OPE_MODE_BATTLE_START = -7206;
    public static final int BATTLE_OPE_MODE_BATTLE = -7207;
    public static final int BATTLE_OPE_MODE_BATTLE_END = -7209;
    public static final int BATTLE_OPE_MODE_BATTLE_RESULT = -7209;
    public static final int BATTLE_OPE_MODE_BATTLE_DEAD = -7210;
    
    // マーカ
    public static final int BATTLE_MAP_MARKER_ACTION = -7300;
    public static final int BATTLE_MAP_MARKER_ATTACK = -7301;
    public static final int BATTLE_MAP_MARKER_CANE = -7302;
}