import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
MatrixManager matrixManager;
ImageManager imageManager;
FontManager fontManager;

void setup() {
    size(1024, 600);
    surface.setLocation(0, 0);
    try {
        InitManager();

        Scene scene = new Scene("main");
        scene.GetDrawBack().GetBackColorInfo().SetColor(200, 200, 200);

        SceneObjectTransform objT;

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
    inputManager = new InputManager();
    sceneManager = new SceneManager();
    matrixManager = new MatrixManager();
    imageManager = new ImageManager();
    fontManager = new FontManager();
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