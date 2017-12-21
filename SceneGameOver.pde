public final class SceneGameOver extends Scene {
    public SceneGameOver() {
        super("GameOver Scene");
        GetDrawBack().GetBackColorInfo().SetColor(255, 255, 255);
        GetDrawBack().SetEnable(true);
        SetScenePriority(1);
    }
}