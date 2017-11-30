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
    size(1066, 600, P3D);
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