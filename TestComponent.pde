public class TestComponent extends Abs_UIComponent {
    public TestComponent(String componentName, UIScene scene) {
        super(componentName, scene);
    }

    public void DrawComponent() {
        super.DrawBack();

        try {
            if (!super.IsinRegion(mouseX, mouseY)) {
                fill(0, 0, 255);
            } else {
                fill(255, 0, 0);
            }
            stroke(0);
            line(0, 0, 0, height);
            line(0, 0, width, 0);
        } 
        catch(Exception e) {
            println(e);
        }
    }
}