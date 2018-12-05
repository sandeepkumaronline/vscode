import java.util.*;
import java.lang.*;

public class HelloWorld {

    public static void main(String[] args) {
        System.out.println(someCode(1, 2, 3));
    }

    public static int someCode(int a, int b, int c){
        if((a<b) && (b<c)) {
            return a;
        }
        if((a>=b) && (b>=c)) {
            return b;
        }
        if((a==b) || (a==c) || (b==c)) {
            return c;
        }
    }
}