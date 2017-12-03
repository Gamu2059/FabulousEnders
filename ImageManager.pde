public final class ImageManager {
    private HashMap<String, PImage> _images;
    private HashMap<String, PImage> GetImageHash() {
        return _images;
    }

    public ImageManager() {
        _images = new HashMap<String, PImage>();
    }

    public PImage GetImage(String path) {
        path = PConst.IMAGE_PATH + path;
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