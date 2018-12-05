import java.util.*;
import java.lang.*;

public class Crypto {
// "THIS" (is) a <PrETtY> .Complicate?D str!nG, and I am <rying? to Te!st is full,y to. see HOW iT w?.Orks.
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");
        System.out.print("Please provide a string to encrypt: ");
        String text = input.nextLine();
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");

        String normalizedText = normalize(text);
        System.out.println("Normalized: " + normalizedText);
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");

        String obified = obify(normalizedText);
        System.out.println("Obified: " + obified);
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");

        String ceasarified = ceasarify(obified, 2);
        System.out.println("Ceasarfied: " + ceasarified);
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");

        String groupified = groupify(ceasarified, 2);
        System.out.println("Groupified: " + groupified);
        System.out.println("\n- - - - - - - - - - - - - - - - - - - - - -\n");
    }

    public static String normalize(String something) {
        something = something.replaceAll("[\\s\"()\\\\?:!.,{}<>~`]+", "");
        something = something.toUpperCase();
        return something;
    }

    public static String obify(String something) {
        String all = "";
        for (int i = 0; i < something.length(); i++) {
            char cur = something.charAt(i);
            if (List.of('A', 'E', 'I', 'O', 'U', 'Y').contains(cur)) {
                all += ("OB" + cur);
            } else {
                all += cur;
            }
        } return all;
    }

    public static String ceasarify(String something, int shift) {
        String result = "";
        int alphabet = 26;
        for (int i = 0; i < something.length(); i++) {
            char current = something.charAt(i);
            current += (char) shift;
            if (current > 'Z') {
                int plu = ((int) current % alphabet) - 13;
                current = (char) ('A' + plu);
            }
            result = result + current;
        } return result;
    }

    public static String groupify(String something, int gap) {
        int length = something.length();
        int additive = gap - (length % gap);
        String result = "";
        if(length % gap == 0) {
            if(length == gap) {
                result = result + something.substring(0, gap) + " ";
            } else {
                result = result + something.substring(0, gap) + " ";
                String newSomething = something.replace(something.substring(0, gap), "");
                result = result + " " + groupify(newSomething, gap);
                return result;
            }
        } else {
            StringBuilder addN = new StringBuilder();
            for (int i = 0; i < additive; i++) {
                addN.append("x");
            }
                something += addN;
                return groupify(something, gap);
            }
            return result;
        }
}
