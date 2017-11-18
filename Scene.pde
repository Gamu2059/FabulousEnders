import java.util.*;

/**
 SceneObjectをまとめるクラス。
 */
public class Scene extends SceneObject {
    private ArrayList<SceneObject> _objects;
    public final ArrayList<SceneObject> GetObjects() {
        return _objects;
    }

    /**
     マウスやカーソルによって選択されているオブジェクトを返す。
     */
    private SceneObject _activeObject;
    public SceneObject GetActiveObject() {
        return _activeObject;
    }

    /**
     次のフレームからアクティブになる場合にtrueになる。
     */
    private boolean _enabledFlag;
    public final void SetEnabledFlag(boolean value) {
        _enabledFlag = value;
    }
    /**
     次のフレームからノンアクティブになる場合にtrueになる。
     */
    private boolean _disabledFlag;
    public final void SetDisabledFlag(boolean value) {
        _disabledFlag = value;
    }

    /**
     オブジェクトの優先度変更が発生している場合はtrueになる。
     これがtrueでなければソートはされない。
     */
    private boolean _isNeedSorting;

    public Scene (String name) {
        super(name);
        _objects = new ArrayList<SceneObject>();

        sceneManager.AddScene(this);
    }


    /**
     シーンの初期化を行う。
     ゲーム開始時に呼び出される。
     */
    public void InitScene() {
        _isNeedSorting = true;
        _Sorting();
    }

    /**
     　アクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Enabled() {
        _enabledFlag = false;
    }

    /**
     ノンアクティブシーンになる直前のフレームの一番最後に呼び出される。
     */
    public void Disabled() {
        _disabledFlag = false;
    }


    /**
     毎フレームのシーン更新処理。
     */
    public void Update() {
        _Start();
        _Update();
        _Animation();
        _Transform();
        _Sorting();
        _CheckMAO();
        _Draw();
    }

    /**
     フレームの最も最初に呼び出される。
     ロードされてからは一度しか呼び出されない。
     */
    protected void _Start() {
        if (_objects == null) {
            return;
        }

        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsStartFlag()) {
                ;
            }
        }
    }

    /**
     毎フレーム呼び出される。
     入力待ちやオブジェクトのアニメーション処理を行う。
     */
    public void _Update() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable()) {
                ;
            }
        }
    }

    /**
     _Updateとは異なり、AnimationBehaviorによる高度なフレームアニメーションを行う。
     主に子オブジェクトのアニメーションや画像連番表示を処理するのに用いる。
     */
    public void _Animation() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.GetBehavior(SceneObjectAnimationController.class) != null) {
                ;
            }
        }
    }

    /**
     オブジェクトを移動させる。
     ここまでに指示されたトランスフォームの移動は、全てここで処理される。
     それ以降のトランスフォーム処理は無視される。
     */
    public void _Transform() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsChildOf(this)) {
                ;
            }
        }
    }

    /**
     オブジェクトのトランスフォームの優先度によってソートする。
     毎度処理していると重くなるのフラグが立っている時のみ処理する。
     */
    public void _Sorting() {
        if (!_isNeedSorting) {
            return;
        }

        _isNeedSorting = false;
        Collections.sort(_objects);
    }

    /**
     オブジェクトに対してマウスカーソルがどのように重なっているか判定する。
     */
    public void _CheckMAO() {
        SceneObject s;
        for (int i=_objects.size()-1; i>=0; i--) {
            s = _objects.get(i);
            if (s.IsEnable() && s.GetBehavior(SceneObjectInputListener.class) != null) {
                ;
            }
        }
    }

    /**
     ドローバックとイメージ系の振る舞いを持つオブジェクトの描画を行う。
     */
    public void _Draw() {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.IsEnable() && s.IsChildOf(this)) {
                ;
            }
        }
    }

    /**
     自身のリストにオブジェクトを追加する。
     ただし、既に子として追加されている場合は追加できない。
     
     @return 追加に成功した場合はtrueを返す
     */
    public final boolean AddObject(SceneObject object) {
        if (GetObject(object.GetName()) != null) {
            return false;
        }
        return _objects.add(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを返す。
     負数を指定した場合、後ろからindex番目のオブジェクトを返す。
     
     @return index番目のオブジェクト 存在しなければnull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject GetObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.get(index);
    }

    /**
     自身のリストの中からnameと一致する名前のオブジェクトを返す。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject GetObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return s;
            }
        }
        return null;
    }

    /**
     自身のリストに指定したオブジェクトが存在すれば削除する。
     
     @return 削除に成功した場合はtrueを返す。
     */
    public final boolean RemoveObject(SceneObject object) {
        return _objects.remove(object);
    }

    /**
     自身のリストのindex番目のオブジェクトを削除する。
     負数を指定した場合、後ろからindex番目のオブジェクトを削除する。
     
     @return index番目のオブジェクト 存在しなければNull
     @throws Exception indexがリストのサイズより大きい場合
     */
    public final SceneObject RemoveObject(int index) throws Exception {
        if (index >= _objects.size() || -index > _objects.size()) {
            throw new Exception("指定されたindexが不正です。 index : " + index);
        }
        if (index < 0) {
            index += _objects.size();
        }
        return _objects.remove(index);
    }

    /**
     自身のリストの中からnameと一致するオブジェクトを削除する。
     
     @return nameと一致する名前のオブジェクト 存在しなければNull
     */
    public final SceneObject RemoveObject(String name) {
        SceneObject s;
        for (int i=0; i<_objects.size(); i++) {
            s = _objects.get(i);
            if (s.GetName().equals(name)) {
                return _objects.remove(i);
            }
        }
        return null;
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
        return GetName().equals(s.GetName());
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append(getClass().getSimpleName()).append(" \n");
        b.append("  name : ").append(GetName()).append(" \n");
        b.append("  objects :\n");
        b.append(_objects).append(" \n");

        return b.toString();
    }
}