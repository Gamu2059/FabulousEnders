/***/
public class SceneObject {
    private String _name;
    public String GetName() {
     return _name;   
    }
    
    public SceneObject(String name, Scene scene) {
        _name = name;
        
        scene.AddObject(this);
    }
}