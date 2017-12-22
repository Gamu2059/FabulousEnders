public final class PHash<R> {
    private HashMap<String, R> _elements;
    public HashMap<String, R> GetElements() {
        return _elements;
    }
    
    public PHash() {
        _elements = new HashMap<String, R>();    
    }
    
    public void Add(String label, R elem) {
        if (ContainsKey(label)) return;
        Set(label, elem);
    }
    
    public void Set(String label, R elem) {
        if (elem == null) return;
        GetElements().put(label, elem);
    }
    
    public R Get(String label) {
        return GetElements().get(label);
    }
    
    public R Remove(String label) {
        return GetElements().remove(label);
    }
    
    public void RemoveAll() {
        GetElements().clear();
    }
    
    public boolean ContainsKey(String label) {
        return GetElements().containsKey(label);
    }
}