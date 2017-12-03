public class PEOSceneBase extends Scene {
    public PEOSceneBase(String name) {
        super(name);
    }

    protected void _SetTransform(SceneObject o, float minAX, float minAY, float maxAX, float maxAY, float pX, float pY, float sX, float sY) {
        if (o == null) return;
        SceneObjectTransform t = o.GetTransform();
        t.GetAnchor().SetMin(minAX, minAY);
        t.GetAnchor().SetMax(maxAX, maxAY);
        t.GetPivot().SetPivot(pX, pY);
        t.SetSize(sX, sY);
    }
    
    protected void _SetDragHandler(SceneObject o, IEvent dragEvent) {
        if (o == null) return;
        SceneObjectDragHandler dh = new SceneObjectDragHandler(GetName() + o.GetName() + " DragHandler Label");
        o.AddBehavior(dh);

        dh.GetEnabledActiveHandler().SetEvent("mouse entered", new IEvent() {
            public void Event() {
                cursor(MOVE);
            }
        }
        );
        dh.GetDisabledActiveHandler().SetEvent("mouse exited", new IEvent() {
            public void Event() {
                cursor(ARROW);
            }
        }
        );
        dh.GetDraggedActionHandler().SetEvent("mouse dragged", dragEvent);
    }
}