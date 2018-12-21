import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

public class NumberTest {
    public static void main(String [] args) {
        Stack stack = new Stack();

        stack.push(new Integer(1));
        stack.push(new Integer(3));
        stack.pop();
        stack.push(new Integer(2));

        System.out.println(stack);
    }
}