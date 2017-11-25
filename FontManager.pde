public final class FontManager {
    private HashMap<String, PFont> _fonts;
    private HashMap<String, PFont> GetFontHash() {
        return _fonts;
    }

    public FontManager() {
        _fonts = new HashMap<String, PFont>();
    }

    public PFont GetFont(String path) {
        if (GetFontHash().containsKey(path)) {
            return GetFontHash().get(path);
        }
        PFont font =  createFont(path, 100, true);
        if (font != null) {
            GetFontHash().put(path, font);
        }
        return font;
    }
}