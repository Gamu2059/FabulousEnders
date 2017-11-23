/**
 クラス名は一部規則を設ける。Hogeの部分は任意。
 マネージャ(シングルトン)；HogeManager
 抽象クラス：Abs_Hoge
 インタフェース：Int_Hoge
 例外クラス：HogeException
 列挙型：Enm_Hoge
 */

import java.util.*;
import java.lang.reflect.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
MatrixManager matrixManager;
ImageManager imageManager;
FontManager fontManager;

float x;
SceneObjectTransform objT;

void setup() {
    size(displayWidth, displayHeight);

    InitManager();

    Scene scene = new Scene("main");
    SceneObject o = new SceneObject("camera?", scene);
    o.GetDrawBack().GetBackColorInfo().SetBlueOrBrightness(200);

    //SetText(o);

    objT = o.GetTransform();
    objT.SetSize(100, 100);
    objT.SetRotate(1);
    objT.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);

    sceneManager.Start("main");
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
    sceneManager.Update();
}

void keyPressed() {
    inputManager.KeyPressed();
    SetImage(objT.GetObject());
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