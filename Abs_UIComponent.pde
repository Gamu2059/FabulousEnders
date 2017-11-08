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

    // 自身の描画用実トランスフォーム
    private UITransform _realTransform;
    public UITransform GetRealTransform() {
        return _realTransform;
    }

    // 描画トランスフォームが相対値パラメータであるかどうか
    private boolean _isRelative;
    public boolean IsRelative() {
        return _isRelative;
    }
    public void SetRelative(boolean value) {
        _isRelative = value;
    }

    // 自身の描画行列(これを呼び出すだけで一発で自身の描画が可能)
    private PMatrix2D _selfMatrix;
    public PMatrix2D GetSelfMatrix() {
        return _selfMatrix;
    }
    public void PushSelfMatrix() {
        getMatrix(_selfMatrix);
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


    public Abs_UIComponent(String componentName, UIScene scene) {
        super(componentName);

        if (scene != null) {
            scene.AddComponent(this);
        }
        _scene = scene;

        _transform = new UITransform();
        _realTransform = new UITransform();
        _parentAnchor = new UIAnchor();
        _selfAnchor = new UIAnchor();

        _selfMatrix = new PMatrix2D();

        _drawBack = true;
    }


    /**
     自身の相対トランスフォームを用いて基底次元で表現可能な実トランスフォームを計算する。
     */
    protected void TransformComponent(UITransform parent) {
        // 親コンポーネント指定
        if (!_isRelative) {
            parent = sceneTransform;
        }
        parent.CopyTo(_realTransform);

        float par1, par2;
        PVector gen1, gen2;

        // 基準へ移動
        par1 = GetParentAnchor().GetHorizontal();
        par2 = GetParentAnchor().GetVertical();
        gen1 = parent.GetSize();
        gen2 = parent.GetScale();
        Translate(_realTransform, par1 * gen1.x * gen2.x, par2 * gen1.y * gen2.y);

        // 自身の回転
        Rotate(_realTransform, _transform.GetRotate());
        // 自身のスケーリング
        Scale(_realTransform, _transform.GetScale());
        // 自身の平行移動
        par1 = GetSelfAnchor().GetHorizontal();
        par2 = GetSelfAnchor().GetVertical();
        gen1 = _transform.GetPosition();
        gen2 = _transform.GetSize();
        Translate(_realTransform, gen1.x - par1 * gen2.x, gen1.y - par2 * gen2.y);
    }

    /**
     実トランスフォームに任意の回転量を与える。
     */
    public void Rotate(UITransform real, float rotate) {
        float last = real.GetRotate() + rotate;
        real.SetRotate(last);
    }

    /**
     実トランスフォームに任意のスケール量を与える。
     */
    public void Scale(UITransform real, PVector scale) {
        Scale(real, scale.x, scale.y);
    }

    public void Scale(UITransform real, float x, float y) {
        PVector last = real.GetScale();
        last.x *= x;
        last.y *= y;
    }

    /**
     実トランスフォームに任意の平行移動量を与える。
     */
    public void Translate(UITransform real, PVector position) {
        Translate(real, position.x, position.y);
    }

    public void Translate(UITransform real, float x, float y) {
        PVector lP, lS;
        float lR, lX, lY, len;
        lP = real.GetPosition();
        lS = real.GetScale();
        lR = real.GetRotate();
        
        // この時点での最終平行移動量に角度での補正を掛ける
        lX = lP.x;
        lY = lP.y;
        len = sqrt(lX*lX+lY*lY);
        float rad = GeneralCalc.getRad(lX, lY, 0, 0) - lR;
        lP.set(len * cos(rad), len * sin(rad));
        
        // 相対平行移動量を求める
        lX = x * lS.x * cos(lR) - y * lS.y * sin(lR);
        lY = x * lS.x * sin(lR) + y * lS.y * cos(lR);
        real.SetPosition(lP.x + lX, lP.y + lY);
    }

    protected abstract void DrawComponent();

    /**
     自身の背景を描画する。
     */
    protected void DrawBack() {
        //if (!IsDrawBack()) {
        //    return;
        //}
        //// 親コンポーネント指定
        //UITransform par;
        //if (_isRelative) {
        //    Abs_UIBase base = GetParent();
        //    if (base instanceof UIScene) {
        //        par = sceneTransform;
        //    } else if (base instanceof Abs_UIComponent) {
        //        par = ((Abs_UIComponent) base)._transform;
        //    } else {
        //        return;
        //    }
        //} else {
        //    par = sceneTransform;
        //}

        //float par1, par2;
        //PVector gen1, gen2;

        //// 親の基準へ移動
        //par1 = GetParentAnchor().GetHorizontal();
        //par2 = GetParentAnchor().GetVertical();
        //gen1 = par.GetSize();
        //gen2 = par.GetScale();
        //translate(par1 * gen1.x / gen2.x, par2 * gen1.y / gen2.y);

        //// 自身の基準での回転
        //rotate(GetTransform().GetRotate());

        //// 自身の基準でのスケーリング
        //gen1 = GetTransform().GetScale();
        //scale(gen1.x, gen1.y);

        //// 自身の基準へ移動
        //par1 = GetSelfAnchor().GetHorizontal();
        //par2 = GetSelfAnchor().GetVertical();
        //gen1 = GetTransform().GetPosition();
        //gen2 = GetTransform().GetSize();
        //translate(-par1 * gen2.x + gen1.x, -par2 * gen2.y + gen1.y);

        //if (_drawBorder) {
        //    stroke(_borderColor);
        //    strokeWeight(_borderSize);
        //} else {
        //    noStroke();
        //}
        //fill(_backColor);
        //rect(0, 0, gen2.x, gen2.y);
    }

    /**
     与えられた座標が自身の描画領域内であれば、trueを返す。
     */
    protected boolean IsinRegion(float x, float y) {
        return false;
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