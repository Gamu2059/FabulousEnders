public final class ActionEvent {
    private HashMap<String, Event> _events;
    private HashMap<String, Event> GetEventHash() {
        return _events;
    }

    public ActionEvent() {
        _events = new HashMap<String, Event>();
    }

    public void AddEvent(String eventLabel, Event event) {
        if (!GetEventHash().containsKey(eventLabel) && event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }
    
    public void SetEvent(String eventLabel, Event event) {
        if (event != null) {
            GetEventHash().put(eventLabel, event);
        }
    }
    
    public Event GetEvent(String eventLabel) {
        return GetEventHash().get(eventLabel);
    }
    
    public Event RemoveEvent(String eventLabel) {
        return GetEventHash().remove(eventLabel);
    }
    
    public void RemoveAllEvents() {
        GetEventHash().clear();
    }
    
    public void InvokeEvent(String eventLabel) {
        Event e = GetEvent(eventLabel);
        if (e != null) {
            e.Event();
        }
    }
    
    public void InvokeAllEvents() {
        for (String label : GetEventHash().keySet()) {
            InvokeEvent(label);
        }
    }
}