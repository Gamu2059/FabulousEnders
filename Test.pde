public class Test {

    public void Update() {
        if (keyPressed) {
            keyPressed();
        } else {
         keyReleased();
        }
    }

    public void keyPressed() {
        background(200, 0, 0);
    }

    public void keyReleased() {
        background(0, 0, 200);
    }
}