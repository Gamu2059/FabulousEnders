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
UITransform sceneTransform;

// マネージャインスタンス
InputManager inputManager = new InputManager();
UIManager uiManager = new UIManager();
MatrixManager matrixManager = new MatrixManager();

float x = 0, y=0;

UIScene scene;
Abs_UIComponent comp1, comp2;

void setup() {
    size(500, 500);
    
    // sceneTransfrom definition
    sceneTransform = new UITransform();
    sceneTransform.SetSize(width, height);
    
    scene = new UIScene("main");
    comp1 = new UIPanel("panel", scene);
    UITransform compT = comp1.GetTransform();
    compT.SetSize(100, 100);
    compT.SetPosition(0, 0);
    compT.SetScale(1, 2);
    comp1.SetParentAnchor(UIAnchor.CENTER_MIDDLE);
    comp1.SetSelfAnchor(UIAnchor.CENTER_MIDDLE);
    comp1.SetBackColor(color(200, 200, 0, 100));
    comp1.SetDrawBorder(true);
    comp1.SetBorderColor(color(0));
    comp1.SetBorderSize(2);
    
    comp2 = new UIPanel("nested panel", scene);
    comp1.AddComponent(comp2);
    compT = comp2.GetTransform();
    compT.SetSize(100, 100);
    compT.SetPosition(100, 0);
    comp2.SetParentAnchor(UIAnchor.RIGHT_BOTTOM);
    comp2.SetSelfAnchor(UIAnchor.LEFT_TOP);
    comp2.SetBackColor(color(0, 200, 200));
    comp2.SetDrawBorder(true);
    comp2.SetBorderColor(color(255, 0, 0));
    comp2.SetBorderSize(2);
    comp2.SetRelative(true);
    
}

void draw() {
    background(255);
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