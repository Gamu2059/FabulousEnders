public final class ActionEvent {
    private PHash<IEvent> _events;
    public PHash<IEvent> GetEvents() {
        return _events;
    }

    public ActionEvent() {
        _events = new PHash<IEvent>();
    }

    public void InvokeEvent(String label) {
        IEvent e = _events.Get(label);
        if (e != null) {
            e.Event();
        }
    }

    public void InvokeAllEvents() {
        for (String label : _events.GetElements().keySet()) {
            InvokeEvent(label);
        }
    }
}