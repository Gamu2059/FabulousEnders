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
SceneObjectTransform objT;
float x;
void setup() {
    size(1066, 600);
    surface.setLocation(0, 0);
    try {
        InitManager();

        scene = new Scene("main");
        scene.GetTransform().SetPosition(100, 100);
        scene.SetSceneScale(0.5, 1);
        scene.GetDrawBack().GetBackColorInfo().SetColor(100, 0, 100);

        SceneObject o = new SceneObject("camera?", scene);
        SetText(o);
        objT = o.GetTransform();
        objT.SetSize(100, 100);
        objT.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);
        objT.SetSelfAnchor(SceneObjectAnchor.CENTER_MIDDLE);

        SceneObject o1 = new SceneObject("Overlapped", scene);
        o1.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        SetImage(o1);
        objT = o1.GetTransform();
        objT.SetParent(o.GetTransform(), true);
        objT.SetSize(100, 140);
        objT.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);

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

void draw() {
    surface.setTitle("Game Maker fps : " + frameRate);
    try {
        sceneManager.Update();
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