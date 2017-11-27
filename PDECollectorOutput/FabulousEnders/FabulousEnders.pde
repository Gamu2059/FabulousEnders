import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
MatrixManager matrixManager;
ImageManager imageManager;
FontManager fontManager;

Scene scene;
SceneObjectTransform objT1, objT2;
float x;
boolean isRotate;
void setup() {
    size(1066, 600);
    surface.setLocation(0, 0);
    try {
        InitManager();

        scene = new Scene("main");
        scene.GetTransform().SetPosition(width * 0.5, 0);
        scene.SetSceneScale(0.5, 1);
        scene.GetDrawBack().GetBackColorInfo().SetColor(100, 0, 100);

        SceneObject o = new SceneObject("camera?", scene);
        SetText(o);
        objT1 = o.GetTransform();
        objT1.SetSize(100, 100);
        objT1.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);
        objT1.SetSelfAnchor(SceneObjectAnchor.CENTER_MIDDLE);

        SceneObject o1 = new SceneObject("Overlapped", scene);
        o1.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        //SetImage(o1);
        SetButton(o1);
        objT2 = o1.GetTransform();
        objT2.SetParent(o.GetTransform(), true);
        objT2.SetSize(100, 140);
        objT2.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);

        sceneManager.Start("main");
    } 
    catch(Exception e) {
        println(e);
    }
}

void SetImage(SceneObject o) {
    SceneObjectImage i = new SceneObjectImage(o);
    i.SetUsingImageName("icon.png");
}

void SetText(SceneObject o) {
    SceneObjectText t = new SceneObjectText(o, "TestTestTestTestTestTestTestTest");
    t.SetDrawInOrder(true);
    t.SetDrawSpeed(10);
    t.GetColorInfo().SetColor(0, 0, 200);
}

void SetButton(SceneObject o) {
    SceneObjectButton b = new SceneObjectButton(o);
    b.GetDicideHandler().AddEvent("pushed", new Event() {
        public void Event() {
            OnDecide();
        }
    }
    );
}

void OnDecide() {
    isRotate = !isRotate;
}

void draw() {
    surface.setTitle("Game Maker fps : " + frameRate);
    try {
        sceneManager.Update();
        if (isRotate) {
            objT1.SetRotate(x += 1/frameRate);
            objT2.SetRotate(x += 1/frameRate);
        }
    } 
    catch(Exception e) {
        println(e);
    }
}

/**
 用意されたマネージャオブジェクトを自動的に生成する。
 */
void InitManager() {
    Field[] fields = getClass().getDeclaredFields();
    Field f;

    try {
        for (int i=0; i<fields.length; i++) {
            f = fields[i];
            if (GeneralJudge.IsImplemented(f.getType(), Abs_Manager.class)) {
                f.setAccessible(true);
                f.set(this, f.getType().getDeclaredConstructor(getClass()).newInstance(this));
            }
        }
    } 
    catch(NoSuchMethodException nse) {
        println(nse);
    } 
    catch(InstantiationException ie) {
        println(ie);
    } 
    catch(IllegalAccessException iae) {
        println(iae);
    } 
    catch(InvocationTargetException ite) {
        println(ite);
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
}public abstract class Abs_Manager {
    public Abs_Manager() {
        println("Created " + getClass().getSimpleName());
    }
}public abstract class Abs_SceneObjectBehavior {
    private String[] _classNames;
    protected String[] GetClassNames() {
        return _classNames;
    }

    private String _name;
    public String GetName() {
        return _name;
    }

    private SceneObject _object;
    public SceneObject GetObject() {
        return _object;
    }

    public Scene GetScene() {
        if (GetObject() == null) {
            return null;
        }
        return GetObject().GetScene();
    }

    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public void SetEnable(boolean value) {
        _enable = value;
        if (_enable) {
            OnEnabled();
        } else {
            OnDisabled();
        }
    }

    /**
     振る舞いとしてスタート関数が呼び出されたかどうか。
     既に呼び出された場合はtrueになる。
     */
    private boolean _isStart;
    public boolean IsStart() {
        return _isStart;
    }

    public Abs_SceneObjectBehavior(SceneObject object) {
        _name = getClass().getSimpleName();
        _object = object;
        SetEnable(true);

        // 自身も含めた継承しているクラスを全て列挙
        ArrayList<String> list = new ArrayList<String>();
        Class<?> c = getClass();
        while (c != null) {
            if (c.getSimpleName().equals(_OldestClassName())) {
                break;
            }
            list.add(c.getSimpleName());
            c = c.getSuperclass();
        }
        _classNames = new String[list.size()];
        list.toArray(_classNames);

        object.AddBehavior(this);
    }

    /**
     ClassNames配列を生成する際に、"自身の振る舞いを特定できない最も古い振る舞い"を返す。
     基本的な振る舞いは、全て "Abs_SceneObjectBehavior" を返す。
     
     返り値に指定したクラスを継承する振る舞いはオブジェクトに複数存在することが許可される。
     */
    protected String _OldestClassName() {
        return "Abs_SceneObjectBehavior";
    }

    /**
     同じ系統の振る舞いであった場合、trueを返す。
     */
    public final boolean IsSameBehavior(Abs_SceneObjectBehavior behavior) {
        String[] a, b;
        a = GetClassNames();
        b = behavior.GetClassNames();
        for (int i=0; i<a.length; i++) {
            for (int j=0; j<b.length; j++) {
                if (a[i].equals(b[j])) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     指定した名前と一致する振る舞いであるか、もしくはそれを継承している場合、trueを返す。
     */
    public final boolean IsBehaviorAs(String behavior) {
        String[] a = GetClassNames();
        for (int i=0; i<a.length; i++) {
            if (a[i].equals(behavior)) {
                return true;
            }
        }
        return false;
    }

    /**
     指定した振る舞いに該当する場合、trueを返す。
     */
    public final boolean IsBehaviorAs(Class<?> c) {
        return IsBehaviorAs(c.getSimpleName());
    }

    /**
     シーンがアクティブになってからの最初のフレームで呼び出される。
     これが呼び出される段階では、全てのオブジェクトが揃っているので、自身以外への参照の保持などを行える。
     */
    public void Start() {
        _isStart = true;
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     初回フレームでは、全ての振る舞いのStartが呼び出された後に呼び出される。
     アニメーションやキー判定などは、基本的にここで処理する。
     */
    public void Update() {
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     アニメーションコントローラ以外は基本的に何も処理しない。
     */
    public void Animation() {
    }

    /**
     シーンがアクティブの時、毎フレーム呼び出される。
     ドロービヘイビア以外は基本的に何も処理しない。
     */
    public void Draw() {
    }

    /**
     シーンがノンアクティブになったフレームで呼び出される。
     Destroyとは異なり、オブジェクトの破壊などを行うためのメソッドではないので注意。
     */
    public void Stop() {
    }

    /**
     オブジェクトが有効化されたフレームで呼び出される。
     振る舞い単体でも呼び出される可能性はある。
     */
    public void OnEnabled() {
        _isStart = false;
    }

    /**
     オブジェクトが無効化されたフレームで呼び出される。
     振る舞い単体でも呼び出される可能性はある。
     */
    public void OnDisabled() {
    }

    public void OnEnabledActive() {
    }

    public void OnDisabledActive() {
    }

    public void OnMousePressed() {
    }

    public void OnMouseReleased() {
    }

    public void OnMouseClicked() {
    }

    public void OnKeyPressed() {
    }

    public void OnKeyReleased() {
    }

    /**
     指定したオブジェクトが次のいずれかの場合、trueを返す。
     ・自身そのもの。
     ・文字列であり、かつ自身の振る舞いのいづれかに該当する。
     ・振る舞いであり、かつ自身と同系統の振る舞い。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (o == null) {
            return false;
        } else if (o instanceof String) {
            String s = (String) o;
            return IsBehaviorAs(s);
        } else if (o instanceof Abs_SceneObjectBehavior) {
            Abs_SceneObjectBehavior b = (Abs_SceneObjectBehavior) o;
            return IsSameBehavior(b);
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" :\n");
        b.append("  name : ").append(_name).append(" \n");
        return b.toString();
    }
}public abstract class Abs_SceneObjectDrawBase extends Abs_SceneObjectBehavior {
    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public Abs_SceneObjectDrawBase(SceneObject obj) {
        super(obj);

        _colorInfo = new DrawColor();
    }
}public final class ActionEvent {
    private HashMap<String, Event> _events;
    private HashMap<String, Event> GetEventHash() {
        return _events;
    }

    public ActionEvent() {
        _events = new HashMap<String, Event>();
    }

    public void AddEvent(String eventLabel, Event event) {
        if (!GetEventHash().containsKey(eventLabel) && event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }
    
    public void SetEvent(String eventLabel, Event event) {
        if (event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }
    
    public Event GetEvent(String eventLabel) {
        return GetEventHash().get(eventLabel);
    }
    
    public Event RemoveEvent(String eventLabel) {
        return GetEventHash().remove(eventLabel);
    }
    
    public void RemoveAllEvents() {
        GetEventHash().clear();
    }
    
    public void InvokeEvent(String eventLabel) {
        Event e = GetEvent(eventLabel);
        if (e != null) {
            e.Event();
        }
    }
    
    public void InvokeAllEvents() {
        for (String label : GetEventHash().keySet()) {
            InvokeEvent(label);
        }
    }
}public final class DrawColor {
    public static final int MAX_RED = 255;
    public static final int MAX_GREEN = 255;
    public static final int MAX_BLUE = 255;
    public static final int MAX_HUE = 360;
    public static final int MAX_SATURATION = 100;
    public static final int MAX_BRIGHTNESS = 100;
    public static final int MAX_ALPHA = 255;

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
        if (_isRGB && value > MAX_RED) {
            value %= MAX_RED;
        } else if (!_isRGB && value > MAX_HUE) {
            value %= MAX_HUE;
        }
        _p1 = value;
    }

    public float GetGreenOrSaturation() {
        return _p2;
    }
    public void SetGreenOrSaturation(float value) {
        if (_isRGB && value > MAX_GREEN) {
            value %= MAX_GREEN;
        } else if (!_isRGB && value > MAX_SATURATION) {
            value %= MAX_SATURATION;
        }
        _p2 = value;
    }

    public float GetBlueOrBrightness() {
        return _p3;
    }
    public void SetBlueOrBrightness(float value) {
        if (_isRGB && value > MAX_BLUE) {
            value %= MAX_BLUE;
        } else if (!_isRGB && value > MAX_BRIGHTNESS) {
            value %= MAX_BRIGHTNESS;
        }
        _p3 = value;
    }

    public float GetAlpha() {
        return _alpha;
    }
    public void SetAlpha(float value) {
        if (value > MAX_ALPHA) {
            value %= MAX_ALPHA;
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
        _InitParameterOnConstructor(true, MAX_RED, MAX_GREEN, MAX_BLUE, MAX_ALPHA);
    }

    public DrawColor(boolean isRGB) {
        if (_isRGB) {
            _InitParameterOnConstructor(_isRGB, MAX_RED, MAX_GREEN, MAX_BLUE, MAX_ALPHA);
        } else {
            _InitParameterOnConstructor(_isRGB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
        }
    }

    public DrawColor(boolean isRGB, float p1, float p2, float p3) {
        _InitParameterOnConstructor(isRGB, p1, p2, p3, MAX_ALPHA);
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
            colorMode(RGB, MAX_RED, MAX_GREEN, MAX_BLUE, MAX_ALPHA);
        } else {
            colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
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

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" :\n");
        b.append("  is RGB : ").append(IsRGB()).append(" \n");
        b.append("  parameter : ").append(GetRedOrHue()).append(", ").append(GetGreenOrSaturation()).append(", ").append(GetBlueOrBrightness()).append(", ").append(GetAlpha());

        return b.toString();
    }
}public interface Event {
    public void Event();
}public final class FontManager extends Abs_Manager {
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
}public final static class GeneralCalc {
    /**
     指定した座標同士のラジアン角を返す。
     座標2から座標1に向けての角度になるので注意。
     */
    public static float getRad(float x1, float y1, float x2, float y2) {
        float y, x;
        y = y1 - y2;
        x = x1 - x2;
        if (y == 0 && x == 0) {
            return 0;
        }
        float a = atan(y/x);
        if (x < 0) {
            // 左向きの時
            a = PI + a;
        }
        return a;
    }
}public final static class GeneralJudge {
    /**
    指定したクラスが指定したインターフェースを実装しているかどうか。
    */
    public static boolean IsImplemented(Class<?> clazz, Class<?> intrfc) {
        if (clazz == null || intrfc == null) {
            return false;
        }
        // インターフェースを実装したクラスであるかどうかをチェック
        if (!clazz.isInterface() && intrfc.isAssignableFrom(clazz)
                && !Modifier.isAbstract(clazz.getModifiers())) {
            return true;
        }
        return false;
    }
}public final class ImageManager extends Abs_Manager {
    public static final String IMAGEPATH = "image/";
    
    private HashMap<String, PImage> _images;
    private HashMap<String, PImage> GetImageHash() {
        return _images;
    }

    public ImageManager() {
        _images = new HashMap<String, PImage>();
    }

    public PImage GetImage(String path) {
        path = IMAGEPATH + path;
        if (GetImageHash().containsKey(path)) {
            return GetImageHash().get(path);
        }
        PImage image = requestImage(path);
        if (image != null) {
            GetImageHash().put(path, image);
        }
        return image;
    }
}public final class InputManager extends Abs_Manager {
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

        GetMouseEnteredHandler().AddEvent("Mouse Entered Window", new Event() { 
            public void Event() {
                println("Mouse Enterd on Window!");
            }
        }
        );

        GetMouseExitedHandler().AddEvent("Mouse Exited Window", new Event() {
            public void Event() {
                println("Mouse Exited from Window!");
            }
        }
        );
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
        SetMouseMode(true);
        GetMousePressedHandler().InvokeAllEvents();
    }

    public void MouseReleased() {
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
    public boolean IsPressedKeys(int... inputs) {
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

    /**
     引数で与えられた列挙定数に対して、その列挙されたものだけが押されている状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsPressedKeysOnly(int... inputs) {
        if (inputs == null) {
            return false;
        }
        sort(inputs);
        int inputIndex = 0;
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (!GetPressedKeys()[i]) {
                continue;
            } else if (inputIndex >= inputs.length) {
                return false;
            } else if (i != inputs[inputIndex]) {
                return false;
            }
            inputIndex++;
        }
        return inputIndex == inputs.length;
    }

    /* 
     引数で与えられた列挙定数に対して、全てのキーがクリックされた状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsClickedKeys(int... inputs) {
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

    /**
     引数で与えられた列挙定数に対して、その列挙されたものだけがクリックされた状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsClickedKeysOnly(int... inputs) {
        if (inputs == null) {
            return false;
        }
        sort(inputs);
        int inputIndex = 0;
        for (int i=0; i<Key.KEY_NUM; i++) {
            if (!GetClickedKeys()[i]) {
                continue;
            } else if (inputIndex >= inputs.length) {
                return false;
            } else if (i != inputs[inputIndex]) {
                return false;
            }
            inputIndex++;
        }
        return inputIndex == inputs.length;
    }
}public class Key {
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
}public final class MatrixManager extends Abs_Manager {
    public final static int MAX_STACK = 32;

    private int _stackNum;
    public int GetStackNum() {
        return _stackNum;
    }

    public MatrixManager() {
        _stackNum = 0;
    }

    public boolean PushMatrix() {
        if (_stackNum < MAX_STACK) {
            _stackNum++;
            pushMatrix();
            return true;
        }
        return false;
    }

    public boolean PopMatrix() {
        if (_stackNum > 0) {
            _stackNum--;
            popMatrix();
            return true;
        }
        return false;
    }
}public class Scene extends SceneObject {
    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    /**
     次のフレームからアクティブになる場合にtrueになる。
     */
    private boolean _enabledFlag;
    public final void SetEnabledFlag(boolean value) {
        _enabledFlag = value;
    }
    /**
     次のフレームからノンアクティブになる場合にtrueになる。
     */
    private boolean _disabledFlag;
    public final void SetDisabledFlag(boolean value) {
        _disabledFlag = value;
    }

    /**
     オブジェクトの優先度変更が発生している場合はtrueになる。
     これがtrueでなければソートはされない。
     */
    private boolean _isNeedSorting;
    public void SetNeedSorting(boolean value) {
        _isNeedSorting = value;
    }

    /**
     シーンにのみ特別にスケール値を与える。
     */
    private PVector _sceneScale;
    public PVector GetSceneScale() {
        return _sceneScale;
    }
    public void SetSceneScale(PVector value) {
        if (value != null) {
            _sceneScale = value;
        }
    }
    public void SetSceneScale(float value1, float value2) {
        _sceneScale.set(value1, value2);
    }

    public Scene (String name) {
        super(name);
        _objects = new ArrayList<SceneObject>();
        _sceneScale = new PVector(1, 1);
        sceneManager.AddScene(this);
    }


    /**
     シーンの初期化を行う。
     ゲーム開始時に呼び出される。
     */
    public void InitScene() {
        _isNeedSorting = true;
        _Sorting();
    }

    /**
     　アクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Enabled() {
        _enabledFlag = false;
    }

    /**
     ノンアクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Disabled() {
        _disabledFlag = false;
        _Stop();
    }


    /**
     毎フレームのシーン更新処理。
     */
    public void Update() {
        _ResetBackGround();
        _Start();
        _Update();
        _Animation();
        _ResetMatrix();
        _Transform();
        _Sorting();
        _CheckMAO();
        _Draw();
    }

    protected void _ResetBackGround() {
        background(0);
    }

    /**
     フレームの最初に呼び出される。
     _Stopと異なり、オブジェクトごとにタイミングが異なるのでフレーム毎に呼び出される。
     */
    protected void _Start() {
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
    protected void _Stop() {
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
    protected void _Update() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                s.Update();
            }
        }
    }

    /**
     _Updateとは異なり、AnimationBehaviorによる高度なフレームアニメーションを行う。
     主に子オブジェクトのアニメーションや画像連番表示を処理するのに用いる。
     */
    protected void _Animation() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.GetBehavior(SceneObjectAnimationController.class) != null) {
                s.Animation();
            }
        }
    }

    /**
     アフィン行列を初期化する。
     */
    protected void _ResetMatrix() {
        while (matrixManager.PopMatrix());
        resetMatrix();
    }

    /**
     シーンの平行移動と回転を行う。
     */
    public void TransformScene() {
        PVector p = GetTransform().GetPosition();
        resetMatrix();
        scale(GetSceneScale().x, GetSceneScale().y);
        translate(p.x, p.y);
        rotate(GetTransform().GetRotate());
    }

    /**
     オブジェクトを移動させる。
     ここまでに指示されたトランスフォームの移動は、全てここで処理される。
     それ以降のトランスフォーム処理は無視される。
     */
    protected void _Transform() {
        TransformScene();

        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsChildOf(this)) {
                s.GetTransform().Transform();
            }
        }
    }

    /**
     オブジェクトのトランスフォームの優先度によってソートする。
     毎度処理していると重くなるのフラグが立っている時のみ処理する。
     */
    protected void _Sorting() {
        if (!_isNeedSorting) {
            return;
        }
        _isNeedSorting = false;
        Collections.sort(_objects);
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     ただし、マウス操作している時だけしか判定しない。
     */
    protected void _CheckMAO() {
        if (!inputManager.IsMouseMode()) {
            return;
        }

        SceneObject s;
        boolean f = false;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsAbleAO()) {
                if (s == _activeObject) {
                    // 現在のMAOが次のMAOになるならば、何もせずに処理を終わる。
                    return;
                }
                f = true;

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
    protected void _Draw() {
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
        fill(GetDrawBack().GetBackColorInfo().GetColor());
        TransformScene();
        PVector s = GetTransform().GetSize();
        rect(0, 0, s.x, s.y);
    }

    private boolean _CheckDisableMAO() {
        if (GetActiveObject() == null) {
            return true;
        }
        return !GetActiveObject().IsEnable();
    }

    public void OnMousePressed() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMousePressed();
    }

    public void OnMouseReleased() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMouseReleased();
    }

    public void OnMouseClicked() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnMouseClicked();
    }

    public void OnKeyPressed() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnKeyPressed();
    }

    public void OnKeyReleased() {
        if (_CheckDisableMAO()) {
            return;
        }
        GetActiveObject().OnKeyReleased();
    }

    /**
     自身のリストにオブジェクトを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) {
            return false;
        }
        object.GetTransform().SetParent(GetTransform(), true);
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
        }
        if (o == null) {
            return false;
        }
        if (!(o instanceof Scene)) {
            return false;
        }
        Scene s = (Scene) o;
        return GetName().equals(s.GetName());
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" \n");
        b.append("  name : ").append(GetName()).append(" \n");
        b.append("  objects :\n");
        b.append(_objects).append(" \n");

        return b.toString();
    }
}public final class SceneManager extends Abs_Manager {
    private ArrayList<Scene> _scenes;
    public ArrayList<Scene> GetScenes() {
        return _scenes;
    }

    /**
     現在描画されているシーン。
     */
    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }
    /**
     次にアクティブになるシーン。
     */
    private Scene _nextScene;

    /**
     シーンの読込要求が出された場合にtrueになる。
     */
    private boolean _loadFlag;

    public SceneManager () {
        _scenes = new ArrayList<Scene>();
        _InitSceneEvent();
    }

    private void _InitSceneEvent() {
        if (inputManager == null) {
            inputManager = new InputManager();
        }
        inputManager.GetMousePressedHandler().SetEvent("Scene Mouse Pressed", new Event() { 
            public void Event() {
                OnMousePressed();
            }
        }
        );
        inputManager.GetMouseReleasedHandler().SetEvent("Scene Mouse Released", new Event() {
            public void Event() {
                OnMouseReleased();
            }
        }
        );
        inputManager.GetMouseClickedHandler().SetEvent("Scene Mouse Clicked", new Event() {
            public void Event() {
                OnMouseClicked();
            }
        }
        );
        inputManager.GetKeyPressedHandler().SetEvent("Scene Key Pressed", new Event() {
            public void Event() {
                OnKeyPressed();
            }
        }
        );
        inputManager.GetKeyReleasedHandler().SetEvent("Scene Key Released", new Event() {
            public void Event() {
                OnKeyReleased();
            }
        }
        );
    }

    /**
     ゲームを開始するために一番最初に呼び出す処理。
     setup関数の一番最後に呼び出す必要がある。
     */
    public void Start(String sceneName) {
        _InitScenes();
        LoadScene(sceneName);
        Update();
    }

    /**
     シーンを読み込み、次のフレームからアクティブにさせる。
     */
    public void LoadScene(String sceneName) {
        Scene s = GetScene(sceneName);
        if (s == null) {
            return;
        }

        _nextScene = s;

        _loadFlag = true;
        _nextScene.SetEnabledFlag(true);

        if (_activeScene != null) {
            _activeScene.SetDisabledFlag(true);
        }
    }

    /**
     フレーム更新を行う。
     アクティブシーンのみ処理される。
     */
    public void Update() {
        if (_activeScene != null) {
            _activeScene.Update();
        }
        if (_loadFlag) {
            _ChangeScene();
        }
    }

    /**
     シーンを切り替える。
     シーンの終了処理と開始処理を呼び出す。
     */
    private void _ChangeScene() {
        _loadFlag = false;

        if (_activeScene != null) {
            _activeScene.Disabled();
        }
        if (_nextScene != null) {
            _nextScene.Enabled();
        }

        _activeScene = _nextScene;
        _nextScene = null;
    }

    /**
     シーンインスタンスを初期化する。
     主にシーン内のソーティングなどである。
     */
    private void _InitScenes() {
        if (_scenes == null) {
            return;
        }

        for (int i=0; i<_scenes.size(); i++) {
            _scenes.get(i).InitScene();
        }
    }

    private void OnMousePressed() {
        if (GetActiveScene() != null) {
            GetActiveScene().OnMousePressed();
        }
    }

    private void OnMouseReleased() {
        if (GetActiveScene() != null) {
            GetActiveScene().OnMouseReleased();
        }
    }

    private void OnMouseClicked() {
        if (GetActiveScene() != null) {
            GetActiveScene().OnMouseClicked();
        }
    }

    private void OnMouseWheel() {
    }

    private void OnMouseMoved() {
    }

    private void OnMouseDragged() {
    }

    private void OnMouseEntered() {
    }

    private void OnMouseExited() {
    }

    private void OnKeyPressed() {
        if (GetActiveScene() != null) {
            GetActiveScene().OnKeyPressed();
        }
    }

    private void OnKeyReleased() {
        if (GetActiveScene() != null) {
            GetActiveScene().OnKeyReleased();
        }
    }

    /**
     自身のリストにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        if (GetScene(scene.GetName()) != null) {
            return false;
        }
        return _scenes.add(scene);
    }

    /**
     自身のリストのindex番目のシーンを返す。
     負数を指定した場合、後ろからindex番目のシーンを返す。
     
     @return index番目のシーン 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene GetScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のシーンを返す。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene GetScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したシーンが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveScene(Scene scene) {
        return _scenes.remove(scene);
    }

    /**
     自身のリストのindex番目のシーンを削除する。
     負数を指定した場合、後ろからindex番目のシーンを削除する。
     
     @return index番目のシーン 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene RemoveScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.remove(index);
    }

    /**
     自身のリストの中からnameと一致するシーンを削除する。
     
     @return nameと一致する名前のシーン 存在しなければNull
     */
    public Scene RemoveScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return _scenes.remove(i);
            }
        }
        return null;
    }

    /**
     自分以外は全てfalseを返す。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\n").append(getClass().getSimpleName()).append(" :\n");
        b.append(_scenes);
        return b.toString();
    }
}public class SceneObject implements Comparable<SceneObject> {
    private String _name;
    public String GetName() {
        return _name;
    }

    /**
     振る舞いリスト。
     */
    private ArrayList<Abs_SceneObjectBehavior> _behaviors;
    public ArrayList<Abs_SceneObjectBehavior> GetBehaviors() {
        return _behaviors;
    }

    /**
     自身が所属するシーンインスタンス。
     */
    private Scene _scene;
    public Scene GetScene() {
        return _scene;
    }

    /**
     自身のトランスフォーム。
     振る舞いリストとは独立して呼び出しやすいようにした。
     */
    private SceneObjectTransform _transform;
    public SceneObjectTransform GetTransform() {
        return _transform;
    }

    /**
     自身の背景描画ビヘイビア。
     振る舞いリストとは独立して呼び出しやすいようにした。
     */
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
    /**
     有効フラグを設定する。
     ただし、自身の親の有効フラグがfalseの場合、設定は反映されない。
     さらに、自身の設定を行うと同時に、階層構造的に子となる全てのオブジェクトの設定にも影響を与える。
     
     自身がシーンインスタンスであった場合は無視する。
     */
    public void SetEnable(boolean value) {
        if (this instanceof Scene) {
            return;
        }

        if (GetParent() == null) {
            return;
        }
        RecursiveSetEnable(value);
    }
    private void RecursiveSetEnable(boolean value) {
        _enable = value;

        ArrayList<SceneObjectTransform> list = _transform.GetChildren();
        for (int i=0; i<list.size(); i++) {
            list.get(i).GetObject().RecursiveSetEnable(value);
        }

        if (_enable) {
            _OnEnable();
        } else {
            _OnDisable();
        }
    }

    private boolean _isActivatable;
    public boolean IsActivatable() {
        return _isActivatable;
    }
    public void SetActivatable(boolean value) {
        _isActivatable = value;
    }

    /**
     Sceneインスタンス専用コンストラクタ。
     */
    protected SceneObject(String name) {
        _name = name;
        _scene = (Scene) this;

        _behaviors = new ArrayList<Abs_SceneObjectBehavior>();

        _transform = new SceneObjectTransform(this);
        _transform.SetSize(width, height);
        _transform.SetPriority(0);
        _drawBack = new SceneObjectDrawBack(this);
    }

    /**
     通常のSceneObjectインスタンス用のコンストラクタ。
     */
    public SceneObject(String name, Scene scene) {
        _name = name;

        _behaviors = new ArrayList<Abs_SceneObjectBehavior>();
        _scene = scene;
        _transform = new SceneObjectTransform(this);
        _drawBack = new SceneObjectDrawBack(this);

        scene.AddObject(this);

        // トランスフォームが設定されてからでないと例外を発生させてしまう
        SetEnable(true);
        SetActivatable(true);
    }

    /**
     シーンがアクティブになってから最初の一度だけ呼び出される。
     */
    public void Start() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Start();
            }
        }
    }

    /**
     シーンがノンアクティブになった時に呼び出される。
     振る舞いの有効フラグに関わらず必ず呼び出す。
     */
    public void Stop() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Stop();
            }
        }
    }

    public void Update() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Update();
            }
        }
    }

    public void Animation() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Animation();
            }
        }
    }

    public void Draw() {
        // 自身のトランスフォームをセットする
        setMatrix(GetTransform().GetMatrix());

        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.Draw();
            }
        }
    }

    public boolean IsAbleAO() {
        return IsActivatable() && _transform.IsInRegion(mouseX, mouseY);
    }

    protected void _OnEnable() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnEnabled();
            }
        }
    }

    protected void _OnDisable() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnDisabled();
            }
        }
    }

    public void OnEnabledActive() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnEnabledActive();
            }
        }
    }

    public void OnDisabledActive() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnDisabledActive();
            }
        }
    }

    public void OnMousePressed() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnMousePressed();
            }
        }
    }

    public void OnMouseReleased() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnMouseReleased();
            }
        }
    }

    public void OnMouseClicked() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnMouseClicked();
            }
        }
    }

    public void OnKeyPressed() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnKeyPressed();
            }
        }
    }

    public void OnKeyReleased() {
        Abs_SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnKeyReleased();
            }
        }
    }

    /**
     自身のリストに振る舞いを追加する。
     ただし、既に同じ系統の振る舞いが追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddBehavior(Abs_SceneObjectBehavior behavior) {
        if (IsHaveBehavior(behavior)) {
            return false;
        }
        return _behaviors.add(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを返す。
     負数を指定した場合、後ろからindex番目の振る舞いを返す。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Abs_SceneObjectBehavior GetBehavior(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.get(index);
    }

    /**
     自身のリストの中からbehaviorに該当する振る舞いを返す。
     
     @return behaviorに該当する名前の振る舞い 存在しなければNull
     */
    public Abs_SceneObjectBehavior GetBehavior(String behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストの中からbehaviorに該当する振る舞いを返す。
     
     @return behaviorに該当する名前の振る舞い 存在しなければNull
     */
    public Abs_SceneObjectBehavior GetBehavior(Class<? extends Abs_SceneObjectBehavior> behavior) {
        return GetBehavior(behavior.getSimpleName());
    }

    /**
     自身のリストに指定した振る舞いが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveBehavior(Abs_SceneObjectBehavior behavior) {
        return _behaviors.remove(behavior);
    }

    /**
     自身のリストのindex番目の振る舞いを削除する。
     負数を指定した場合、後ろからindex番目の振る舞いを削除する。
     
     @return index番目の振る舞い 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Abs_SceneObjectBehavior RemoveBehavior(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.remove(index);
    }

    /**
     自身のリストの中からbehaviorに該当する振る舞いを削除する。
     
     @return behaviorに該当する名前の振る舞い 存在しなければNull
     */
    public Abs_SceneObjectBehavior RemoveBehavior(String behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return _behaviors.remove(i);
            }
        }
        return null;
    }

    /**
     自身の振る舞いと指定した振る舞いとの間に同系統のものが存在した場合、trueを返す。
     */
    public boolean IsHaveBehavior(Abs_SceneObjectBehavior behavior) {
        Abs_SceneObjectBehavior s;
        for (int i=0; i<_behaviors.size(); i++) {
            s = _behaviors.get(i);
            if (s.equals(behavior)) {
                return true;
            }
        }
        return false;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Transfrom generally method
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

    /**
     自身以外はfalseを返す。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    /**
     Transformに記録されている優先度によって比較する。
     */
    public int compareTo(SceneObject s) {
        return _transform.compareTo(s.GetTransform());
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" :\n");
        b.append("  name : ").append(_name).append(" \n");
        b.append("  behaviors :\n");
        b.append(_behaviors).append(" \n");

        return b.toString();
    }
}public final class SceneObjectAnchor {
    public final static int LEFT_TOP = 0; 
    public final static int LEFT_MIDDLE = 1; 
    public final static int LEFT_BOTTOM = 2;
    public final static int CENTER_TOP = 3;
    public final static int CENTER_MIDDLE = 4; 
    public final static int CENTER_BOTTOM = 5;
    public final static int RIGHT_TOP = 6;
    public final static int RIGHT_MIDDLE = 7; 
    public final static int RIGHT_BOTTOM = 8;

    private final static float _LEFT = 0;
    private final static float _CENTER = 0.5;
    private final static float _RIGHT = 1;

    private final static float _TOP = 0;
    private final static float _MIDDLE = 0.5;
    private final static float _BOTTOM = 1;

    private int _anchor;
    public int GetAnchor() {
        return _anchor;
    }
    public void SetAnchor(int value) {
        if (0 <= value && value < 9) {
            _anchor = value;
        }
    }

    public SceneObjectAnchor() {
        SetAnchor(LEFT_TOP);
    }

    public SceneObjectAnchor(int anchor) {
        SetAnchor(anchor);
    }

    public float GetHorizontal() {
        return (_anchor / 3) / 2f;
    }

    public float GetVertical() {
        return (_anchor % 3) / 2f;
    }

    public boolean IsLeft() {
        return GetHorizontal() == _LEFT;
    }

    public boolean IsCenter() {
        return GetHorizontal() == _CENTER;
    }

    public boolean IsRight() {
        return GetHorizontal() == _RIGHT;
    }

    public boolean IsTop() {
        return GetVertical() == _TOP;
    }

    public boolean IsMiddle() {
        return GetVertical() == _MIDDLE;
    }

    public boolean IsBottom() {
        return GetVertical() == _BOTTOM;
    }
}public class SceneObjectAnimationController extends Abs_SceneObjectBehavior {
    public SceneObjectAnimationController(SceneObject obj) {
        super(obj);
    }
}public class SceneObjectBehavior extends Abs_SceneObjectBehavior {
    public SceneObjectBehavior(SceneObject obj) {
        super(obj);
    }

    protected String _OldestClassName() {
        return "SceneObjectBehavior";
    }
}public class SceneObjectButton extends Abs_SceneObjectBehavior {
    private ActionEvent _decideHandler;
    public ActionEvent GetDicideHandler() {
        return _decideHandler;
    }

    public SceneObjectButton(SceneObject obj) {
        super(obj);

        _decideHandler = new ActionEvent();
    }

    public void OnMouseClicked() {
        GetDicideHandler().InvokeAllEvents();
    }

    public void OnKeyReleased() {
        if (inputManager.IsClickedKey(Key._ENTER)) {
            GetDicideHandler().InvokeAllEvents();
        }
    }
}public class SceneObjectCursor extends Abs_SceneObjectBehavior {
    /**
     漠然とカーソルが押された時にイベントを発生させる。
     何のキーなのかは問わない。
     */
    private ActionEvent _cursorHandler;
    public ActionEvent GetCursorHandler() {
        return _cursorHandler;
    }

    private ActionEvent _upCursorHandler;
    public ActionEvent GetUpCursorHandler() {
        return _upCursorHandler;
    }

    private ActionEvent _downCursorHandler;
    public ActionEvent GetDownCursorHandler() {
        return _downCursorHandler;
    }

    private ActionEvent _leftCursorHandler;
    public ActionEvent GetLeftCursorHandler() {
        return _leftCursorHandler;
    }

    private ActionEvent _rightCursorHandler;
    public ActionEvent GetRightCursorHandler() {
        return _rightCursorHandler;
    }

    public SceneObjectCursor(SceneObject obj) {
        super(obj);

        _cursorHandler = new ActionEvent();
        _upCursorHandler = new ActionEvent();
        _downCursorHandler = new ActionEvent();
        _leftCursorHandler = new ActionEvent();
        _rightCursorHandler = new ActionEvent();
    }

    public void OnKeyReleased() {
        boolean up, down, left, right;
        up = inputManager.IsClickedKey(Key._UP);
        down = inputManager.IsClickedKey(Key._DOWN);
        left = inputManager.IsClickedKey(Key._LEFT);
        right = inputManager.IsClickedKey(Key._RIGHT);

        if (up || down || left || right) {
            GetCursorHandler().InvokeAllEvents();
            if (up) {
                GetUpCursorHandler().InvokeAllEvents();
            }
            if (down) {
                GetDownCursorHandler().InvokeAllEvents();
            }
            if (left) {
                GetLeftCursorHandler().InvokeAllEvents();
            }
            if (right) {
                GetRightCursorHandler().InvokeAllEvents();
            }
        }
    }
}public class SceneObjectDrawBack extends Abs_SceneObjectBehavior { //<>//
    /**
     背景の色情報。
     */
    private DrawColor _backColorInfo;
    public DrawColor GetBackColorInfo() {
        return _backColorInfo;
    }

    /**
     ボーダの色情報。
     */
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

    /**
     ボーダの直径。
     */
    private float _borderSize;
    public float GetBorderSize() {
        return _borderSize;
    }
    public void SetBorderSize(float value) {
        _borderSize = value;
    }

    /**
     ボーダの端の形。
     */
    private int _borderType;
    public int GetBorderType() {
        return _borderType;
    }
    public void SetBorderType(int value) {
        _borderType = value;
    }

    private PVector _size;

    public SceneObjectDrawBack(SceneObject obj) {
        super(obj);

        DrawColor backInfo, borderInfo;
        backInfo = new DrawColor(true, 100, 100, 100, 255);
        borderInfo = new DrawColor(true, 0, 0, 0, 255);

        _InitParameterOnConstructor(true, backInfo, true, borderInfo, 1, ROUND);
    }

    public SceneObjectDrawBack(SceneObject obj, boolean enableBack, DrawColor backInfo, boolean enableBorder, DrawColor borderInfo, float borderSize, int borderType) {
        super(obj);
        _InitParameterOnConstructor(enableBack, backInfo, enableBorder, borderInfo, borderSize, borderType);
    }

    public SceneObjectDrawBack(SceneObject obj, boolean enableBack, boolean backColorMode, float ba1, float ba2, float ba3, float ba4, boolean enableBorder, boolean borderColorMode, float bo1, float bo2, float bo3, float bo4) {
        super(obj);

        DrawColor backInfo, borderInfo;
        backInfo = new DrawColor(backColorMode, ba1, ba2, ba3, ba4);
        borderInfo = new DrawColor(borderColorMode, bo1, bo2, bo3, bo4);

        _InitParameterOnConstructor(enableBack, backInfo, enableBorder, borderInfo, 1, ROUND);
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
        if (_size == null) {
            return;
        }

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
}public class SceneObjectImage extends Abs_SceneObjectDrawBase {
    private String _usingImageName;
    public String GetUsingImageName() {
        return _usingImageName;
    }
    public void SetUsingImageName(String value) {
        if (value != null) {
            _usingImageName = value;
        }
    }

    private PVector _objSize;

    public SceneObjectImage(SceneObject obj) {
        super(obj);
    }

    public SceneObjectImage(SceneObject obj, String imagePath) {
        super(obj);
        SetUsingImageName(imagePath);
    }

    public void Start() {
        _objSize = GetObject().GetTransform().GetSize();
    }

    public void Draw() {
        PImage img = imageManager.GetImage(GetUsingImageName());
        if (img == null) {
            return;
        }
        tint(GetColorInfo().GetColor());
        image(img, 0, 0, _objSize.x, _objSize.y);
    }
}public class SceneObjectText extends Abs_SceneObjectDrawBase {
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
        }
    }

    private int _verticalAlign;
    public int GetVerticalAlign() {
        return _verticalAlign;
    }
    public void SetVerticalAlign(int value) {
        if (value == TOP || value == CENTER || value == BOTTOM || value == BASELINE) {
            _verticalAlign = value;
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


    public SceneObjectText(SceneObject obj) {
        super(obj);
        _InitParameterOnConstructor("");
    }

    public SceneObjectText(SceneObject obj, String text) {
        super(obj);
        _InitParameterOnConstructor(text);
    }

    private void _InitParameterOnConstructor(String text) {
        SetText(text);
        SetAlign(LEFT, TOP);
        SetFontSize(20);
        SetLineSpace(0);
        SetUsingFontName("MS Gothic");
    }

    public void Start() {
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
        if (GetText() == null) {
            return;
        }
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

        text(_tempText, 0, 0, _objSize.x, _objSize.y);
    }
}public final class SceneObjectTransform extends Abs_SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    /**
     親トランスフォーム。
     */
    private SceneObjectTransform _parent;
    public SceneObjectTransform GetParent() {
        return _parent;
    }
    /**
     親トランスフォームを設定する。
     自動的に前の親との親子関係は絶たれる。
     ただし、指定したトランスフォームがnullの場合は、シーンインスタンスが親になる。
     
     isPriorityChangeがtrueの場合、自動的に親の優先度より1だけ高い優先度がつけられる。
     */
    public void SetParent(SceneObjectTransform value, boolean isPriorityChange) {
        if (GetObject() instanceof Scene) {
            return;
        }

        SceneObjectTransform t = GetScene().GetTransform();
        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        if (value == null) {
            _parent = t;
            t._AddChild(this);
        } else {
            _parent = value;
            _parent._AddChild(this);
        }
        if (isPriorityChange) {
            SetPriority(GetParent().GetPriority() + 1);
        }
    }

    /**
     子トランスフォームリスト。
     */
    private ArrayList<SceneObjectTransform> _children;
    public ArrayList<SceneObjectTransform> GetChildren() {
        return _children;
    }

    /**
     親へのアンカー。
     親のどの箇所を基準にするのかを定める。
     */
    private SceneObjectAnchor _parentAnchor;
    public SceneObjectAnchor GetParentAnchor() {
        return _parentAnchor;
    }
    public void SetParentAnchor(int value) {
        if (_parentAnchor != null) {
            _parentAnchor.SetAnchor(value);
        }
    }

    /**
     自身のアンカー。
     親の基準に対して、自身のどの箇所を基準にするのかを定める。
     */
    private SceneObjectAnchor _selfAnchor;
    public SceneObjectAnchor GetSelfAnchor() {
        return _selfAnchor;
    }
    public void SetSelfAnchor(int value) {
        if (_selfAnchor != null) {
            _selfAnchor.SetAnchor(value);
        }
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
            if (!(GetObject() instanceof Scene)) {
                GetScene().SetNeedSorting(true);
            }
        }
    }

    /**
     絶対変化量行列。
     これを変換行列としてから描画することで絶対変化量が表現する図形として描画される。
     */
    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }
    private void _PushMatrix() {
        getMatrix(_matrix);
    }

    /**
     平行移動量と回転量の表現しているものが、親トランスフォームの相対量なのか、シーンからの絶対量なのかを決める。
     trueの場合、相対量となる。
     */
    private boolean _isRelative;
    public boolean IsRelative() {
        return _isRelative;
    }
    public void SetRelative(boolean value) {
        _isRelative = value;
    }

    /**
     平行移動量。
     */
    private PVector _position;
    public PVector GetPosition() {
        return _position;
    }
    public void SetPosition(PVector value) { 
        _position = value;
    }
    public void SetPosition(float x, float y) {
        _position.set(x, y);
    }

    /**
     回転量。
     */
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

    /**
     図形の描画領域。
     */
    private PVector _size;
    public PVector GetSize() {
        return _size;
    }
    public void SetSize(PVector value) {
        _size = value;
    }
    public void SetSize(float x, float y) {
        _size.set(x, y);
    }

    public SceneObjectTransform(SceneObject obj) {
        super(obj);
        _position = new PVector();
        _rotate = 0;
        _size = new PVector();
        _parentAnchor = new SceneObjectAnchor();
        _selfAnchor = new SceneObjectAnchor();
        _priority = 1;
        _isRelative = true;

        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     */
    public void Transform() {
        if (!GetObject().IsEnable()) {
            return;
        }
        // 保存の限界でないかどうか
        if (!matrixManager.PushMatrix()) {
            return;
        }

        // 相対量か絶対量かを指定
        SceneObjectTransform parent;
        if (_isRelative) {
            parent = _parent;
        } else {
            parent = GetScene().GetTransform();
            GetScene().TransformScene();
        }

        float par1, par2;

        // 親の基準へ移動
        par1 = _parentAnchor.GetHorizontal();
        par2 = _parentAnchor.GetVertical();
        translate(par1 * parent.GetSize().x, par2 * parent.GetSize().y);

        // 自身の基準での回転
        rotate(_rotate);

        // 自身の基準へ移動
        par1 = _selfAnchor.GetHorizontal();
        par2 = _selfAnchor.GetVertical();
        translate(-par1 * _size.x + _position.x, -par2 * _size.y + _position.y);

        // 再帰的に計算していく
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i).Transform();
            }
        }
        _PushMatrix();
        matrixManager.PopMatrix();
    }

    /**
     指定座標がトランスフォームの領域内であればtrueを返す。
     */
    public boolean IsInRegion(float y, float x) {
        PMatrix2D inv = GetMatrix().get();
        if (!inv.invert()) {
            println(this);
            println("逆アフィン変換ができません。");
            return false;
        }

        float[] in, out;
        in = new float[]{y, x};
        out = new float[2];
        inv.mult(in, out);
        return 0 <= out[0] && out[0] < _size.x && 0 <= out[1] && out[1] < _size.y;
    }

    /**
     自身が指定されたトランスフォームの親の場合、trueを返す。
     */
    public boolean IsParentOf(SceneObjectTransform t) {
        return this == t.GetParent();
    }

    /**
     自身が指定されたトランスフォームの子の場合、trueを返す。
     */
    public boolean IsChildOf(SceneObjectTransform t) {
        return _parent == t;
    }

    /**
     自身の子としてトランスフォームを追加する。
     ただし、既に子として存在している場合は追加できない。
     基本的に、親トランスフォームから親子関係を構築するのは禁止する。
     
     @return 追加に成功した場合はtrueを返す
     */
    private boolean _AddChild(SceneObjectTransform t) {
        if (GetChildren().contains(t)) {
            return false;
        }
        return _children.add(t);
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
        if (o == this) {
            return true;
        }
        return false;
    }

    /**
     優先度によって比較を行う。
     */
    public int compareTo(SceneObjectTransform t) {
        return _priority - t.GetPriority();
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(super.toString());

        return b.toString();
    }
}