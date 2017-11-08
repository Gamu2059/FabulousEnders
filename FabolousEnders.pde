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
Abs_UIComponent comp;

void setup() {
    size(500, 500);
    
    sceneTransform = new UITransform();
    sceneTransform.SetSize(width, height);
    
    atsu = loadImage("a.png");
    
    scene = new UIScene("main");
    comp = new TestComponent("test", scene);
    UITransform compT = comp.GetTransform();
    compT.SetSize(100, 100);
    compT.SetPosition(0, 0);
    comp.SetParentAnchor(UIAnchor.CENTER_MIDDLE);
    comp.SetSelfAnchor(UIAnchor.CENTER_MIDDLE);
    comp.SetBackColor(color(200, 200, 0, 100));
}

void draw() {
    background(255);

    scene.UpdateTransform();
    scene.DrawScene();
    //x+=1/frameRate;
    //comp.GetTransform().SetRotate(x);

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
    //rotate(y);
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