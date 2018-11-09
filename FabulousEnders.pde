/*
指南書

●操作について
このゲームは全てマウスだけで操作します。
ゲームを始めるにはタイトルの Start Game をクリックしてください。

ゲームが始まるとすぐに操作ができます。
プレイヤーは青いユニットを操作し、赤いユニットを全て撃破することでクリアすることができます。
しかし、全ての青いユニットが撃破されるとゲームオーバーになります。

青いユニットをクリックすると青と赤のマスが表示されます。
青のマスは一度の移動でそのマスの範囲のどこかに移動できることを意味します。
赤のマスは一度の移動でそのマスの範囲のどこかに攻撃できることを意味します。

まずはユニットをクリックしてから青いマスのどこかでマウスをクリックしてユニットを移動させます。
移動を完了して良い場合はメニューから待機を、移動をやり直したい場合はやり直しをクリックします。

移動後の攻撃範囲内に敵ユニットがいる場合、メニューに攻撃という項目が追加されます。
これをクリックすると青いユニットの攻撃範囲が赤いマスで描かれ、そのマスの上にいる敵をクリックすることで敵に攻撃することができます。
攻撃終了後は強制的に移動完了状態になります。

全ての青いユニットを移動完了状態にすると、次は敵の行動フェーズになります。
敵も同様にして移動、攻撃を行い、全ての赤いユニットが移動完了状態になると再びプレイヤーの行動フェーズになります。

プレイヤーの行動フェーズで敵のユニットをクリックするとその敵の攻撃範囲をマークした危険範囲というものが表示されるようになります。
危険範囲を解除したい場合はもう一度そのユニットをクリックします。
この危険範囲は敵ユニットそれぞれに個別で切り替えを行うことができます。

プレイヤーの行動フェーズでどのユニットも選択していない状態で青いユニットや赤いユニットを右クリックすると、
そのユニットの詳細なパラメータをコンソールで確認することができます。
見づらいですが攻略の参考にすることができます。

●ユニットの性能について
剣士
剣士のユニットは素早さが高く、敵によっては二回攻撃することができます。
しかし、守備力が低めなので返り打ちに気を付ける必要があります。

騎士
基本的に強いので攻めにも守りにも使えます。
素早さが低いので敵の二回攻撃には注意する必要があります。

アーチャー
射程範囲の広い弓を使って遠距離攻撃をすることができます。
ただし、自身の周囲1マスは攻撃できないので、敵に隣接されると反撃できず不利になります。

魔導士
魔法攻撃によって敵を攻撃します。
守備力が高い敵は魔法で攻撃すると良いです。
その代わりに、魔導士は守備力が大変低いので敵の攻撃には注意する必要があります。
*/

import java.util.*;
import java.io.*;

// pjsで実行するときはfalseにする
boolean isProcessing = false;

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
        feManager.Init();

        sceneManager.LoadScene(SceneID.SID_TITLE);
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

    feJsonUtility = new FEJsonUtility();
    feManager = new FEManager();
}

void SetScenes() {
    dialog = new SceneDialog();
    sceneManager.AddScene(dialog);
    sceneManager.AddScene(new SceneTitle());
    sceneManager.AddScene(new SceneOneIllust());
    sceneManager.AddScene(new SceneGameOver());
    sceneManager.AddScene(new SceneGameClear());

    sceneManager.AddScene(new FESceneBattleMap());
}

void draw() {
    try {
        background(0);
        sceneManager.Update();
        inputManager.Update();
        feManager.Update();
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