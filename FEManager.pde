public class FEManager {
    private Config _config;
    public Config GetConfig() {
        return _config;
    }

    public FEManager() {
        _config = new Config();
    }
}