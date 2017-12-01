import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
ImageManager imageManager;
FontManager fontManager;

Scene scene;
SceneObjectTransform objT1, objT2;
float x;
boolean isRotate;
void setup() {
    size(1066, 600, P3D);
    try {
        InitManager();

        //scene = new Scene("main");
        //scene.GetTransform().SetPosition(width * 0.5, 0);
        //scene.SetSceneScale(0.5, 1);
        //scene.GetDrawBack().GetBackColorInfo().SetColor(100, 0, 100);

        //SceneObject o = new SceneObject("camera?", scene);
        //SetText(o);
        //objT1 = o.GetTransform();
        //objT1.SetSize(100, 100);
        //objT1.SetParentAnchor(Anchor.CENTER_MIDDLE);
        //objT1.SetSelfAnchor(Anchor.CENTER_MIDDLE);

        //SceneObject o1 = new SceneObject("Overlapped", scene);
        //o1.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        ////SetImage(o1);
        //SetButton(o1);
        //objT2 = o1.GetTransform();
        //objT2.SetParent(o.GetTransform(), true);
        //objT2.SetSize(100, 140);
        //objT2.SetParentAnchor(Anchor.CENTER_MIDDLE);

        //sceneManager.Start("main");
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
}

void SetImage(SceneObject o) {
    //SceneObjectImage i = new SceneObjectImage(o);
    //i.SetUsingImageName("icon.png");
}

void SetText(SceneObject o) {
    //SceneObjectText t = new SceneObjectText(o, "TestTestTestTestTestTestTestTest");
    //t.SetDrawInOrder(true);
    //t.SetDrawSpeed(10);
    //t.GetColorInfo().SetColor(0, 0, 200);
}

void SetButton(SceneObject o) {
    //SceneObjectButton b = new SceneObjectButton(o);
    //b.GetDicideHandler().AddEvent("pushed", new Event() {
    //    public void Event() {
    //        OnDecide();
    //    }
    //}
    //);
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


public void SetAffineMatrix(float[] e) {
    if (e == null) return;
    if (e.length < 6) return;
    resetMatrix();
    applyMatrix(
        e[0], e[1], 0, e[2] - width/2f, 
        e[3], e[4], 0, e[5] - height/2f, 
        0, 0, 1, -0.866 * height, 
        0, 0, 0, 1
        );
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
/**
 IEventインスタンスをHashMapで管理することに責任を持つ。
 */
public final class ActionEvent {
    private HashMap<String, IEvent> _events;
    private HashMap<String, IEvent> GetEventHash() {
        return _events;
    }

    public ActionEvent() {
        _events = new HashMap<String, IEvent>();
    }

    public void AddEvent(String eventLabel, IEvent event) {
        if (!GetEventHash().containsKey(eventLabel) && event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }

    public void SetEvent(String eventLabel, IEvent event) {
        if (event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }

    public IEvent GetEvent(String eventLabel) {
        return GetEventHash().get(eventLabel);
    }

    public IEvent RemoveEvent(String eventLabel) {
        return GetEventHash().remove(eventLabel);
    }

    public void RemoveAllEvents() {
        GetEventHash().clear();
    }

    public void InvokeEvent(String eventLabel) {
        IEvent e = GetEvent(eventLabel);
        if (e != null) {
            e.Event();
        }
    }

    public void InvokeAllEvents() {
        for (String label : GetEventHash().keySet()) {
            InvokeEvent(label);
        }
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
/**
ObjectBehavior及びサブクラスを特定するためのIDを定義する責任を持つ。
*/
public final class ClassID {
    public static final int BEHAVIOR = 0;
    public static final int TRANSFORM = 1;
    public static final int DRAW_BACK = 2;
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
public final static class GeneralJudge {
    /**
    指定したクラスが指定したインターフェースを実装しているかどうか。
    */
    //public static boolean IsImplemented(Class<?> clazz, Class<?> intrfc) {
    //    if (clazz == null || intrfc == null) {
    //        return false;
    //    }
    //    // インターフェースを実装したクラスであるかどうかをチェック
    //    if (!clazz.isInterface() && intrfc.isAssignableFrom(clazz)
    //            && !Modifier.isAbstract(clazz.getModifiers())) {
    //        return true;
    //    }
    //    return false;
    //}
}
public interface IEvent {
    public void Event();
}
public final class ImageManager {
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

        GetMouseEnteredHandler().AddEvent("Mouse Entered Window", new IEvent() { 
            public void Event() {
                println("Mouse Enterd on Window!");
            }
        }
        );

        GetMouseExitedHandler().AddEvent("Mouse Exited Window", new IEvent() {
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

    /**
     引数で与えられた列挙定数に対して、その列挙されたものだけが押されている状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsPressedKeysOnly(int[] inputs) {
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

    /**
     引数で与えられた列挙定数に対して、その列挙されたものだけがクリックされた状態ならばtrueを、そうでなければfalseを返す。
     引数が列挙定数の範囲外の場合は、必ずfalseが返される。
     */
    public boolean IsClickedKeysOnly(int[] inputs) {
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
}
public class Key {
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
public static class Matrix2D {
    private static boolean _CheckInvalid(float[] e) {
        if (e == null) return true;
        if (e.length < 6) return true;
        return false;
    }

    public static void Reset(float[] e) {
        if (_CheckInvalid(e)) return;
        for (int i=0; i<6; i++) {
            if (i == 0 || i == 4) {
                e[i] = 1;
            } else {
                e[i] = 0;
            }
        }
    }

    public static void Translate(float[] e, float x, float y) {
        if (_CheckInvalid(e)) return;
        e[2] += e[0] * x + e[1] * y;
        e[5] += e[3] * x + e[4] * y;
    }

    public static void Rotate(float[] e, float rad) {
        if (_CheckInvalid(e)) return;
        float e0, e1, e3, e4, s, c;
        e0 = e[0];
        e1 = e[1];
        e3 = e[3];
        e4 = e[4];
        s = sin(rad);
        c = cos(rad);
        e[0] = e0 * c + e1 * s;
        e[1] = e0 * s - e1 * c;
        e[3] = e3 * c + e4 * s;
        e[4] = e3 * s - e4 * c;
    }

    public static void Scale(float[] e, float x, float y) {
        if (_CheckInvalid(e)) return;
        e[0] *= x;
        e[1] *= y;
        e[3] *= x;
        e[4] *= y;
    }

    public static void Get(float[] e, PMatrix2D matrix) {
        if (_CheckInvalid(e)) return;
        if (matrix == null) return;
        matrix.apply(
            e[0], e[1], e[2], 
            e[3], e[4], e[5]
            );
    }

    public static void Copy(float[] _in, float[] _out) {
        if (_CheckInvalid(_in) || _CheckInvalid(_out)) return;
        for (int i=0; i<6; i++) {
            _out[i] = _in[i];
        }
    }
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

    public Scene (String name) {
        _name = name;
        _collection = new Collection<SceneObject>();
        _objects = new ArrayList<SceneObject>();
        _transform = new SceneObjectTransform();
        sceneManager.AddScene(this);
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
        _enabledFlag = false;
    }

    /**
     シーンマネージャの描画リストから外された時に呼び出される。
     */
    public void OnDisabled() {
        _disabledFlag = false;
        Stop();
    }

    public void OnEnableActive() {
    }

    public void OnDisableActive() {
    }

    /**
     フレームの最初に呼び出される。
     Stopと異なり、オブジェクトごとにタイミングが異なるのでフレーム毎に呼び出される。
     */
    protected void Start() {
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
    protected void Stop() {
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
    protected void Update() {
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
    protected void Sorting() {
        if (!_isNeedSorting) return;
        _isNeedSorting = false;
        _collection.SortList(GetObjects());
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     ただし、マウス操作している時だけしか判定しない。
     */
    protected void CheckMAO() {
        if (!inputManager.IsMouseMode()) return;

        SceneObject s;
        boolean f = false;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsAbleAO()) {
                // 現在のMAOが次のMAOになるならば、何もせずに処理を終わる。
                if (s == _activeObject) return;

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
    protected void Draw() {
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
        GetTransform().SetAffine();
        PVector s = GetTransform().GetSize();
        rect(0, 0, s.x, s.y);
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
    
    public int compareTo(Scene o) {
        return GetScenePriority() - o.GetScenePriority();
    }
}
public class SceneManager {
    /**
    保持しているシーン。
    */
    private HashMap<String, Scene> _scenes;

    /**
    描画するシーン。
    シーンの優先度によって描画順が替わる。
    */
    private ArrayList<Scene> _drawScenes;

    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }
    private Scene _nextScene;

    private Collection<Scene> _collection;

    private boolean _loadFlag;

    public SceneManager () {
        _scenes = new HashMap<String, Scene>();
        _drawScenes = new ArrayList<Scene>();
        _collection = new Collection<Scene>();
        _InitSceneEvent();
    }

    private void _InitSceneEvent() {
        if (inputManager == null) {
            inputManager = new InputManager();
        }
        inputManager.GetMousePressedHandler().SetEvent("Scene Mouse Pressed", new IEvent() { 
            public void Event() {
                OnMousePressed();
            }
        }
        );
        inputManager.GetMouseReleasedHandler().SetEvent("Scene Mouse Released", new IEvent() {
            public void Event() {
                OnMouseReleased();
            }
        }
        );
        inputManager.GetMouseClickedHandler().SetEvent("Scene Mouse Clicked", new IEvent() {
            public void Event() {
                OnMouseClicked();
            }
        }
        );
        inputManager.GetKeyPressedHandler().SetEvent("Scene Key Pressed", new IEvent() {
            public void Event() {
                OnKeyPressed();
            }
        }
        );
        inputManager.GetKeyReleasedHandler().SetEvent("Scene Key Released", new IEvent() {
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

        //if (_activeScene != null) {
        //    _activeScene.Disabled();
        //}
        //if (_nextScene != null) {
        //    _nextScene.Enabled();
        //}

        //_activeScene = _nextScene;
        //_nextScene = null;
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
    }

    private void OnMouseReleased() {
    }

    private void OnMouseClicked() {
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
    }

    private void OnKeyReleased() {
    }

    /**
     自身のリストにシーンを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        //if (GetScene(scene.GetName()) != null) {
            return false;
        //}
        //return _scenes.add(scene);
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
    //public boolean RemoveScene(Scene scene) {
        //return _scenes.remove(scene);
    //}

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

    /**
     オブジェクトは一回だけシーンを設定することができる。
     */
    private Scene _scene;
    public Scene GetScene() {
        return _scene;
    }
    public void SetScene(Scene value) {
        if (_isSettedScene) return;
        if (value == null) return;
        _isSettedScene = true;
        _scene = value;
    }
    private boolean _isSettedScene;

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

    public SceneObject(String name) {
        _name = name;

        _behaviors = new ArrayList<SceneObjectBehavior>();
        _transform = new SceneObjectTransform();
        AddBehavior(_transform);
        
        _drawBack = new SceneObjectDrawBack();
        AddBehavior(_drawBack);

        // トランスフォームが設定されてからでないと例外を発生させてしまう
        SetEnable(true);
        SetActivatable(true);
    }

    public void Start() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
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
        SceneObjectBehavior b;
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
    }

    protected void _OnDisable() {
    }

    public void OnEnabledActive() {
        SceneObjectBehavior b;
        for (int i=0; i<_behaviors.size(); i++) {
            b = _behaviors.get(i);
            if (b.IsEnable()) {
                b.OnEnabledActive();
            }
        }
    }

    public void OnDisabledActive() {
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
public class SceneObjectBehavior {
    /**
     残念ながら全てのビヘイビアクラスがこれを継承して適切な値を返さなければならない。
     */
    public int GetID() {
        return ClassID.BEHAVIOR;
    }

    /**
     振る舞いは一回だけオブジェクトを設定することができる。
     */
    private SceneObject _object;
    public SceneObject GetObject() {
        return _object;
    }
    public void SetObject(SceneObject value) {
        if (_isSettedObject) return;
        if (value == null) return;
        _isSettedObject = true;
        _object = value;
    }
    private boolean _isSettedObject;

    public Scene GetScene() {
        if (GetObject() == null) return null;
        return GetObject().GetScene();
    }

    private boolean _enable;
    public boolean IsEnable() {
        return _enable;
    }
    public void SetEnable(boolean value) {
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
public class SceneObjectButton extends SceneObjectBehavior {
    private ActionEvent _decideHandler;
    public ActionEvent GetDicideHandler() {
        return _decideHandler;
    }

    public SceneObjectButton() {
        super();

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
}
public class SceneObjectDrawBack extends SceneObjectBehavior { //<>//
    public int GetID() {
        return ClassID.DRAW_BACK;
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
}
public class SceneObjectDrawBase extends SceneObjectBehavior {
    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public SceneObjectDrawBase() {
        _colorInfo = new DrawColor();
    }
}
public class SceneObjectImage extends SceneObjectDrawBase {
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

    public SceneObjectImage() {
        super();
    }

    public SceneObjectImage(String imagePath) {
        super();
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
}
public class SceneObjectText extends SceneObjectDrawBase {
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


    public SceneObjectText() {
        super();
        _InitParameterOnConstructor("");
    }

    public SceneObjectText(String text) {
        super();
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
}
public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    public int GetID() {
        return ClassID.TRANSFORM;
    }

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
        if (!_isSettableParent) return;

        if (_parent != null) {
            _parent.RemoveChild(this);
        }
        if (value == null) {
            SceneObjectTransform t = GetScene().GetTransform();
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
     親トランスフォームを設定可能である場合は、trueとなる。
     */
    private boolean _isSettableParent;

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
            GetScene().SetNeedSorting(true);
        }
    }

    /**
     グローバルトランスフォーム行列。
     */
    private float[] _matrix;
    public void SetAffine() {
        SetAffineMatrix(_matrix);
    }

    /**
     マウス判定用行列。
     */
    private PMatrix2D _mouseMatrix;

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

        _priority = 1;
        _children = new ArrayList<SceneObjectTransform>();
        _mouseMatrix = new PMatrix2D();
        _matrix = new float[6];
    }

    /**
     オブジェクトのトランスフォーム処理を実行する。
     */
    public void Transform(float[] mat) {
        if (!GetObject().IsEnable()) return;
        // 親から継承した行列を複製
        Matrix2D.Copy(mat, _matrix);

        float x, y;
        x = GetTranslation().x;
        y = GetTranslation().y;
        if (GetParent() != null) {
            // アンカーの座標へ移動
            float aX, aY;
            aX = (GetAnchor().GetMaxX() + GetAnchor().GetMinX()) / 2;
            aY = (GetAnchor().GetMaxY() + GetAnchor().GetMinY()) / 2;
            Matrix2D.Translate(_matrix, aX * GetParent().GetSize().x, aY * GetParent().GetSize().y);

            if (GetAnchor().GetMaxX() == GetAnchor().GetMinX()) {
                aX = (GetAnchor().GetMaxX() - GetAnchor().GetMinX()) * GetParent().GetSize().x;
                x = 0;
                SetSize(aX, GetSize().y);
            }
            if (GetAnchor().GetMaxY() == GetAnchor().GetMinY()) {
                aY = (GetAnchor().GetMaxY() - GetAnchor().GetMinY()) * GetParent().GetSize().y;
                y = 0;
                SetSize(GetSize().x, aY);
            }
        }

        // 親空間での相対座標へ移動
        Matrix2D.Translate(_matrix, x, y);

        // 自空間での回転
        Matrix2D.Rotate(_matrix, GetRotate());

        // 自空間でのスケーリング
        Matrix2D.Scale(_matrix, GetScale().x, GetScale().y);

        // ピボットの座標へ移動
        Matrix2D.Translate(_matrix, GetPivot().GetX() * GetSize().x, GetPivot().GetY() * GetSize().y);

        // 再帰的に計算していく
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i).Transform(_matrix);
            }
        }
    }

    /**
     指定座標がトランスフォームの領域内であればtrueを返す。
     */
    public boolean IsInRegion(float y, float x) {
        Matrix2D.Get(_matrix, _mouseMatrix);
        if (!_mouseMatrix.invert()) {
            println(this);
            println("逆アフィン変換ができません。");
            return false;
        }

        float[] _in, _out;
        _in = new float[]{y, x};
        _out = new float[2];
        _mouseMatrix.mult(_in, _out);
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
}
/**
 アフィン変換一回分の情報に責任を持つ。
 サイズは持たない。
 */
public class Transform {
    private PVector _translation;
    public PVector GetTranslation() {
        return _translation;
    }
    public void SetTranslation(PVector value) {
        if (value == null) return;
        _translation = value;
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
        _scale = value;
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

        SetTranslation(position);
        SetScale(scale);
        SetRotate(rotate);
    }
}
