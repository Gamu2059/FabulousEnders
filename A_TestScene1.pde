public class A_TestScene1 extends Scene {
    private float _rad;
    
    public A_TestScene1(String name) {
        super(name);
        GetDrawBack().GetBackColorInfo().SetColor(100, 200, 200);

        SceneObjectTransform objT1, objT2;

        SceneObject o = new SceneObject("camera?");
        AddObject(o);
        o.GetDrawBack().GetBackColorInfo().SetColor(200, 200, 0, 100);
        SetText(o);
        objT1 = o.GetTransform();
        objT1.SetSize(100, 100);
        objT1.GetAnchor().SetMin(0.5, 0.5);
        objT1.GetAnchor().SetMax(0.5, 0.5);

        SceneObject o1 = new SceneObject("Overlapped");
        AddObject(o1);
        o1.GetDrawBack().GetBackColorInfo().SetColor(0, 200, 200);
        SetImage(o1);
        SetButton(o1);
        objT2 = o1.GetTransform();
        objT2.SetParent(o.GetTransform(), true);
        objT2.SetSize(100, 140);
        objT2.GetAnchor().SetMin(0.5, 0.5);
        objT2.GetAnchor().SetMax(0.5, 0.5);
        objT2.GetPivot().SetPivot(0, 0);
    }

    private void SetImage(SceneObject o) {
        SceneObjectImage i = new SceneObjectImage();
        o.AddBehavior(i);
        i.SetUsingImageName("icon.png");
    }

    private void SetText(SceneObject o) {
        SceneObjectText t = new SceneObjectText("TestTestTestTestTestTestTestTest");
        o.AddBehavior(t);
        t.SetDrawInOrder(true);
        t.SetDrawSpeed(10);
        t.GetColorInfo().SetColor(0, 0, 200);
    }

    private void SetButton(SceneObject o) {
        SceneObjectButton b = new SceneObjectButton();
        o.AddBehavior(b);
        b.GetDicideHandler().AddEvent("pushed", new IEvent() {
            public void Event() {
                GetTransform().SetRotate(_rad += 1);
                sceneManager.LoadScene("main2");
                sceneManager.ReleaseScene("main1");
            }
        }
        );
    }
}