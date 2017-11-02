import java.util.*;

private InputManager _inputManager;

void setup() {
    _inputManager = new InputManager();
}


void keyPressed() {
    _inputManager.KeyPressed();
}

void keyReleased() {
    _inputManager.KeyReleased();
}

void mousePressed() {
    _inputManager.MousePressed();
}

void mouseReleased() {
    _inputManager.MouseReleased();
}

void mouseClicked() {
    _inputManager.MouseClicked();
}

void mouseWheel() {
    _inputManager.MouseWheel();
}

void mouseMoved() {
    _inputManager.MouseMoved();
}

void mouseDragged() {
    _inputManager.MouseDragged();
}

void mouseEntered() {
    _inputManager.MouseEntered();
}

void mouseExited() {
    _inputManager.MouseExited();
}