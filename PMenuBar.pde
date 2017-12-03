/**
 メニューバーオブジェクト。
 */
public class PMenuBar extends SceneObject {
    private ArrayList<PMenu> _menus;

    private boolean _isStart;

    public PMenuBar(String name) {
        super(name);

        _menus = new ArrayList<PMenu>();

        SceneObjectDrawBack db = GetDrawBack();
        db.GetBackColorInfo().SetColor(255, 255, 255);
        db.SetEnableBorder(false);
    }

    public void AddMenu(PMenu menu) {
        if (menu == null) return;
        if (_menus.contains(menu)) return;
        _menus.add(menu);
    }

    public void Start() {
        // 自身の他の振る舞いに処理が行き渡るようにする
        super.Start();
        
        if (_isStart) return;
        _isStart = true;

        if (_menus == null) return;
        PMenu p;
        SceneObjectTransform tr;
        SceneObjectText t;
        float x, sum = 0;
        
        for (int i=0; i<_menus.size(); i++) {
            p = _menus.get(i);
            t = p.GetText();
            textFont(fontManager.GetFont(t.GetUsingFontName()));
            textSize(t.GetFontSize());
            textAlign(t.GetHorizontalAlign(), t. GetVerticalAlign());
            textLeading(t.GetLineSpace());

            x = textWidth(t.GetText());
            tr = p.GetTransform();
            tr.SetParent(GetTransform(), true);
            tr.SetSize(x, 0);
            tr.GetAnchor().SetMin(0, 0);
            tr.GetAnchor().SetMax(0, 1);
            tr.GetPivot().SetPivot(0, 0.5);
            tr.SetTranslation(sum, 0);
            sum += x;
        }
    }
}