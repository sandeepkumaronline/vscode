public class Number {
    private int value;

    public Number() {
        value = 0;
    }

    public Number(int num) {
        value = num;
    }

    public int SetVal(int n) {
        return value = n;
    }

    public String toString() {
        return ("Number: " + value);
    }
}