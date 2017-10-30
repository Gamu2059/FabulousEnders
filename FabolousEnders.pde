private InputManager _inputManager;

Test t;
void setup() {
    t = new Test();

    _inputManager = new InputManager();
}

void draw() {
    boolean f = _inputManager.IsPressedKey(Key._0, Key._D, Key._DOWN);
    if (f) {
        background(200, 0, 0);
    } else {
        background(0, 0, 200);
    }
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

void mouseEntered(){
    _inputManager.MouseEntered();
}

void mouseExited() {
    _inputManager.MouseExited();
}