/**
 接頭辞について。
 PE ... ProcessingEngineの略称。Pjsで動作する保証がないクラス。要検証。
 PEO... ProcessingEngineOnlyの略称。Pjsで動作しないことが分かりきっているクラス。
 */

import java.util.*;
import java.lang.reflect.*;
import java.io.*;

// マネージャインスタンス
InputManager inputManager;
SceneManager sceneManager;
ImageManager imageManager;
FontManager fontManager;
TransformManager transformManager;

void setup() {
    surface.setSize(890, 500);
    try {
        InitManager();
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
}

void draw() {
    try {
        background(0);
        sceneManager.Update();
        inputManager.Update();
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