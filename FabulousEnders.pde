/**
 接頭辞について。
 FE ... FabulousEnders上で使用するクラスファイル群。
 P  ... システム上で使用するクラスファイル群。
 */

import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// pjsで実行するときはfalseにする
boolean isProcessing = true;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
ImageManager imageManager;
FontManager fontManager;
TransformManager transformManager;

FEJsonUtility feJsonUtility;
FEManager feManager;

SceneDialog dialog;

void setup() {
    size(880, 480);
    try {
        InitManager();
        SetScenes();
        sceneManager.LoadScene(SceneID.SID_FE_BATTLE_MAP);

        sceneManager.Start();
        feManager.StartGame();
        feManager.GetBattleMapManager().LoadMapData("test_map.json");
    } 
    catch(Exception e) {
        println(e);
    }
}

void InitManager() {
    inputManager = new InputManager();
    sceneManager = new SceneManager();
    imageManager = new ImageManager();
    fontManager = new FontManager();
    transformManager = new TransformManager();

    feJsonUtility = new FEJsonUtility();
    feManager = new FEManager();
}

void SetScenes() {
    dialog = new SceneDialog();
    sceneManager.AddScene(dialog);
    sceneManager.AddScene(new SceneTitle());
    sceneManager.AddScene(new SceneOneIllust());
    sceneManager.AddScene(new SceneGameOver());

    sceneManager.AddScene(new FESceneBattleMap());
}

void draw() {
    try {
        background(0);
        sceneManager.Update();
        inputManager.Update();
        //println(frameRate);
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

void mouseOver() {
    inputManager.MouseEntered();
}

void mouseOut() {
    inputManager.MouseExited();
}