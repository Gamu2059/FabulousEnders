public class TestComponent extends Abs_UIComponent {
    public TestComponent(String componentName, UIScene scene) {
        super(componentName, scene);
    }
    
    public void DrawComponent() {
        resetMatrix();
        
        UITransform real, draw;
        draw = super.GetTransform();
        real = super.GetRealTransform();
        
        //rotate(real.GetRotate());
        translate(real.GetPosition().x, real.GetPosition().y);
        
        fill(255, 0, 0);
        rect(0, 0, draw.GetSize().x * real.GetScale().x , draw.GetSize().y * real.GetScale().y);
    }
}