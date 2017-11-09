/**
 シーンに追加できるコンポーネントの基底クラス。
 */
public abstract class Abs_UIComponent extends Abs_UIBase {
    private UIScene _scene;
    public UIScene GetScene() {
        return _scene;
    }

    // 自身の描画用相対トランスフォーム
    private UITransform _transform;
    public UITransform GetTransform() {
        return _transform;
    }

    //// 自身の描画用実トランスフォーム
    //private UITransform _realTransform;
    //public UITransform GetRealTransform() {
    //    return _realTransform;
    //}

    private PMatrix2D _matrix;
    public PMatrix2D GetMatrix() {
        return _matrix;
    }
    public void PushMatrix() {
        getMatrix(_matrix);
    }

    // 描画トランスフォームが相対値パラメータであるかどうか
    private boolean _isRelative;
    public boolean IsRelative() {
        return _isRelative;
    }
    public void SetRelative(boolean value) {
        _isRelative = value;
    }

    // 親のアンカー情報
    private UIAnchor _parentAnchor;
    public UIAnchor GetParentAnchor() {
        return _parentAnchor;
    }
    public void SetParentAnchor(int value) {
        _parentAnchor.SetAnchor(value);
    }

    // 自身のアンカー情報
    private UIAnchor _selfAnchor;
    public UIAnchor GetSelfAnchor() {
        return _selfAnchor;
    }
    public void SetSelfAnchor(int value) {
        _selfAnchor.SetAnchor(value);
    }

    // 自身の背景を描画するかどうか
    private boolean _drawBack;
    public boolean IsDrawBack() {
        return _drawBack;
    }
    public void SetDrawingBack(boolean value) {
        _drawBack = value;
    }

    // 背景色
    private color _backColor;
    public color GetBackColor() {
        return _backColor;
    }
    public void SetBackColor(color value) {
        _backColor = value;
    }

    // ボーダを描画するかどうか
    private boolean _drawBorder;
    public boolean IsDrawBorder() {
        return _drawBorder;
    }
    public void SetDrawBorder(boolean value) {
        _drawBorder = value;
    }

    // ボーダ色
    private color _borderColor;
    public color GetBorderColor() {
        return _borderColor;
    }
    public void SetBorderColor(color value) {
        _borderColor = value;
    }

    // ボーダサイズ
    private int _borderSize;
    public int GetBorderSize() {
        return _borderSize;
    }
    public void SetBorderSize(int value) {
        _borderSize = value;
    }

    // 描画不可能かどうか
    private boolean _isDisableDraw;

    public Abs_UIComponent(String componentName, UIScene scene) {
        super(componentName);

        try {
            if (scene != null) {
                scene.AddComponent(this);
            }
            _scene = scene;

            _transform = new UITransform();
            //_realTransform = new UITransform();
            _matrix = new PMatrix2D();
            _parentAnchor = new UIAnchor();
            _selfAnchor = new UIAnchor();

            _drawBack = true;
        } 
        catch(Exception e) {
        }
    }


    /**
     自身の相対トランスフォームを用いて基底次元で表現可能な実トランスフォームを計算する。
     */
    protected void TransformComponent() {
        _isDisableDraw = !matrixManager.PushMatrix();
        if (_isDisableDraw) {
            return;
        }

        // 親コンポーネント指定
        UITransform par;
        if (_isRelative) {
            Abs_UIBase base = GetParent();
            if (base instanceof UIScene) {
                par = sceneTransform;
            } else if (base instanceof Abs_UIComponent) {
                par = ((Abs_UIComponent) base)._transform;
            } else {
                return;
            }
        } else {
            par = sceneTransform;
        }

        float par1, par2;
        PVector gen1, gen2;

        // 親の基準へ移動
        par1 = GetParentAnchor().GetHorizontal();
        par2 = GetParentAnchor().GetVertical();
        gen1 = par.GetSize();
        gen2 = par.GetScale();
        translate(par1 * gen1.x / gen2.x, par2 * gen1.y / gen2.y);

        // 自身の基準での回転
        rotate(GetTransform().GetRotate());

        // 自身の基準でのスケーリング
        gen1 = GetTransform().GetScale();
        scale(gen1.x, gen1.y);

        // 自身の基準へ移動
        par1 = GetSelfAnchor().GetHorizontal();
        par2 = GetSelfAnchor().GetVertical();
        gen1 = GetTransform().GetPosition();
        gen2 = GetTransform().GetSize();
        translate(-par1 * gen2.x + gen1.x, -par2 * gen2.y + gen1.y);

        try {
            if (super.GetChildren() != null) {
                Abs_UIBase base;
                for (int i=0; i<GetChildren().size(); i++) {
                    base = GetChildren().get(i);
                    if (base instanceof Abs_UIComponent) {
                        ((Abs_UIComponent) base).TransformComponent();
                    }
                }
            }
        } 
        catch(Exception e) {
        }
        PushMatrix();
        matrixManager.PopMatrix();
    }


    protected abstract void DrawComponent();

    /**
     自身の背景を描画する。
     */
    protected void DrawBack() {
        if (!_drawBack) {
            return;
        }

        PVector size = GetTransform().GetSize();

        resetMatrix();
        setMatrix(GetMatrix());

        if (IsDrawBorder()) {
            stroke(GetBorderColor());
            strokeWeight(GetBorderSize());
        } else {
            noStroke();
        }
        fill(GetBackColor());

        rect(0, 0, size.x, size.y);
    }

    /**
     与えられた座標が自身の描画領域内であれば、trueを返す。
     */
    protected boolean IsinRegion(float... parameters) throws Exception {
        if (parameters.length != 2) {
            throw new Exception("引数のパラメータ数が不正です。");
        }

        PMatrix2D inv = GetMatrix().get();
        if (!inv.invert()) {
            throw new Exception("逆アフィン変換が行えません。");
        }

        float[] out = new float[2];
        inv.mult(parameters, out);
        PVector size, scale;
        size = GetTransform().GetSize();
        scale = GetTransform().GetScale();
        float w, h;
        w = size.x * scale.x;
        h = size.y * scale.y;

        return 0 <= out[0] && out[0] < w && 0 <= out[1] && out[1] < h;
    }

    /**
     MOCになった瞬間に呼び出される。
     */
    protected void ComponentEntered() {
    }

    /**
     MOCでなくなった瞬間に呼び出される。
     */
    protected void ComponentExited() {
    }

    /*
    MACになった瞬間に呼び出される。
     **/
    protected void ComponentEnabled() {
    }

    /**
     MACでなくなった瞬間に呼び出される。
     */
    protected void ComponentDisabled() {
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        b.append("Abstract UIComponent : ").append(super.GetName());
        return b.toString();
    }
}