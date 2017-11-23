/**
 クラス名は一部規則を設ける。Hogeの部分は任意。
 マネージャ(シングルトン)；HogeManager
 抽象クラス：Abs_Hoge
 インタフェース：Int_Hoge
 例外クラス：HogeException
 列挙型：Enm_Hoge
 */

import java.util.*;

// 全てのシーンインスタンスで共通するトランスフォームパラメータ

// マネージャインスタンス
InputManager inputManager = new InputManager();
SceneManager sceneManager = new SceneManager();
MatrixManager matrixManager = new MatrixManager();

float x;
SceneObjectTransform objT;

void setup() {
    size(displayWidth, displayHeight);
    frame.setLocation(0, 0);

    Scene scene = new Scene("main");
    SceneObject o = new SceneObject("camera?", scene);
    objT = o.GetTransform();
    objT.SetSize(100, 100);
    objT.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);

    sceneManager.Start("main");
}

void draw() {
    sceneManager.Update();
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