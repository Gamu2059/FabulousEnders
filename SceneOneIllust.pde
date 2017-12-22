/**
 背景に配置する一枚絵だけを表示するシーン。
 */
public final class SceneOneIllust extends Scene {
    private SceneObjectImage _backImage;
    public SceneObjectImage GetBackImage() {
        return _backImage;
    }

    public SceneOneIllust() {
        super(SceneID.SID_ILLUST);
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);

        SceneObject obj = new SceneObject("Background", this);
        _backImage = new SceneObjectImage(obj, null);
        
        SceneObjectTimer timer = new SceneObjectTimer(obj);
        timer.GetTimers().Add("hoge", new ITimer(){
            public void OnInit() {
                println(111);
                _backImage.SetUsingImageName(null);
            }
            
            public void OnTimeOut() {
                println("done");
                _backImage.SetUsingImageName("gameover/back.png");
            }
        });
    }

    public void OnEnabled() {
        super.OnEnabled();
        
        SceneObject o = GetObject("Background");
        SceneObjectTimer t = (SceneObjectTimer)o.GetBehaviorOnID(ClassID.CID_TIMER);
        t.ResetTimer("hoge", 1);
        t.Start("hoge");
    }

    public void OnDisabled() {
        super.OnDisabled();
    }
}