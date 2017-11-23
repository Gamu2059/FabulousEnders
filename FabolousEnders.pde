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

// 全てのシーンインスタンスで共通するトランスフォームパラメータ

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
MatrixManager matrixManager;
ImageManager imageManager;

float x;
SceneObjectTransform objT;

void setup() {
    size(displayWidth, displayHeight);
    frame.setLocation(0, 0);

    InitManager();

    //Scene scene = new Scene("main");
    //SceneObject o = new SceneObject("camera?", scene);
    //objT = o.GetTransform();
    //objT.SetSize(100, 100);
    //objT.SetParentAnchor(SceneObjectAnchor.CENTER_MIDDLE);

    //sceneManager.Start("main");
}

/**
 用意されたマネージャオブジェクトを自動的に生成する。
 */
void InitManager() {
    inputManager = new InputManager();
    sceneManager = new SceneManager();
    matrixManager = new MatrixManager();
    imageManager = new ImageManager();
}

void draw() {
    //sceneManager.Update();
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