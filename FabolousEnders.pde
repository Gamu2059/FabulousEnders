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

PImage atsu;

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

    scene.UpdateTransform();
    scene.DrawScene();
    x+=1/frameRate;
    //comp1.GetTransform().SetRotate(x);
    comp2.GetTransform().SetRotate(x);

    //translate(width/2, height/2);
    //rotate(x);
    //translate(-100,-100);

    //fill(200, 200, 0);
    //rect(0, 0, 200, 200);


    //// 右下基準の矩形
    //pushMatrix();
    //// 子から見た親の基準へ移動
    //translate(200, 200);
    //// 子の回転
    //rotate(0);
    //translate(-100, -50);
    //fill(color(200, 100, 200, 100));
    //strokeWeight(5);
    //rect(0, 0, 100, 50);
    ////image(atsu, 0, 0, 100, 50);
    //strokeWeight(1);

    //popMatrix();

    //// 右上基準の矩形
    //pushMatrix();
    //translate(200, 0);
    //rotate(-y);
    //scale(1, 0.5f);
    //fill(0);
    //rect(0, 0, 100, 50);
    //popMatrix();

    //x+=1/frameRate;
    //y+=1/frameRate;
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