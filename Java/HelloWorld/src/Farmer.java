public class Farmer {
    private String crop;

    public Farmer(String crop) {
        this.crop = crop;
    }
    public void setCrop(String crop) {
        this.crop = crop;
    }
    public String getCrop() {
        return crop;
    }
    public static void Farm() {
        System.out.println("Work the land. Feed the world");
    }
}