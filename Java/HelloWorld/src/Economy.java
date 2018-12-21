public class Economy {
    public static void main(String[] args) {
        Bob Joe = new Bob("happy", "cheese");
        Joe.setCrop("not telling");
        Joe.setEmotionalState("disillusioned");
        System.out.println(Joe.getEmotionalState());
        System.out.println(Joe.getCrop());
    }
}