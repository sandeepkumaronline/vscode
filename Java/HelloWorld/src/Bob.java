public class Bob extends Farmer {
    private String emotionalState;

    public Bob(String emotionalState, String crop) {
        super(crop);
        this.emotionalState = emotionalState;
    }
    public void getRaise() {
        System.out.println("gimme a raise!");
    }
    public String getEmotionalState() {
        return emotionalState;
    }
    public void setEmotionalState(String emotionalState) {
        this.emotionalState = new String(emotionalState);
    }
}