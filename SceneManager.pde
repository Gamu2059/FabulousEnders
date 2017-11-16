/**
 シーンを管理するためのマネージャクラス。
 */
public class SceneManager {
    private ArrayList<Scene> _scenes;
    public ArrayList<Scene> GetScenes() {
        return _scenes;
    }

    public SceneManager () {
        _scenes = new ArrayList<Scene>();
    }

    /**
     自身のリストにコンポーネントを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public boolean AddScene(Scene scene) {
        if (GetScene(scene.GetName()) != null) {
            return false;
        }
        return _scenes.add(scene);
    }

    /**
     自身のリストのindex番目のコンポーネントを返す。
     負数を指定した場合、後ろからindex番目のコンポーネントを返す。
     
     @return index番目のコンポーネント 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene GetScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のコンポーネントを返す。
     同名のコンポーネントが存在した場合、リストの早い方を返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     */
    public Scene GetScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したコンポーネントが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public boolean RemoveScene(Scene scene) {
        return _scenes.remove(scene);
    }

    /**
     自身のリストのindex番目のコンポーネントを削除する。
     負数を指定した場合、後ろからindex番目のコンポーネントを削除する。
     
     @return index番目のコンポーネント 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public Scene RemoveScene(int index) throws Exception {
        if (index >= _scenes.size() || -index > _scenes.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _scenes.size();
        }
        return _scenes.remove(index);
    }

    /**
     自身のリストの中からnameと一致するコンポーネントを削除する。
     同名のコンポーネントが存在した場合、リストの早い方を削除し、それを返す。
     
     @return nameと一致する名前のコンポーネント 存在しなければNull
     */
    public Scene RemoveScene(String name) {
        Scene s;
        for (int i=0; i<_scenes.size(); i++) {
            s = _scenes.get(i);
            if (s.GetName().equals(name)) {
                return _scenes.remove(i);
            }
        }
        return null;
    }

    /**
     自分以外は全てfalseを返す。
     */
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        return false;
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("\nSceneManager :\n");
        b.append(_scenes);
        return b.toString();
    }
}