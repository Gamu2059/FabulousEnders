import java.io.*;

/**
 画像を一元管理するマネージャ。
 一度読み込まれたものは再度読み込むことをしないようにする。
 */
public final class ImageManager extends Abs_Manager {
    private HashMap<String, PImage> _images;
    private HashMap<String, PImage> GetImageHash() {
        return _images;
    }

    public ImageManager() {
        super();
        _images = new HashMap<String, PImage>();
    }

    public PImage GetImage(String path) {
        if (GetImageHash().containsKey(path)) {
            return GetImageHash().get(path);
        }
        PImage image = requestImage(path);
        if (image != null) {
            GetImageHash().put(path, image);
        }
        return image;
    }
}