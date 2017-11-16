/**
 SceneObjectをまとめるクラス。
 シーンの読込単位。
 */
public class Scene {
    private String _name;
    public String GetName() {
        return _name;
    }

    private ArrayList<SceneObject> _objects;

    public Scene (String name) {
        _name = name;
        _objects = new ArrayList<SceneObject>();
    }


    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (o == null) {
            return false;
        }
        if (!(o instanceof Scene)) {
            return false;
        }
        Scene s = (Scene) o;
        return _name.equals(s.GetName());
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nScene :");
        b.append("\n  name : ").append(_name);
        b.append("\n  objects :\n");
        b.append(_objects);

        return b.toString();
    }
}