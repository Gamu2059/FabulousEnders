/**
 接頭辞について。
 PE ... ProcessingEngineの略称。Pjsで動作する保証がないクラス。要検証。
 PEO... ProcessingEngineOnlyの略称。Pjsで動作しないことが分かりきっているクラス。
 */

import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
ImageManager imageManager;
FontManager fontManager;
TransformManager transformManager;
PEOScenePositionManager peoScenePositionManager;

void setup() {
    surface.setSize(displayWidth * 3 / 4, displayHeight * 3 / 4);
    surface.setLocation(0, 0);
    try {
        InitManager();
        
        PEOSceneMenuBar menu = new PEOSceneMenuBar();
        sceneManager.AddScene(menu);
        sceneManager.LoadScene(menu.GetName());
        
        PEOSceneOperationBar operation = new PEOSceneOperationBar();
        sceneManager.AddScene(operation);
        sceneManager.LoadScene(operation.GetName());
        
        PEOSceneExplain explain = new PEOSceneExplain();
        sceneManager.AddScene(explain);
        sceneManager.LoadScene(explain.GetName());
        
        PEOSceneViewBase view = new PEOSceneViewBase("hoge", "Scene");
        sceneManager.AddScene(view);
        sceneManager.LoadScene(view.GetName());
        
        PEOSceneProjectBase project = new PEOSceneProjectBase("huga", "Project");
        sceneManager.AddScene(project);
        sceneManager.LoadScene(project.GetName());
        
        PEOSceneHeararchyBase heararchy = new PEOSceneHeararchyBase("heararchy", "Heararchy");
        sceneManager.AddScene(heararchy);
        sceneManager.LoadScene(heararchy.GetName());
        
        PEOSceneInspectorBase inspector = new PEOSceneInspectorBase("inspector", "Inspector");
        sceneManager.AddScene(inspector);
        sceneManager.LoadScene(inspector.GetName());

        sceneManager.Start();
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
    
    peoScenePositionManager = new PEOScenePositionManager();
}

void draw() {
    // これをつけているとpjsで動きません
    surface.setTitle("Game Maker fps : " + frameRate);
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
public interface Copyable<R> {
    public void CopyTo(R copy);
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
            value %= PConst.MAX_RED;
        } else if (!_isRGB && value > PConst.MAX_HUE) {
            value %= PConst.MAX_HUE;
        }
        _p1 = value;
    }

    public float GetGreenOrSaturation() {
        return _p2;
    }
    public void SetGreenOrSaturation(float value) {
        if (_isRGB && value > PConst.MAX_GREEN) {
            value %= PConst.MAX_GREEN;
        } else if (!_isRGB && value > PConst.MAX_SATURATION) {
            value %= PConst.MAX_SATURATION;
        }
        _p2 = value;
    }

    public float GetBlueOrBrightness() {
        return _p3;
    }
    public void SetBlueOrBrightness(float value) {
        if (_isRGB && value > PConst.MAX_BLUE) {
            value %=PConst. MAX_BLUE;
        } else if (!_isRGB && value > PConst.MAX_BRIGHTNESS) {
            value %= PConst.MAX_BRIGHTNESS;
        }
        _p3 = value;
    }

    public float GetAlpha() {
        return _alpha;
    }
    public void SetAlpha(float value) {
        if (value > PConst.MAX_ALPHA) {
            value %= PConst.MAX_ALPHA;
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
public interface IEvent {
    public void Event();
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
    public static final String IMAGE_PATH = "image/";
}
/**
 エンジン専用の定数を定義するクラス。
 */
public final class PEOConst {
    // 画像パス
    public static final String ENGINE = "Engine/";
    public static final String OPERATION_BAR_PATH = ENGINE + "OperationBar/";
    public static final String EDITOR_PATH = ENGINE + "Editor/";
    public static final String EDITOR_GENERAL_PATH = EDITOR_PATH + "General/";
    
    // エディタサイズ
    public static final float SLIDE_SPACE = 1.5;
    
    public static final float MENU_BAR_HEIGHT = 20;
    public static final float OPERATION_BAR_HEIGHT = 32;
    public static final float EXPLAIN_BAR_HEIGHT = 20;
    public static final float BAR_HEIGHT = MENU_BAR_HEIGHT + OPERATION_BAR_HEIGHT;
    
    public static final float MIN_VIEW_WIDTH = 220;
    public static final float MIN_VIEW_HEIGHT = 220;
    public static final float MIN_PROJECT_HEIGHT = 220;
    public static final float MIN_HIERARCHY_WIDTH = 220;
    public static final float MIN_INSPECTOR_WIDTH = 280;
    
    // エディタヘッダ
    public static final float TITLE_HEIGHT = 16;
    public static final float TITLE_MERGIN_WIDTH = 6;
    public static final float HEADER_HEIGHT = 18;
}
public final static class PEOGeneralJudge {
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
/**
 メニューアイテムオブジェクト。
 */
public class PEOMenu extends SceneObject {
    private SceneObjectText _text;
    public SceneObjectText GetText() {
        return _text;
    }

    private SceneObjectButton _button;

    private DrawColor _dc;

    public PEOMenu(String name, String t) {
        super(name);
        
        _dc = GetDrawBack().GetBackColorInfo();
        GetDrawBack().SetEnableBorder(false);
        _dc.SetColor(204, 232, 255, 0);

        _text = new SceneObjectText();
        _text.SetText(t);
        _text.SetFontSize(12);
        _text.SetUsingFontName("FFScala");
        _text.SetAlign(CENTER, CENTER);
        _text.GetColorInfo().SetColor(0, 0, 0);
        AddBehavior(_text);

        _button = new SceneObjectButton(name + t + " PMenu Label");
        AddBehavior(_button);
        _button.GetEnabledActiveHandler().SetEvent("mouse entered", new IEvent() {
            public void Event() {
                _dc.SetAlpha(255);
            }
        }
        );
        _button.GetDisabledActiveHandler().SetEvent("mouse exited", new IEvent() {
            public void Event() {
                _dc.SetAlpha(0);
            }
        }
        );
    }
}
/**
 メニューバーオブジェクト。
 */
public class PEOMenuBar extends SceneObject {
    private ArrayList<PEOMenu> _menus;

    private boolean _isStart;

    public PEOMenuBar(String name) {
        super(name);

        _menus = new ArrayList<PEOMenu>();

        SceneObjectDrawBack db = GetDrawBack();
        db.GetBackColorInfo().SetColor(255, 255, 255);
        db.SetEnableBorder(false);
    }

    public void AddMenu(PEOMenu menu) {
        if (menu == null) return;
        if (_menus.contains(menu)) return;
        _menus.add(menu);
    }

    public void Start() {
        // 自身の他の振る舞いに処理が行き渡るようにする
        super.Start();

        if (_isStart) return;
        _isStart = true;

        if (_menus == null) return;
        PEOMenu p;
        SceneObjectTransform tr;
        SceneObjectText t;
        float x, sum = 0;

        for (int i=0; i<_menus.size(); i++) {
            p = _menus.get(i);
            t = p.GetText();
            textFont(fontManager.GetFont(t.GetUsingFontName()));
            textSize(t.GetFontSize());
            textAlign(t.GetHorizontalAlign(), t. GetVerticalAlign());
            textLeading(t.GetLineSpace());

            x = textWidth(t.GetText()) + 20;
            tr = p.GetTransform();
            tr.SetParent(GetTransform(), true);
            tr.SetSize(x, 0);
            tr.GetAnchor().SetMin(0, 0);
            tr.GetAnchor().SetMax(0, 1);
            tr.GetPivot().SetPivot(0, 0.5);
            tr.SetTranslation(sum, 0);
            sum += x;
        }
    }
}
public class PEOSceneBase extends Scene {
    public PEOSceneBase(String name, String titleText) {
        super(name);
        
        textFont(fontManager.GetFont("FFScala"));
        textSize(12);
        textAlign(CENTER, CENTER);
        float x = textWidth(titleText) + 20;
        float xMergin = PEOConst.SLIDE_SPACE + PEOConst.TITLE_MERGIN_WIDTH;
        
        SceneObject title;
        
        _SetHeaderObject("Title L", "Title_L.png", 0, 0, PEOConst.SLIDE_SPACE, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        _SetHeaderObject("Title R", "Title_R.png", 0, 0, xMergin + x, 0, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.TITLE_HEIGHT);
        title = _SetHeaderObject("Title C", "Title_C.png", 0, 0, xMergin, 0, x, PEOConst.TITLE_HEIGHT);
        
        SceneObjectText _text = new SceneObjectText(title, titleText);
        _text.SetFontSize(12);
        _text.SetUsingFontName("FFScala");
        _text.SetAlign(CENTER, BASELINE);
        _text.GetColorInfo().SetColor(0, 0, 0);
        
        _SetHeaderObject("Header L", "Header_L.png", 0, 0, PEOConst.SLIDE_SPACE, PEOConst.TITLE_HEIGHT, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.HEADER_HEIGHT);
        _SetHeaderObject("Header R", "Header_R.png", 1, 0, -PEOConst.SLIDE_SPACE, PEOConst.TITLE_HEIGHT, PEOConst.TITLE_MERGIN_WIDTH, PEOConst.HEADER_HEIGHT);
        title = _SetHeaderObject("Header C", "Header_C.png", 0, 0, 0, PEOConst.TITLE_HEIGHT, 0, PEOConst.HEADER_HEIGHT);
        SceneObjectTransform t = title.GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(1, 0);
        t.GetPivot().SetPivot(0.5, 0);
        t.SetOffsetMin(PEOConst.TITLE_MERGIN_WIDTH, 0);
        t.SetOffsetMax(-PEOConst.TITLE_MERGIN_WIDTH, 0);
    }
    
    private SceneObject _SetHeaderObject(String name, String imagePath, float aX, float aY, float x, float y, float w, float h) {
        SceneObject o = new SceneObject(name);
        o.GetTransform().InitTransform(aX, aY, aX, aY, aX, aY, x, y, 1, 1, 0, w, h);
        o.GetDrawBack().SetEnable(false);
        AddObject(o);
        AddChild(o);
        new SceneObjectImage(o, PEOConst.EDITOR_GENERAL_PATH + imagePath);
        return o;
    }
    
    protected void _SetDragHandler(SceneObject o, IEvent dragEvent) {
        if (o == null) return;
        SceneObjectDragHandler dh = new SceneObjectDragHandler(GetName() + o.GetName() + " DragHandler Label");
        o.AddBehavior(dh);

        dh.GetEnabledActiveHandler().SetEvent("mouse entered", new IEvent() {
            public void Event() {
                cursor(MOVE);
            }
        }
        );
        dh.GetDisabledActiveHandler().SetEvent("mouse exited", new IEvent() {
            public void Event() {
                cursor(ARROW);
            }
        }
        );
        dh.GetDraggedActionHandler().SetEvent("mouse dragged", dragEvent);
    }
}
public class PEOSceneExplain extends Scene {
    public PEOSceneExplain() {
        super("Explain");
        
        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.SetSize(0, PEOConst.MENU_BAR_HEIGHT);
        t.GetAnchor().SetMin(0, 1);
        t.GetAnchor().SetMax(1, 1);
        t.GetPivot().SetPivot(0.5, 1);
    }
}
/**
 ヒエラルキーの基底クラス。
 */
public class PEOSceneHeararchyBase extends PEOSceneBase {
    public PEOSceneHeararchyBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;

        slider = new SceneObject("View to Hierarchy Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 0, 0, 1, 0, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );
        
        slider = new SceneObject("Hierarchy to Inspector Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(1, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnHtoI(mouseX + dx);
            }
        }
        );
        
        SceneObject back = new SceneObject("BackGroung");
        back.GetDrawBack().GetBackColorInfo().SetColor(194, 194, 194);
        back.GetDrawBack().GetBorderColorInfo().SetColor(130, 130, 130);
        AddObject(back);
        AddChild(back);
        t = back.GetTransform();
        t.InitTransform(0, 0, 1, 1, 0.5, 0.5, 0, 0, 1, 1, 0, 0, 0);
        t.SetOffsetMin(PEOConst.SLIDE_SPACE+1, PEOConst.TITLE_HEIGHT+PEOConst.HEADER_HEIGHT);
        t.SetOffsetMax(-PEOConst.SLIDE_SPACE-1, -PEOConst.SLIDE_SPACE-3);
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float v2h, h2i, h;
        h = PEOConst.BAR_HEIGHT;
        v2h = peoScenePositionManager.GetVtoH();
        h2i = peoScenePositionManager.GetHtoI();
        
        GetTransform().SetTranslation(v2h, h);
        GetTransform().SetSize(h2i - v2h, height - h - PEOConst.EXPLAIN_BAR_HEIGHT);
    }
}
/**
 インスペクターの基底クラス。
 */
public class PEOSceneInspectorBase extends PEOSceneBase {
    public PEOSceneInspectorBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;
        
        slider = new SceneObject("Hierarchy to Inspector Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 0, 0, 1, 0, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnHtoI(mouseX + dx);
            }
        }
        );
        
        SceneObject back = new SceneObject("BackGroung");
        back.GetDrawBack().GetBackColorInfo().SetColor(194, 194, 194);
        back.GetDrawBack().GetBorderColorInfo().SetColor(130, 130, 130);
        AddObject(back);
        AddChild(back);
        t = back.GetTransform();
        t.InitTransform(0, 0, 1, 1, 0.5, 0.5, 0, 0, 1, 1, 0, 0, 0);
        t.SetOffsetMin(PEOConst.SLIDE_SPACE+1, PEOConst.TITLE_HEIGHT+PEOConst.HEADER_HEIGHT);
        t.SetOffsetMax(-PEOConst.SLIDE_SPACE-1, -PEOConst.SLIDE_SPACE-3);
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float h2i, h;
        h = PEOConst.BAR_HEIGHT;
        h2i = peoScenePositionManager.GetHtoI();
        
        GetTransform().SetTranslation(h2i, h);
        GetTransform().SetSize(width - h2i, height - h - PEOConst.EXPLAIN_BAR_HEIGHT);
    }
}
public class PEOSceneMenuBar extends Scene {
    public PEOSceneMenuBar() {
        super("Menu Bar");

        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 0);
        SceneObjectTransform t = GetTransform();
        t.SetSize(width, PEOConst.MENU_BAR_HEIGHT);
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(1, 0);
        t.GetPivot().SetPivot(0.5, 0);

        PEOMenuBar menuBarObj = new PEOMenuBar("Menu Bar");
        AddObject(menuBarObj);
        AddChild(menuBarObj);

        PEOMenu menuObj;
        menuObj = new PEOMenu("File Menu", "File");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Edit Menu", "Edit");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("GameObject Menu", "GameObject");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Behavior Menu", "Behavior");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
        
        menuObj = new PEOMenu("Window Menu", "Window");
        AddObject(menuObj);
        menuBarObj.AddMenu(menuObj);
    }
}
public class PEOSceneOperationBar extends Scene {

    public PEOSceneOperationBar() {
        super("Operation Bar");

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);

        float selfH, menuH;
        selfH = PEOConst.OPERATION_BAR_HEIGHT;
        menuH = PEOConst.MENU_BAR_HEIGHT;
        GetTransform().InitTransform(0, 0, 1, 0, 0.5, 0, 0, menuH, 1, 1, 0, width, selfH);

        SceneObject opeObj;

        String[] paths = new String[]{
            "Hand", 
            "Translate", 
            "Rotate", 
            "Scale", 
            "Pivot", 
            "Play"
        };

        float x = 10;
        String basePath;
        for (int i=0; i<paths.length; i++, x+=32) {
            basePath = PEOConst.OPERATION_BAR_PATH + paths[i];

            opeObj = new SceneObject(paths[i]+" Ope");
            opeObj.GetDrawBack().SetEnable(false);
            AddObject(opeObj);
            AddChild(opeObj);
            if (i < paths.length - 1) {
                opeObj.GetTransform().InitTransform(0, 0.5, 0, 0.5, 0, 0.5, x, 0, 1, 1, 0, 32, 22);
            } else {
                opeObj.GetTransform().InitTransform(0.5, 0.5, 0.5, 0.5, 0, 0.5, 0, 0, 1, 1, 0, 32, 22);
            }
            new SceneObjectImage(opeObj, basePath +"_Off.png");
            new SceneObjectToggleButton(opeObj, opeObj.GetName() + " OperationBar Label", basePath +"_On.png", basePath +"_Off.png");
        }
    }
}
/**
 開発エンジン専用。
 */
public final class PEOScenePositionManager {
    private float _viewToHierarchy;
    public float GetVtoH() {
        return _viewToHierarchy;
    }

    private float _viewToProject;
    public float GetVtoP() {
        return _viewToProject;
    }

    private float _hierarchyToInspector;
    public float GetHtoI() {
        return _hierarchyToInspector;
    }

    public PEOScenePositionManager() {
        _viewToHierarchy = 0.6 * width;
        _viewToProject = 0.7 * height;
        _hierarchyToInspector = 0.8 * width;
    }

    /**
     ViewとHierarchyの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnVtoH(float pos) {
        if (_viewToHierarchy > pos) {
            if (PEOConst.MIN_VIEW_WIDTH <= pos) {
                _viewToHierarchy = pos;
                return true;
            }
            return false;
        } else {
            if (_hierarchyToInspector - pos >= PEOConst.MIN_HIERARCHY_WIDTH) {
                _viewToHierarchy = pos;
                return true;
            } else {
                // インスペクタも巻き込む場合
                if (SlideOnHtoI(pos + PEOConst.MIN_HIERARCHY_WIDTH)) {
                    _viewToHierarchy = pos;
                    return true;
                }
                return false;
            }
        }
    }

    /**
     HierarchyとInspectorの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnHtoI(float pos) {
        if (_hierarchyToInspector > pos) {
            if (pos - _viewToHierarchy >= PEOConst.MIN_HIERARCHY_WIDTH) {
                _hierarchyToInspector = pos;
                return true;
            } else {
                // ビューも巻き込む場合
                if (SlideOnVtoH(pos - PEOConst.MIN_HIERARCHY_WIDTH)) {
                    _hierarchyToInspector = pos;
                    return true;
                }
                return false;
            }
        } else {
            if (width - pos >= PEOConst.MIN_INSPECTOR_WIDTH) {
                _hierarchyToInspector = pos;
                return true;
            }
            return false;
        }
    }

    /**
     ViewとProjectの間を設定する。
     それ以上サイズを変えられない場合はfalse、サイズを変えた場合はtrueを返す。
     */
    public boolean SlideOnVtoP(float pos) {
        if (_viewToProject > pos) {
            if (PEOConst.BAR_HEIGHT + PEOConst.MIN_VIEW_HEIGHT <= pos) {
                _viewToProject = pos;
                return true;
            }
            return false;
        } else {
            if (height - PEOConst.EXPLAIN_BAR_HEIGHT - pos >= PEOConst.MIN_PROJECT_HEIGHT) {
                _viewToProject = pos;
                return true;
            }
            return false;
        }
    }
}
/**
 プロジェクトビューの基底クラス。
 */
public class PEOSceneProjectBase extends PEOSceneBase {
    public PEOSceneProjectBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        t.GetAnchor().SetMin(0, 1);
        t.GetAnchor().SetMax(0, 1);
        t.GetPivot().SetPivot(0, 1);
        t.SetTranslation(0, -PEOConst.EXPLAIN_BAR_HEIGHT);

        SceneObject slider;

        slider = new SceneObject("Project to Hierarchy Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(1, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );
        
        slider = new SceneObject("View to Project Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 0, 1, 0, 0.5, 0, 0, 0, 1, 1, 0, 0, PEOConst.SLIDE_SPACE);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dy = mouseY - pmouseY;
                peoScenePositionManager.SlideOnVtoP(mouseY + dy);
            }
        }
        );
        
        SceneObject back = new SceneObject("BackGroung");
        back.GetDrawBack().GetBackColorInfo().SetColor(194, 194, 194);
        back.GetDrawBack().GetBorderColorInfo().SetColor(130, 130, 130);
        AddObject(back);
        AddChild(back);
        t = back.GetTransform();
        t.InitTransform(0, 0, 1, 1, 0.5, 0.5, 0, 0, 1, 1, 0, 0, 0);
        t.SetOffsetMin(PEOConst.SLIDE_SPACE+1, PEOConst.TITLE_HEIGHT+PEOConst.HEADER_HEIGHT);
        t.SetOffsetMax(-PEOConst.SLIDE_SPACE-1, -PEOConst.SLIDE_SPACE-3);
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float v2h, v2p;
        v2h = peoScenePositionManager.GetVtoH();
        v2p = peoScenePositionManager.GetVtoP();
        
        GetTransform().SetSize(v2h, height - v2p - PEOConst.EXPLAIN_BAR_HEIGHT);
    }
}
/**
 メインビューの基底クラス。
 */
public class PEOSceneViewBase extends PEOSceneBase {
    public PEOSceneViewBase(String name, String title) {
        super(name, title);

        GetDrawBack().GetBackColorInfo().SetColor(162, 162, 162);
        SceneObjectTransform t = GetTransform();
        float h = PEOConst.BAR_HEIGHT;
        t.SetTranslation(0, h);
        t.GetAnchor().SetMin(0, 0);
        t.GetAnchor().SetMax(0, 0);
        t.GetPivot().SetPivot(0, 0);

        SceneObject slider;

        slider = new SceneObject("View to Hierarchy Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(1, 0, 1, 1, 1, 0.5, 0, 0, 1, 1, 0, PEOConst.SLIDE_SPACE, 0);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dx = mouseX - pmouseX;
                peoScenePositionManager.SlideOnVtoH(mouseX + dx);
            }
        }
        );

        slider = new SceneObject("View to Project Slider");
        slider.GetDrawBack().SetEnable(false);
        AddObject(slider);
        AddChild(slider);

        slider.GetTransform().InitTransform(0, 1, 1, 1, 0.5, 1, 0, 0, 1, 1, 0, 0, PEOConst.SLIDE_SPACE);
        _SetDragHandler(slider, new IEvent() {
            public void Event() {
                float dy = mouseY - pmouseY;
                peoScenePositionManager.SlideOnVtoP(mouseY + dy);
            }
        }
        );

        SceneObject back = new SceneObject("BackGroung");
        back.GetDrawBack().GetBackColorInfo().SetColor(70, 70, 70);
        back.GetDrawBack().GetBorderColorInfo().SetColor(50, 50, 50);
        AddObject(back);
        AddChild(back);
        t = back.GetTransform();
        t.InitTransform(0, 0, 1, 1, 0.5, 0.5, 0, 0, 1, 1, 0, 0, 0);
        t.SetOffsetMin(PEOConst.SLIDE_SPACE+1, PEOConst.TITLE_HEIGHT+PEOConst.HEADER_HEIGHT);
        t.SetOffsetMax(-PEOConst.SLIDE_SPACE-1, -PEOConst.SLIDE_SPACE-3);
    }

    /**
     アップデートの段階でサイズを取得して調整する。
     */
    protected void _OnUpdate() {
        super._OnUpdate();

        float v2h, v2p, h;
        h = PEOConst.BAR_HEIGHT;
        v2h = peoScenePositionManager.GetVtoH();
        v2p = peoScenePositionManager.GetVtoP();

        GetTransform().SetSize(v2h, v2p - h);
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
        CheckMouseActiveObject();
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
public class SceneManager {
    /**
     保持しているシーン。
     */
    private HashMap<String, Scene> _scenes;

    /**
     実際に描画するシーンのリスト。
     シーンの優先度によって描画順が替わる。
     */
    private ArrayList<Scene> _drawScenes;

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

    private IEvent _sceneOverWriteOptionEvent;
    public IEvent GetSceneOverWriteOptionEvent() {
        return _sceneOverWriteOptionEvent;
    }
    public void SetSceneOverWriteOptionEvent(IEvent value) {
        _sceneOverWriteOptionEvent = value;
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
            if (i > 0 && _sceneOverWriteOptionEvent != null) {
                _sceneOverWriteOptionEvent.Event();
            }
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

    /**
     アクティブオブジェクトの時、trueを返す。
     */
    private boolean _isActiveObject;
    public boolean IsActiveObject() {
        return _isActiveObject;
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
public class SceneObjectBehavior {
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
    public int GetID() {
        return ClassID.CID_BUTTON;
    }

    private boolean _isActive;
    private String _eventLabel;

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

        _eventLabel = eventLabel;
        _decideHandler = new ActionEvent();
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
        inputManager.GetMouseReleasedHandler().AddEvent(_eventLabel, new IEvent() {
            public void Event() {
                if (!_isActive) return;
                GetDecideHandler().InvokeAllEvents();
            }
        }
        );
    }
}
public class SceneObjectDragHandler extends SceneObjectBehavior {
    public int GetID() {
        return ClassID.CID_DRAG_HANDLER;
    }

    private boolean _isActive, _isDragging;
    private String _eventLabel;

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
        inputManager.GetMouseDraggedHandler().AddEvent(_eventLabel, new IEvent() {
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
            }
        }
        if (inputManager.IsMouseUp()) {
            _isDragging = false;
        }
    }
}
public class SceneObjectDrawBack extends SceneObjectBehavior { //<>// //<>//
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

    private PVector _objSize;

    public SceneObjectImage() {
        super();
    }

    public SceneObjectImage(String imagePath) {
        super();
        SetUsingImageName(imagePath);
    }
    
    public SceneObjectImage(SceneObject o, String imagePath) {
        super();
        SetUsingImageName(imagePath);
        if (o == null) return;
        o.AddBehavior(this);
    }

    public void Start() {
        super.Start();
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

        GetDecideHandler().AddEvent("Toggle", new IEvent() {
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
}
public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> { //<>//
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
            if (GetScene() == null) return;
            GetScene().SetNeedSorting(true);
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
}
/** //<>// //<>//
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
