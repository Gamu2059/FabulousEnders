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
PEOScenePositionManager peoScenePositionManager;

void setup() {
    size(displayWidth, displayHeight);
    surface.setLocation(0, 0);
    try {
        InitManager();
        
        PEOSceneMenuBar menu = new PEOSceneMenuBar();
        sceneManager.AddScene(menu);
        sceneManager.LoadScene(menu.GetName());
        
        PEOSceneOperationBar operation = new PEOSceneOperationBar();
        sceneManager.AddScene(operation);
        sceneManager.LoadScene(operation.GetName());
        
        PEOSceneViewBase view = new PEOSceneViewBase("hoge", "Scene");
        sceneManager.AddScene(view);
        sceneManager.LoadScene(view.GetName());
        
        PEOSceneProjectBase project = new PEOSceneProjectBase("huga", "Project");
        sceneManager.AddScene(project);
        sceneManager.LoadScene(project.GetName());
        
        PEOSceneHeararchyBase heararchy = new PEOSceneHeararchyBase("heararchy", "Heararchy");
        sceneManager.AddScene(heararchy);
        sceneManager.LoadScene(heararchy.GetName());
        
        PEOSceneInspectorBase inspector = new PEOSceneInspectorBase("inspector", "Inspector");
        sceneManager.AddScene(inspector);
        sceneManager.LoadScene(inspector.GetName());

        sceneManager.Start();
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
    
    peoScenePositionManager = new PEOScenePositionManager();
}

void draw() {
    // これをつけているとpjsで動きません
    surface.setTitle("Game Maker fps : " + frameRate);
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