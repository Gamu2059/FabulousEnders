import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.lang.reflect.*; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FabulousEnders extends PApplet {





// \u30de\u30cd\u30fc\u30b8\u30e3\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9
InputManager inputManager;
SceneManager sceneManager;
MatrixManager matrixManager;
ImageManager imageManager;
FontManager fontManager;

Scene scene;
SceneObjectTransform objT1, objT2;
float x;
boolean isRotate;
public void setup() {
    
    try {
        InitManager();

        scene = new Scene("main");
        scene.GetTransform().SetPosition(width * 0.5f, 0);
        scene.SetSceneScale(0.5f, 1);
        scene.GetDrawBack().GetBackColorInfo().SetColor(100, 0, 100);

        SceneObject o = new SceneObject("camera?", scene);
        SetText(o);
        objT1 = o.GetTransform();
        objT1.SetSize(100, 100);
        objT1.SetParentAnchor(Anchor.CENTER_MIDDLE);
        objT1.SetSelfAnchor(Anchor.CENTER_MIDDLE);

        SceneObject o1 = new SceneObject("Overlapped", scene);
        o1.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        //SetImage(o1);
        SetButton(o1);
        objT2 = o1.GetTransform();
        objT2.SetParent(o.GetTransform(), true);
        objT2.SetSize(100, 140);
        objT2.SetParentAnchor(Anchor.CENTER_MIDDLE);

        sceneManager.Start("main");
    } 
    catch(Exception e) {
        println(e);
    }
}

public void SetImage(SceneObject o) {
    SceneObjectImage i = new SceneObjectImage(o);
    i.SetUsingImageName("icon.png");
}

public void SetText(SceneObject o) {
    SceneObjectText t = new SceneObjectText(o, "TestTestTestTestTestTestTestTest");
    t.SetDrawInOrder(true);
    t.SetDrawSpeed(10);
    t.GetColorInfo().SetColor(0, 0, 200);
}

public void SetButton(SceneObject o) {
    SceneObjectButton b = new SceneObjectButton(o);
    b.GetDicideHandler().AddEvent("pushed", new Event() {
        public void Event() {
            OnDecide();
        }
    }
    );
}

public void OnDecide() {
    isRotate = !isRotate;
}

public void draw() {
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
 \u7528\u610f\u3055\u308c\u305f\u30de\u30cd\u30fc\u30b8\u30e3\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u81ea\u52d5\u7684\u306b\u751f\u6210\u3059\u308b\u3002
 */
public void InitManager() {
    try {
        Field[] fields = getClass().getDeclaredFields();
        Field f;
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

public void keyPressed() {
    inputManager.KeyPressed();
}

public void keyReleased() {
    inputManager.KeyReleased();
}

public void mousePressed() {
    inputManager.MousePressed();
}

public void mouseReleased() {
    inputManager.MouseReleased();
}

public void mouseClicked() {
    inputManager.MouseClicked();
}

public void mouseWheel() {
    inputManager.MouseWheel();
}

public void mouseMoved() {
    inputManager.MouseMoved();
}

public void mouseDragged() {
    inputManager.MouseDragged();
}

public void mouseEntered() {
    inputManager.MouseEntered();
}

public void mouseExited() {
    inputManager.MouseExited();
}
public abstract class Abs_SceneObjectDrawBase extends Abs_SceneObjectBehavior {
    private DrawColor _colorInfo;
    public DrawColor GetColorInfo() {
        return _colorInfo;
    }

    public Abs_SceneObjectDrawBase(SceneObject obj) {
        super(obj);

        _colorInfo = new DrawColor();
    }
}
/**
 IEvent\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u3092HashMap\u3067\u7ba1\u7406\u3059\u308b\u3053\u3068\u306b\u8cac\u4efb\u3092\u6301\u3064\u3002
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
 \u5e73\u9762\u4e0a\u306e\u3042\u308b\u9818\u57df\u306e\u57fa\u6e96\u70b9\u3092\u4e8c\u3064\u4fdd\u6301\u3059\u308b\u8cac\u4efb\u3092\u6301\u3064\u3002
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
ObjectBehavior\u53ca\u3073\u30b5\u30d6\u30af\u30e9\u30b9\u3092\u7279\u5b9a\u3059\u308b\u305f\u3081\u306eID\u3092\u5b9a\u7fa9\u3059\u308b\u8cac\u4efb\u3092\u6301\u3064\u3002
*/
public final class ClassID {
    public static final int BEHAVIOR = 0;
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
     \u30ab\u30e9\u30fc\u30e2\u30fc\u30c9\u3092\u8a2d\u5b9a\u3059\u308b\u3002
     true\u306e\u5834\u5408\u306fRGB\u8868\u73fe\u3001false\u306e\u5834\u5408\u306fHSB\u8868\u73fe\u306b\u3059\u308b\u3002
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
     \u30e2\u30fc\u30c9\u306b\u3088\u308a\u8fd4\u3063\u3066\u304f\u308b\u5024\u304c\u7570\u306a\u308b\u53ef\u80fd\u6027\u304c\u3042\u308a\u307e\u3059\u3002
     */
    public int GetColor() {
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
public final class FontManager extends Abs_Manager {
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
     \u6307\u5b9a\u3057\u305f\u5ea7\u6a19\u540c\u58eb\u306e\u30e9\u30b8\u30a2\u30f3\u89d2\u3092\u8fd4\u3059\u3002
     \u5ea7\u6a192\u304b\u3089\u5ea7\u6a191\u306b\u5411\u3051\u3066\u306e\u89d2\u5ea6\u306b\u306a\u308b\u306e\u3067\u6ce8\u610f\u3002
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

    /**
     \u914d\u5217\u306e\u30bd\u30fc\u30c8\u3092\u884c\u3046\u3002
     \u305f\u3060\u3057\u3001\u683c\u7d0d\u3055\u308c\u3066\u3044\u308b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u304cComparable\u30a4\u30f3\u30bf\u30d5\u30a7\u30fc\u30b9\u3092\u5b9f\u88c5\u3057\u3066\u3044\u308b\u3053\u3068\u3092\u524d\u63d0\u3068\u3059\u308b\u3002
     */
    public static void Sort(Comparable[] o) {
        if (o == null) return;
        _QuickSort(o, 0, o.length-1);
    }

    /**
     \u30ea\u30b9\u30c8\u306e\u30bd\u30fc\u30c8\u3092\u884c\u3046\u3002
     \u305f\u3060\u3057\u3001\u683c\u7d0d\u3055\u308c\u3066\u3044\u308b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u304cComparable\u30a4\u30f3\u30bf\u30d5\u30a7\u30fc\u30b9\u3092\u5b9f\u88c5\u3057\u3066\u3044\u308b\u3053\u3068\u3092\u524d\u63d0\u3068\u3059\u308b\u3002
     */
    public static void Sort(ArrayList<Comparable> o) {
        if (o == null) return;
        _QuickSort(o, 0, o.size()-1);
    }

    /**
     \u8ef8\u8981\u7d20\u306e\u9078\u629e
     \u9806\u306b\u898b\u3066\u3001\u6700\u521d\u306b\u898b\u3064\u304b\u3063\u305f\u7570\u306a\u308b2\u3064\u306e\u8981\u7d20\u306e\u3046\u3061\u3001
     \u5927\u304d\u3044\u307b\u3046\u306e\u756a\u53f7\u3092\u8fd4\u3057\u307e\u3059\u3002
     \u5168\u90e8\u540c\u3058\u8981\u7d20\u306e\u5834\u5408\u306f -1 \u3092\u8fd4\u3057\u307e\u3059\u3002
     */
    private static int _Pivot(Comparable[] o, int i, int j) {
        int k = i+1;
        while (k <= j && o[i].compareTo(o[k]) == 0) k++;
        if (k > j) return -1;
        if (o[i].compareTo(o[k]) >= 0) return i;
        return k;
    }

    private static int _Pivot(ArrayList<Comparable> o, int i, int j) {
        int k = i+1;
        while (k <= j && o.get(i).compareTo(o.get(k)) == 0) k++;
        if (k > j) return -1;
        if (o.get(i).compareTo(o.get(k)) >= 0) return i;
        return k;
    }

    /**
     \u30af\u30a4\u30c3\u30af\u30bd\u30fc\u30c8
     \u914d\u5217o\u306e\u3001o[i]\u304b\u3089o[j]\u3092\u4e26\u3079\u66ff\u3048\u307e\u3059\u3002
     */
    private static void _QuickSort(Comparable[] o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o[p]);
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    private static void _QuickSort(ArrayList<Comparable> o, int i, int j) {
        if (i == j) return;
        int p = _Pivot(o, i, j);
        if (p != -1) {
            int k = _Partition(o, i, j, o.get(p));
            _QuickSort(o, i, k-1);
            _QuickSort(o, k, j);
        }
    }

    /**
     \u30d1\u30fc\u30c6\u30a3\u30b7\u30e7\u30f3\u5206\u5272
     o[i]\uff5eo[j]\u306e\u9593\u3067\u3001x \u3092\u8ef8\u3068\u3057\u3066\u5206\u5272\u3057\u307e\u3059\u3002
     x \u3088\u308a\u5c0f\u3055\u3044\u8981\u7d20\u306f\u524d\u306b\u3001\u5927\u304d\u3044\u8981\u7d20\u306f\u3046\u3057\u308d\u306b\u6765\u307e\u3059\u3002
     \u5927\u304d\u3044\u8981\u7d20\u306e\u958b\u59cb\u756a\u53f7\u3092\u8fd4\u3057\u307e\u3059\u3002
     */
    private static int _Partition(Comparable[] o, int i, int j, Comparable x) {
        int l=i, r=j;
        // \u691c\u7d22\u304c\u4ea4\u5dee\u3059\u308b\u307e\u3067\u7e70\u308a\u8fd4\u3057\u307e\u3059
        while (l<=r) {
            // \u8ef8\u8981\u7d20\u4ee5\u4e0a\u306e\u30c7\u30fc\u30bf\u3092\u63a2\u3057\u307e\u3059
            while (l<=j && o[l].compareTo(x) < 0)  l++;
            // \u8ef8\u8981\u7d20\u672a\u6e80\u306e\u30c7\u30fc\u30bf\u3092\u63a2\u3057\u307e\u3059
            while (r>=i && o[r].compareTo(x) >= 0) r--;
            if (l>r) break;
            Comparable t=o[l];
            o[l]=o[r];
            o[r]=t;
            l++; 
            r--;
        }
        return l;
    }

    private static int _Partition(ArrayList<Comparable> o, int i, int j, Comparable x) {
        int l=i, r=j;
        while (l<=r) {
            while (l<=j && o.get(l).compareTo(x) < 0)  l++;
            while (r>=i && o.get(r).compareTo(x) >= 0) r--;
            if (l>r) break;
            Comparable t=o.get(l);
            o.set(l, o.get(r));
            o.set(r, t);
            l++; 
            r--;
        }
        return l;
    }
}
public final static class GeneralJudge {
    /**
    \u6307\u5b9a\u3057\u305f\u30af\u30e9\u30b9\u304c\u6307\u5b9a\u3057\u305f\u30a4\u30f3\u30bf\u30fc\u30d5\u30a7\u30fc\u30b9\u3092\u5b9f\u88c5\u3057\u3066\u3044\u308b\u304b\u3069\u3046\u304b\u3002
    */
    public static boolean IsImplemented(Class<?> clazz, Class<?> intrfc) {
        if (clazz == null || intrfc == null) {
            return false;
        }
        // \u30a4\u30f3\u30bf\u30fc\u30d5\u30a7\u30fc\u30b9\u3092\u5b9f\u88c5\u3057\u305f\u30af\u30e9\u30b9\u3067\u3042\u308b\u304b\u3069\u3046\u304b\u3092\u30c1\u30a7\u30c3\u30af
        if (!clazz.isInterface() && intrfc.isAssignableFrom(clazz)
                && !Modifier.isAbstract(clazz.getModifiers())) {
            return true;
        }
        return false;
    }
}
public interface IEvent {
    public void Event();
}
public final class ImageManager extends Abs_Manager {
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
public final class InputManager extends Abs_Manager {
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
     \u30de\u30a6\u30b9\u64cd\u4f5c\u3092\u4f55\u304b\u3057\u3089\u884c\u3063\u305f\u5834\u5408\u3001true\u306b\u306a\u308b\u3002
     \u30ad\u30fc\u64cd\u4f5c\u3092\u4f55\u304b\u3057\u3089\u884c\u3063\u305f\u5834\u5408\u3001false\u306b\u306a\u308b\u3002
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

        // \u30af\u30ea\u30c3\u30af\u3055\u308c\u305f\u30ad\u30fc\u306e\u5224\u5b9a\u306f\u540c\u30d5\u30ec\u30fc\u30e0\u3067\u6d88\u6ec5\u3055\u305b\u308b
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
     \u3053\u308c\u3092\u547c\u3073\u51fa\u3057\u305f\u6642\u70b9\u3067\u62bc\u3055\u308c\u3066\u3044\u308b\u6700\u5f8c\u306e\u30ad\u30fc\u306e\u30ad\u30fc\u30b3\u30fc\u30c9\u3092Key\u5217\u6319\u5b9a\u6570\u306b\u5909\u63db\u3057\u3066\u8fd4\u3059\u3002
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
                // \u6570\u5b57
                return Key._0 + k - Key.KEYCODE_0;
            } else if (k >= Key.KEYCODE_A && k < Key.KEYCODE_A + 26) {
                // \u30a2\u30eb\u30d5\u30a1\u30d9\u30c3\u30c8
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306e\u30ad\u30fc\u304c\u62bc\u3055\u308c\u3066\u3044\u308b\u72b6\u614b\u306a\u3089true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u901a\u5e38\u306e\u5224\u5b9a\u51e6\u7406\u3088\u308a\u3082\u9ad8\u901f\u3067\u3042\u308b\u3002
     */
    public boolean IsPressedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetPressedKeys()[input];
    }

    /**
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306e\u30ad\u30fc\u3060\u3051\u304c\u62bc\u3055\u308c\u3066\u3044\u308b\u72b6\u614b\u306a\u3089true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u901a\u5e38\u306e\u5224\u5b9a\u51e6\u7406\u3088\u308a\u3082\u9ad8\u901f\u3067\u3042\u308b\u3002
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306e\u30ad\u30fc\u304c\u30af\u30ea\u30c3\u30af\u3055\u308c\u305f\u72b6\u614b\u306a\u3089true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u901a\u5e38\u306e\u5224\u5b9a\u51e6\u7406\u3088\u308a\u3082\u9ad8\u901f\u3067\u3042\u308b\u3002
     */
    public boolean IsClickedKey(int input) {
        if (_CheckOutOfKeyBounds(input)) {
            return false;
        }
        return GetClickedKeys()[input];
    }

    /**
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306e\u30ad\u30fc\u3060\u3051\u304c\u30af\u30ea\u30c3\u30af\u3055\u308c\u305f\u72b6\u614b\u306a\u3089true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u901a\u5e38\u306e\u5224\u5b9a\u51e6\u7406\u3088\u308a\u3082\u9ad8\u901f\u3067\u3042\u308b\u3002
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306b\u5bfe\u3057\u3066\u3001\u5168\u3066\u306e\u30ad\u30fc\u304c\u62bc\u3055\u308c\u3066\u3044\u308b\u72b6\u614b\u306a\u3089\u3070true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u5f15\u6570\u304c\u5217\u6319\u5b9a\u6570\u306e\u7bc4\u56f2\u5916\u306e\u5834\u5408\u306f\u3001\u5fc5\u305afalse\u304c\u8fd4\u3055\u308c\u308b\u3002
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306b\u5bfe\u3057\u3066\u3001\u305d\u306e\u5217\u6319\u3055\u308c\u305f\u3082\u306e\u3060\u3051\u304c\u62bc\u3055\u308c\u3066\u3044\u308b\u72b6\u614b\u306a\u3089\u3070true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u5f15\u6570\u304c\u5217\u6319\u5b9a\u6570\u306e\u7bc4\u56f2\u5916\u306e\u5834\u5408\u306f\u3001\u5fc5\u305afalse\u304c\u8fd4\u3055\u308c\u308b\u3002
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306b\u5bfe\u3057\u3066\u3001\u5168\u3066\u306e\u30ad\u30fc\u304c\u30af\u30ea\u30c3\u30af\u3055\u308c\u305f\u72b6\u614b\u306a\u3089\u3070true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u5f15\u6570\u304c\u5217\u6319\u5b9a\u6570\u306e\u7bc4\u56f2\u5916\u306e\u5834\u5408\u306f\u3001\u5fc5\u305afalse\u304c\u8fd4\u3055\u308c\u308b\u3002
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
     \u5f15\u6570\u3067\u4e0e\u3048\u3089\u308c\u305f\u5217\u6319\u5b9a\u6570\u306b\u5bfe\u3057\u3066\u3001\u305d\u306e\u5217\u6319\u3055\u308c\u305f\u3082\u306e\u3060\u3051\u304c\u30af\u30ea\u30c3\u30af\u3055\u308c\u305f\u72b6\u614b\u306a\u3089\u3070true\u3092\u3001\u305d\u3046\u3067\u306a\u3051\u308c\u3070false\u3092\u8fd4\u3059\u3002
     \u5f15\u6570\u304c\u5217\u6319\u5b9a\u6570\u306e\u7bc4\u56f2\u5916\u306e\u5834\u5408\u306f\u3001\u5fc5\u305afalse\u304c\u8fd4\u3055\u308c\u308b\u3002
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
    // \u4f7f\u7528\u3059\u308b\u30ad\u30fc\u306e\u7dcf\u6570
    public final static int KEY_NUM = 45;

    // \u30ad\u30fc\u30b3\u30fc\u30c9\u5b9a\u6570
    public final static int KEYCODE_0 = 48;
    public final static int KEYCODE_A = 65;

    // \u6570\u5b57
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

    // \u30a2\u30eb\u30d5\u30a1\u30d9\u30c3\u30c8
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

    // \u7279\u6b8a\u30ad\u30fc
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
public final class MatrixManager extends Abs_Manager {
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
}
/**
 \u5e73\u9762\u4e0a\u306e\u3042\u308b\u9818\u57df\u306e\u57fa\u6e96\u70b9\u3092\u4fdd\u6301\u3059\u308b\u8cac\u4efb\u3092\u6301\u3064\u3002
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
    public final static float P_CENTER = 0.5f;
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
public class Scene extends SceneObject {
    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    /**
     \u6b21\u306e\u30d5\u30ec\u30fc\u30e0\u304b\u3089\u30a2\u30af\u30c6\u30a3\u30d6\u306b\u306a\u308b\u5834\u5408\u306btrue\u306b\u306a\u308b\u3002
     */
    private boolean _enabledFlag;
    public final void SetEnabledFlag(boolean value) {
        _enabledFlag = value;
    }
    /**
     \u6b21\u306e\u30d5\u30ec\u30fc\u30e0\u304b\u3089\u30ce\u30f3\u30a2\u30af\u30c6\u30a3\u30d6\u306b\u306a\u308b\u5834\u5408\u306btrue\u306b\u306a\u308b\u3002
     */
    private boolean _disabledFlag;
    public final void SetDisabledFlag(boolean value) {
        _disabledFlag = value;
    }

    /**
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u512a\u5148\u5ea6\u5909\u66f4\u304c\u767a\u751f\u3057\u3066\u3044\u308b\u5834\u5408\u306ftrue\u306b\u306a\u308b\u3002
     \u3053\u308c\u304ctrue\u3067\u306a\u3051\u308c\u3070\u30bd\u30fc\u30c8\u306f\u3055\u308c\u306a\u3044\u3002
     */
    private boolean _isNeedSorting;
    public void SetNeedSorting(boolean value) {
        _isNeedSorting = value;
    }

    /**
     \u30b7\u30fc\u30f3\u306b\u306e\u307f\u7279\u5225\u306b\u30b9\u30b1\u30fc\u30eb\u5024\u3092\u4e0e\u3048\u308b\u3002
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
     \u30b7\u30fc\u30f3\u306e\u521d\u671f\u5316\u3092\u884c\u3046\u3002
     \u30b2\u30fc\u30e0\u958b\u59cb\u6642\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     */
    public void InitScene() {
        _isNeedSorting = true;
        _Sorting();
    }

    /**
     \u3000\u30a2\u30af\u30c6\u30a3\u30d6\u30b7\u30fc\u30f3\u306b\u306a\u308b\u76f4\u524d\u306e\u30d5\u30ec\u30fc\u30e0\u306e\u4e00\u756a\u6700\u5f8c\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     */
    public void Enabled() {
        _enabledFlag = false;
    }

    /**
     \u30ce\u30f3\u30a2\u30af\u30c6\u30a3\u30d6\u30b7\u30fc\u30f3\u306b\u306a\u308b\u76f4\u524d\u306e\u30d5\u30ec\u30fc\u30e0\u306e\u4e00\u756a\u6700\u5f8c\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     */
    public void Disabled() {
        _disabledFlag = false;
        _Stop();
    }


    /**
     \u6bce\u30d5\u30ec\u30fc\u30e0\u306e\u30b7\u30fc\u30f3\u66f4\u65b0\u51e6\u7406\u3002
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
     \u30d5\u30ec\u30fc\u30e0\u306e\u6700\u521d\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     _Stop\u3068\u7570\u306a\u308a\u3001\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3054\u3068\u306b\u30bf\u30a4\u30df\u30f3\u30b0\u304c\u7570\u306a\u308b\u306e\u3067\u30d5\u30ec\u30fc\u30e0\u6bce\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
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
     \u30d5\u30ec\u30fc\u30e0\u306e\u6700\u5f8c\u306b\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     \u4e00\u5ea6\u3057\u304b\u547c\u3073\u51fa\u3055\u308c\u306a\u3044\u3002
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u6709\u52b9\u30d5\u30e9\u30b0\u306b\u95a2\u308f\u3089\u305a\u5fc5\u305a\u547c\u3073\u51fa\u3059\u3002
     */
    protected void _Stop() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            s.Stop();
        }
    }

    /**
     \u6bce\u30d5\u30ec\u30fc\u30e0\u547c\u3073\u51fa\u3055\u308c\u308b\u3002
     \u5165\u529b\u5f85\u3061\u3084\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3\u51e6\u7406\u3092\u884c\u3046\u3002
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
     _Update\u3068\u306f\u7570\u306a\u308a\u3001AnimationBehavior\u306b\u3088\u308b\u9ad8\u5ea6\u306a\u30d5\u30ec\u30fc\u30e0\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3\u3092\u884c\u3046\u3002
     \u4e3b\u306b\u5b50\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3\u3084\u753b\u50cf\u9023\u756a\u8868\u793a\u3092\u51e6\u7406\u3059\u308b\u306e\u306b\u7528\u3044\u308b\u3002
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
     \u30a2\u30d5\u30a3\u30f3\u884c\u5217\u3092\u521d\u671f\u5316\u3059\u308b\u3002
     */
    protected void _ResetMatrix() {
        while (matrixManager.PopMatrix());
        resetMatrix();
    }

    /**
     \u30b7\u30fc\u30f3\u306e\u5e73\u884c\u79fb\u52d5\u3068\u56de\u8ee2\u3092\u884c\u3046\u3002
     */
    public void TransformScene() {
        PVector p = GetTransform().GetPosition();
        resetMatrix();
        scale(GetSceneScale().x, GetSceneScale().y);
        translate(p.x, p.y);
        rotate(GetTransform().GetRotate());
    }

    /**
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u79fb\u52d5\u3055\u305b\u308b\u3002
     \u3053\u3053\u307e\u3067\u306b\u6307\u793a\u3055\u308c\u305f\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u79fb\u52d5\u306f\u3001\u5168\u3066\u3053\u3053\u3067\u51e6\u7406\u3055\u308c\u308b\u3002
     \u305d\u308c\u4ee5\u964d\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u51e6\u7406\u306f\u7121\u8996\u3055\u308c\u308b\u3002
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
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u512a\u5148\u5ea6\u306b\u3088\u3063\u3066\u30bd\u30fc\u30c8\u3059\u308b\u3002
     \u6bce\u5ea6\u51e6\u7406\u3057\u3066\u3044\u308b\u3068\u91cd\u304f\u306a\u308b\u306e\u30d5\u30e9\u30b0\u304c\u7acb\u3063\u3066\u3044\u308b\u6642\u306e\u307f\u51e6\u7406\u3059\u308b\u3002
     */
    protected void _Sorting() {
        if (!_isNeedSorting) {
            return;
        }
        _isNeedSorting = false;
        Collections.sort(_objects);
    }

    /**
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306b\u5bfe\u3057\u3066\u30de\u30a6\u30b9\u30ab\u30fc\u30bd\u30eb\u304c\u3069\u306e\u3088\u3046\u306b\u91cd\u306a\u3063\u3066\u3044\u308b\u304b\u5224\u5b9a\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u30de\u30a6\u30b9\u64cd\u4f5c\u3057\u3066\u3044\u308b\u6642\u3060\u3051\u3057\u304b\u5224\u5b9a\u3057\u306a\u3044\u3002
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
                    // \u73fe\u5728\u306eMAO\u304c\u6b21\u306eMAO\u306b\u306a\u308b\u306a\u3089\u3070\u3001\u4f55\u3082\u305b\u305a\u306b\u51e6\u7406\u3092\u7d42\u308f\u308b\u3002
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
        // \u4f55\u3082\u30a2\u30af\u30c6\u30a3\u30d6\u306b\u306a\u3089\u306a\u3051\u308c\u3070\u30a2\u30af\u30c6\u30a3\u30d6\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3082\u7121\u52b9\u5316\u3059\u308b
        if (!f) {
            if (_activeObject != null) {
                _activeObject.OnDisabledActive();
            }
            _activeObject = null;
        }
    }

    /**
     \u30c9\u30ed\u30fc\u30d0\u30c3\u30af\u3068\u30a4\u30e1\u30fc\u30b8\u7cfb\u306e\u632f\u308b\u821e\u3044\u3092\u6301\u3064\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u63cf\u753b\u3092\u884c\u3046\u3002
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
     \u30b7\u30fc\u30f3\u80cc\u666f\u3092\u63cf\u753b\u3059\u308b\u3002
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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u8ffd\u52a0\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u65e2\u306b\u5b50\u3068\u3057\u3066\u8ffd\u52a0\u3055\u308c\u3066\u3044\u308b\u5834\u5408\u306f\u8ffd\u52a0\u3067\u304d\u306a\u3044\u3002
     
     @return \u8ffd\u52a0\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) {
            return false;
        }
        object.GetTransform().SetParent(GetTransform(), true);
        return _objects.add(object);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u8fd4\u3059\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u8fd4\u3059\u3002
     
     @return index\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public final SceneObject GetObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.get(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u8fd4\u3059\u3002
     
     @return name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u6307\u5b9a\u3057\u305f\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u304c\u5b58\u5728\u3059\u308c\u3070\u524a\u9664\u3059\u308b\u3002
     
     @return \u524a\u9664\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059\u3002
     */
    public final boolean RemoveObject(SceneObject object) {
        return _objects.remove(object);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u524a\u9664\u3059\u308b\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return index\u756a\u76ee\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public final SceneObject RemoveObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.remove(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089name\u3068\u4e00\u81f4\u3059\u308b\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
}
public final class SceneManager extends Abs_Manager {
    private ArrayList<Scene> _scenes;
    public ArrayList<Scene> GetScenes() {
        return _scenes;
    }

    /**
     \u73fe\u5728\u63cf\u753b\u3055\u308c\u3066\u3044\u308b\u30b7\u30fc\u30f3\u3002
     */
    private Scene _activeScene;
    public Scene GetActiveScene() {
        return _activeScene;
    }
    /**
     \u6b21\u306b\u30a2\u30af\u30c6\u30a3\u30d6\u306b\u306a\u308b\u30b7\u30fc\u30f3\u3002
     */
    private Scene _nextScene;

    /**
     \u30b7\u30fc\u30f3\u306e\u8aad\u8fbc\u8981\u6c42\u304c\u51fa\u3055\u308c\u305f\u5834\u5408\u306btrue\u306b\u306a\u308b\u3002
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
     \u30b2\u30fc\u30e0\u3092\u958b\u59cb\u3059\u308b\u305f\u3081\u306b\u4e00\u756a\u6700\u521d\u306b\u547c\u3073\u51fa\u3059\u51e6\u7406\u3002
     setup\u95a2\u6570\u306e\u4e00\u756a\u6700\u5f8c\u306b\u547c\u3073\u51fa\u3059\u5fc5\u8981\u304c\u3042\u308b\u3002
     */
    public void Start(String sceneName) {
        _InitScenes();
        LoadScene(sceneName);
        Update();
    }

    /**
     \u30b7\u30fc\u30f3\u3092\u8aad\u307f\u8fbc\u307f\u3001\u6b21\u306e\u30d5\u30ec\u30fc\u30e0\u304b\u3089\u30a2\u30af\u30c6\u30a3\u30d6\u306b\u3055\u305b\u308b\u3002
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
     \u30d5\u30ec\u30fc\u30e0\u66f4\u65b0\u3092\u884c\u3046\u3002
     \u30a2\u30af\u30c6\u30a3\u30d6\u30b7\u30fc\u30f3\u306e\u307f\u51e6\u7406\u3055\u308c\u308b\u3002
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
     \u30b7\u30fc\u30f3\u3092\u5207\u308a\u66ff\u3048\u308b\u3002
     \u30b7\u30fc\u30f3\u306e\u7d42\u4e86\u51e6\u7406\u3068\u958b\u59cb\u51e6\u7406\u3092\u547c\u3073\u51fa\u3059\u3002
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
     \u30b7\u30fc\u30f3\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u3092\u521d\u671f\u5316\u3059\u308b\u3002
     \u4e3b\u306b\u30b7\u30fc\u30f3\u5185\u306e\u30bd\u30fc\u30c6\u30a3\u30f3\u30b0\u306a\u3069\u3067\u3042\u308b\u3002
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
 SceneObjectBehaviorMouseReleased();
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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u30b7\u30fc\u30f3\u3092\u8ffd\u52a0\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u65e2\u306b\u5b50\u3068\u3057\u3066\u8ffd\u52a0\u3055\u308c\u3066\u3044\u308b\u5834\u5408\u306f\u8ffd\u52a0\u3067\u304d\u306a\u3044\u3002
     
     @return \u8ffd\u52a0\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059
     */
    public boolean AddScene(Scene scene) {
        if (GetScene(scene.GetName()) != null) {
            return false;
        }
        return _scenes.add(scene);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30b7\u30fc\u30f3\u3092\u8fd4\u3059\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30b7\u30fc\u30f3\u3092\u8fd4\u3059\u3002
     
     @return index\u756a\u76ee\u306e\u30b7\u30fc\u30f3 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public Scene GetScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.get(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30b7\u30fc\u30f3\u3092\u8fd4\u3059\u3002
     
     @return name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30b7\u30fc\u30f3 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u6307\u5b9a\u3057\u305f\u30b7\u30fc\u30f3\u304c\u5b58\u5728\u3059\u308c\u3070\u524a\u9664\u3059\u308b\u3002
     
     @return \u524a\u9664\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059\u3002
     */
    public boolean RemoveScene(Scene scene) {
        return _scenes.remove(scene);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30b7\u30fc\u30f3\u3092\u524a\u9664\u3059\u308b\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30b7\u30fc\u30f3\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return index\u756a\u76ee\u306e\u30b7\u30fc\u30f3 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public Scene RemoveScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.remove(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089name\u3068\u4e00\u81f4\u3059\u308b\u30b7\u30fc\u30f3\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return name\u3068\u4e00\u81f4\u3059\u308b\u540d\u524d\u306e\u30b7\u30fc\u30f3 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
     \u81ea\u5206\u4ee5\u5916\u306f\u5168\u3066false\u3092\u8fd4\u3059\u3002
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
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306f\u4e00\u56de\u3060\u3051\u30b7\u30fc\u30f3\u3092\u8a2d\u5b9a\u3059\u308b\u3053\u3068\u304c\u3067\u304d\u308b\u3002
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
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3068\u3057\u3066\u6709\u52b9\u304b\u3069\u3046\u304b\u3092\u7ba1\u7406\u3059\u308b\u30d5\u30e9\u30b0\u3002
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
     false\u306e\u5834\u5408\u3001\u30a2\u30af\u30c6\u30a3\u30d6\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306b\u306a\u308a\u5f97\u306a\u3044\u3002
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
        _transform = new SceneObjectTransform(this);
        _drawBack = new SceneObjectDrawBack(this);

        // \u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u304c\u8a2d\u5b9a\u3055\u308c\u3066\u304b\u3089\u3067\u306a\u3044\u3068\u4f8b\u5916\u3092\u767a\u751f\u3055\u305b\u3066\u3057\u307e\u3046
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
        // \u81ea\u8eab\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u30bb\u30c3\u30c8\u3059\u308b
        setMatrix(GetTransform().GetMatrix());

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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u632f\u308b\u821e\u3044\u3092\u8ffd\u52a0\u3059\u308b\u3002
     \u540c\u3058\u3082\u306e\u304c\u65e2\u306b\u8ffd\u52a0\u3055\u308c\u3066\u3044\u308b\u5834\u5408\u306f\u8ffd\u52a0\u3067\u304d\u306a\u3044\u3002
     
     @return \u8ffd\u52a0\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059
     */
    public boolean AddBehavior(SceneObjectBehavior behavior) {
        if (IsHaveBehavior(behavior.GetID())) {
            return false;
        }
        behavior.SetObject(this);
        return _behaviors.add(behavior);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u632f\u308b\u821e\u3044\u3092\u8fd4\u3059\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u632f\u308b\u821e\u3044\u3092\u8fd4\u3059\u3002
     
     @return index\u756a\u76ee\u306e\u632f\u308b\u821e\u3044 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public SceneObjectBehavior GetBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.get(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089ID\u306b\u8a72\u5f53\u3059\u308b\u632f\u308b\u821e\u3044\u3092\u8fd4\u3059\u3002
     
     @return behavior\u306b\u8a72\u5f53\u3059\u308bID\u306e\u632f\u308b\u821e\u3044 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u6307\u5b9a\u3057\u305f\u632f\u308b\u821e\u3044\u304c\u5b58\u5728\u3059\u308c\u3070\u524a\u9664\u3059\u308b\u3002
     
     @return \u524a\u9664\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059\u3002
     */
    public boolean RemoveBehavior(SceneObjectBehavior behavior) {
        return _behaviors.remove(behavior);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u632f\u308b\u821e\u3044\u3092\u524a\u9664\u3059\u308b\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u632f\u308b\u821e\u3044\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return index\u756a\u76ee\u306e\u632f\u308b\u821e\u3044 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public SceneObjectBehavior RemoveBehaviorOnIndex(int index) throws Exception {
        if (index >= _behaviors.size() || -index > _behaviors.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _behaviors.size();
        }
        return _behaviors.remove(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306e\u4e2d\u304b\u3089ID\u306b\u8a72\u5f53\u3059\u308b\u632f\u308b\u821e\u3044\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return behavior\u306b\u8a72\u5f53\u3059\u308bID\u306e\u632f\u308b\u821e\u3044 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070Null
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
     \u81ea\u8eab\u304c\u6307\u5b9a\u3055\u308c\u305f\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u89aa\u306e\u5834\u5408\u3001true\u3092\u8fd4\u3059\u3002
     */
    public boolean IsParentOf(SceneObject s) {
        return _transform.IsParentOf(s.GetTransform());
    }

    /**
     \u81ea\u8eab\u304c\u6307\u5b9a\u3055\u308c\u305f\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u5b50\u306e\u5834\u5408\u3001true\u3092\u8fd4\u3059\u3002
     */
    public boolean IsChildOf(SceneObject s) {
        return _transform.IsChildOf(s.GetTransform());
    }

    /**
     \u81ea\u8eab\u306e\u89aa\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u53d6\u5f97\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u6709\u52b9\u30d5\u30e9\u30b0\u304cfalse\u306e\u5834\u5408\u3001null\u3092\u8fd4\u3059\u3002
     */
    public SceneObject GetParent() {
        SceneObject s = _transform.GetParent().GetObject();
        if (s == null) {
            return null;
        }
        return s;
    }

    public boolean equals(Object o) {
        if (o == this) return true;
        return false;
    }

    public int compareTo(SceneObject s) {
        return _transform.compareTo(s.GetTransform());
    }
}
public class SceneObjectBehavior {
    /**
     \u6b8b\u5ff5\u306a\u304c\u3089\u5168\u3066\u306e\u30d3\u30d8\u30a4\u30d3\u30a2\u30af\u30e9\u30b9\u304c\u3053\u308c\u3092\u7d99\u627f\u3057\u3066\u9069\u5207\u306a\u5024\u3092\u8fd4\u3055\u306a\u3051\u308c\u3070\u306a\u3089\u306a\u3044\u3002
     */
    public int GetID() {
        return ClassID.BEHAVIOR;
    }

    /**
     \u632f\u308b\u821e\u3044\u306f\u4e00\u56de\u3060\u3051\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u8a2d\u5b9a\u3059\u308b\u3053\u3068\u304c\u3067\u304d\u308b\u3002
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
        if (o == this) return true;
        return false;
    }
}
public class SceneObjectButton extends Abs_SceneObjectBehavior {
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
}
public class SceneObjectCursor extends Abs_SceneObjectBehavior {
    /**
     \u6f20\u7136\u3068\u30ab\u30fc\u30bd\u30eb\u304c\u62bc\u3055\u308c\u305f\u6642\u306b\u30a4\u30d9\u30f3\u30c8\u3092\u767a\u751f\u3055\u305b\u308b\u3002
     \u4f55\u306e\u30ad\u30fc\u306a\u306e\u304b\u306f\u554f\u308f\u306a\u3044\u3002
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
}
public class SceneObjectDrawBack extends Abs_SceneObjectBehavior { //<>// //<>// //<>//
    /**
     \u80cc\u666f\u306e\u8272\u60c5\u5831\u3002
     */
    private DrawColor _backColorInfo;
    public DrawColor GetBackColorInfo() {
        return _backColorInfo;
    }

    /**
     \u30dc\u30fc\u30c0\u306e\u8272\u60c5\u5831\u3002
     */
    private DrawColor _borderColorInfo;
    public DrawColor GetBorderColorInfo() {
        return _borderColorInfo;
    }

    /**
     \u80cc\u666f\u306e\u63cf\u753b\u304c\u6709\u52b9\u304b\u3069\u3046\u304b\u3092\u4fdd\u6301\u3059\u308b\u30d5\u30e9\u30b0\u3002
     false\u306e\u5834\u5408\u3001\u9818\u57df\u5185\u90e8\u306f\u900f\u904e\u3055\u308c\u308b\u3002
     */
    private boolean _enableBack;
    public boolean IsEnableBack() {
        return _enableBack;
    }
    public void SetEnableBack(boolean value) {
        _enableBack = value;
    }

    /**
     \u30dc\u30fc\u30c0\u306e\u63cf\u753b\u304c\u6709\u52b9\u304b\u3069\u3046\u304b\u3092\u4fdd\u6301\u3059\u308b\u30d5\u30e9\u30b0\u3002
     false\u306e\u5834\u5408\u3001\u9818\u57df\u5468\u8fba\u306e\u30dc\u30fc\u30c0\u306f\u63cf\u753b\u3055\u308c\u306a\u3044\u3002
     */
    private boolean _enableBorder;
    public boolean IsEnableBorder() {
        return _enableBorder;
    }
    public void SetEnableBorder(boolean value) {
        _enableBorder = value;
    }

    /**
     \u30dc\u30fc\u30c0\u306e\u76f4\u5f84\u3002
     */
    private float _borderSize;
    public float GetBorderSize() {
        return _borderSize;
    }
    public void SetBorderSize(float value) {
        _borderSize = value;
    }

    /**
     \u30dc\u30fc\u30c0\u306e\u7aef\u306e\u5f62\u3002
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
}
public class SceneObjectImage extends Abs_SceneObjectDrawBase {
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
}
public class SceneObjectText extends Abs_SceneObjectDrawBase {
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
     \u30d5\u30a9\u30f3\u30c8\u306f\u30de\u30cd\u30fc\u30b8\u30e3\u304b\u3089\u53d6\u5f97\u3059\u308b\u306e\u3067\u3001\u53c2\u7167\u3092\u5206\u6563\u3055\u305b\u306a\u3044\u3088\u3046\u306b\u6587\u5b57\u5217\u3067\u5bfe\u5fdc\u3059\u308b\u3002
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
     \u884c\u9593\u3092\u30d4\u30af\u30bb\u30eb\u5358\u4f4d\u3067\u6307\u5b9a\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u6700\u521d\u304b\u3089\u30d5\u30a9\u30f3\u30c8\u30b5\u30a4\u30ba\u3068\u540c\u3058\u5927\u304d\u3055\u306e\u884c\u9593\u304c\u8a2d\u5b9a\u3055\u308c\u3066\u3044\u308b\u3002
     */
    public void SetLineSpace(float value) {
        float space = _fontSize + value;
        if (0 <= space) {
            _lineSpace = space;
        }
    }

    /**
     \u6587\u5b57\u5217\u306e\u63cf\u753b\u30e2\u30fc\u30c9\u3002
     false\u306e\u5834\u5408\u3001\u901a\u5e38\u3068\u540c\u3058\u3088\u3046\u306b\u4e00\u6589\u306b\u63cf\u753b\u3059\u308b\u3002
     true\u306e\u5834\u5408\u3001\u30b2\u30fc\u30e0\u306e\u30bb\u30ea\u30d5\u306e\u3088\u3046\u306b\u4e00\u6587\u5b57\u305a\u3064\u63cf\u753b\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001true\u306e\u5834\u5408\u306f\u3001align\u3067\u8a2d\u5b9a\u3055\u308c\u3066\u3044\u308b\u306e\u304cLEFT TOP\u4ee5\u5916\u3060\u3068\u9055\u548c\u611f\u306e\u3042\u308b\u63cf\u753b\u306b\u306a\u308b\u3002
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
}
public final class SceneObjectTransform extends SceneObjectBehavior implements Comparable<SceneObjectTransform> {
    private SceneObjectTransform _parent;
    public SceneObjectTransform GetParent() {
        return _parent;
    }
    /**
     \u89aa\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u8a2d\u5b9a\u3059\u308b\u3002
     \u81ea\u52d5\u7684\u306b\u524d\u306e\u89aa\u3068\u306e\u89aa\u5b50\u95a2\u4fc2\u306f\u7d76\u305f\u308c\u308b\u3002
     \u305f\u3060\u3057\u3001\u6307\u5b9a\u3057\u305f\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u304cnull\u306e\u5834\u5408\u306f\u3001\u30b7\u30fc\u30f3\u30a4\u30f3\u30b9\u30bf\u30f3\u30b9\u304c\u89aa\u306b\u306a\u308b\u3002
     
     isPriorityChange\u304ctrue\u306e\u5834\u5408\u3001\u81ea\u52d5\u7684\u306b\u89aa\u306e\u512a\u5148\u5ea6\u3088\u308a1\u3060\u3051\u9ad8\u3044\u512a\u5148\u5ea6\u304c\u3064\u3051\u3089\u308c\u308b\u3002
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
     \u89aa\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u8a2d\u5b9a\u53ef\u80fd\u3067\u3042\u308b\u5834\u5408\u306f\u3001true\u3068\u306a\u308b\u3002
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
     \u512a\u5148\u5ea6\u3002
     \u968e\u5c64\u69cb\u9020\u3068\u306f\u6982\u5ff5\u304c\u7570\u306a\u308b\u3002
     \u4e3b\u306b\u63cf\u753b\u3084\u5f53\u305f\u308a\u5224\u5b9a\u306e\u512a\u5148\u5ea6\u3068\u3057\u3066\u7528\u3044\u3089\u308c\u308b\u3002
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
     \u7d76\u5bfe\u5909\u5316\u91cf\u884c\u5217\u3002
     \u3053\u308c\u3092\u5909\u63db\u884c\u5217\u3068\u3057\u3066\u304b\u3089\u63cf\u753b\u3059\u308b\u3053\u3068\u3067\u7d76\u5bfe\u5909\u5316\u91cf\u304c\u8868\u73fe\u3059\u308b\u56f3\u5f62\u3068\u3057\u3066\u63cf\u753b\u3055\u308c\u308b\u3002
     */
    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }
    private void _PushMatrix() {
        getMatrix(_matrix);
    }

    /**
     \u5e73\u884c\u79fb\u52d5\u91cf\u3068\u56de\u8ee2\u91cf\u306e\u8868\u73fe\u3057\u3066\u3044\u308b\u3082\u306e\u304c\u3001\u89aa\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u76f8\u5bfe\u91cf\u306a\u306e\u304b\u3001\u30b7\u30fc\u30f3\u304b\u3089\u306e\u7d76\u5bfe\u91cf\u306a\u306e\u304b\u3092\u6c7a\u3081\u308b\u3002
     true\u306e\u5834\u5408\u3001\u76f8\u5bfe\u91cf\u3068\u306a\u308b\u3002
     */
    private boolean _isRelative;
    public boolean IsRelative() {
        return _isRelative;
    }
    public void SetRelative(boolean value) {
        _isRelative = value;
    }

    /**
     \u5e73\u884c\u79fb\u52d5\u91cf\u3002
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
     \u56de\u8ee2\u91cf\u3002
     */
    private float _rotate;
    public float GetRotate() { 
        return _rotate;
    }
    public void SetRotate(float value) { 
        _rotate = value;
    }

    /**
     \u56f3\u5f62\u306e\u63cf\u753b\u9818\u57df\u3002
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
        _parentAnchor = new Anchor();
        _selfAnchor = new Anchor();
        _priority = 1;
        _isRelative = true;

        _children = new ArrayList<SceneObjectTransform>();
        _matrix = new PMatrix2D();
    }

    /**
     \u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u51e6\u7406\u3092\u5b9f\u884c\u3059\u308b\u3002
     */
    public void Transform() {
        if (!GetObject().IsEnable()) {
            return;
        }
        // \u4fdd\u5b58\u306e\u9650\u754c\u3067\u306a\u3044\u304b\u3069\u3046\u304b
        if (!matrixManager.PushMatrix()) {
            return;
        }

        // \u76f8\u5bfe\u91cf\u304b\u7d76\u5bfe\u91cf\u304b\u3092\u6307\u5b9a
        SceneObjectTransform parent;
        if (_isRelative) {
            parent = _parent;
        } else {
            parent = GetScene().GetTransform();
            GetScene().TransformScene();
        }

        float par1, par2;

        // \u89aa\u306e\u57fa\u6e96\u3078\u79fb\u52d5
        par1 = _parentAnchor.GetX();
        par2 = _parentAnchor.GetY();
        translate(par1 * parent.GetSize().x, par2 * parent.GetSize().y);

        // \u81ea\u8eab\u306e\u57fa\u6e96\u3067\u306e\u56de\u8ee2
        rotate(_rotate);

        // \u81ea\u8eab\u306e\u57fa\u6e96\u3078\u79fb\u52d5
        par1 = _selfAnchor.GetX();
        par2 = _selfAnchor.GetY();
        translate(-par1 * _size.x + _position.x, -par2 * _size.y + _position.y);

        // \u518d\u5e30\u7684\u306b\u8a08\u7b97\u3057\u3066\u3044\u304f
        if (_children != null) {
            for (int i=0; i<_children.size(); i++) {
                _children.get(i).Transform();
            }
        }
        _PushMatrix();
        matrixManager.PopMatrix();
    }

    /**
     \u6307\u5b9a\u5ea7\u6a19\u304c\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u9818\u57df\u5185\u3067\u3042\u308c\u3070true\u3092\u8fd4\u3059\u3002
     */
    public boolean IsInRegion(float y, float x) {
        PMatrix2D inv = GetMatrix().get();
        if (!inv.invert()) {
            println(this);
            println("\u9006\u30a2\u30d5\u30a3\u30f3\u5909\u63db\u304c\u3067\u304d\u307e\u305b\u3093\u3002");
            return false;
        }

        float[] in, out;
        in = new float[]{y, x};
        out = new float[2];
        inv.mult(in, out);
        return 0 <= out[0] && out[0] < _size.x && 0 <= out[1] && out[1] < _size.y;
    }

    /**
     \u81ea\u8eab\u304c\u6307\u5b9a\u3055\u308c\u305f\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u89aa\u306e\u5834\u5408\u3001true\u3092\u8fd4\u3059\u3002
     */
    public boolean IsParentOf(SceneObjectTransform t) {
        return this == t.GetParent();
    }

    /**
     \u81ea\u8eab\u304c\u6307\u5b9a\u3055\u308c\u305f\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u306e\u5b50\u306e\u5834\u5408\u3001true\u3092\u8fd4\u3059\u3002
     */
    public boolean IsChildOf(SceneObjectTransform t) {
        return _parent == t;
    }

    /**
     \u81ea\u8eab\u306e\u5b50\u3068\u3057\u3066\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u8ffd\u52a0\u3059\u308b\u3002
     \u305f\u3060\u3057\u3001\u65e2\u306b\u5b50\u3068\u3057\u3066\u5b58\u5728\u3057\u3066\u3044\u308b\u5834\u5408\u306f\u8ffd\u52a0\u3067\u304d\u306a\u3044\u3002
     \u57fa\u672c\u7684\u306b\u3001\u89aa\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u304b\u3089\u89aa\u5b50\u95a2\u4fc2\u3092\u69cb\u7bc9\u3059\u308b\u306e\u306f\u7981\u6b62\u3059\u308b\u3002
     
     @return \u8ffd\u52a0\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059
     */
    private boolean _AddChild(SceneObjectTransform t) {
        if (GetChildren().contains(t)) {
            return false;
        }
        return _children.add(t);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u8fd4\u3059\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u8fd4\u3059\u3002
     
     @return index\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public SceneObjectTransform GetChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.get(index);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306b\u6307\u5b9a\u3057\u305f\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u304c\u5b58\u5728\u3059\u308c\u3070\u524a\u9664\u3059\u308b\u3002
     
     @return \u524a\u9664\u306b\u6210\u529f\u3057\u305f\u5834\u5408\u306ftrue\u3092\u8fd4\u3059\u3002
     */
    public boolean RemoveChild(SceneObjectTransform t) {
        return _children.remove(t);
    }

    /**
     \u81ea\u8eab\u306e\u30ea\u30b9\u30c8\u306eindex\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u524a\u9664\u3059\u308b\u3002
     \u8ca0\u6570\u3092\u6307\u5b9a\u3057\u305f\u5834\u5408\u3001\u5f8c\u308d\u304b\u3089index\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0\u3092\u524a\u9664\u3059\u308b\u3002
     
     @return index\u756a\u76ee\u306e\u30c8\u30e9\u30f3\u30b9\u30d5\u30a9\u30fc\u30e0 \u5b58\u5728\u3057\u306a\u3051\u308c\u3070null
     @throws Exception index\u304c\u30ea\u30b9\u30c8\u306e\u30b5\u30a4\u30ba\u3088\u308a\u5927\u304d\u3044\u5834\u5408
     */
    public SceneObjectTransform RemoveChild(int index) throws Exception {
        if (index >= _children.size() || -index > _children.size()) {
            throw new Exception("\u6307\u5b9a\u3055\u308c\u305findex\u304c\u4e0d\u6b63\u3067\u3059\u3002 index : " + index);
        }
        if (index < 0) {
            index += _children.size();
        }
        return _children.remove(index);
    }

    /**
     \u81ea\u5206\u4ee5\u5916\u306e\u5834\u5408\u3001false\u3092\u8fd4\u3059\u3002
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    /**
     \u512a\u5148\u5ea6\u306b\u3088\u3063\u3066\u6bd4\u8f03\u3092\u884c\u3046\u3002
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
/**
 \u30a2\u30d5\u30a3\u30f3\u5909\u63db\u4e00\u56de\u5206\u306e\u60c5\u5831\u306b\u8cac\u4efb\u3092\u6301\u3064\u3002
 \u30b5\u30a4\u30ba\u306f\u6301\u305f\u306a\u3044\u3002
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
    public void settings() {  size(1066, 600, P3D); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "FabulousEnders" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
