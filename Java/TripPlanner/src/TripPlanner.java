import java.util.Scanner;

public class TripPlanner {


    public static void main(String[] args) {
        System.out.println("Welcome to Vacation Planner!");
        Intro();
        Budget();
        Time();
        Distance();
//        HackerProblem();
    }

    public static void Intro() {
        Scanner input = new Scanner(System.in);
        System.out.print("What is your name? ");
        String name = input.nextLine();
        System.out.print("Nice to meet you " + name + ", where are you travelling to? ");
        String destination = input.nextLine();
        System.out.println("Great! " + destination + " City sounds like a great trip");
        System.out.println("***********\n");
    }

    public static void Budget() {
        Scanner input = new Scanner(System.in);
        System.out.print("How many days are you going to spend travelling? ");
        int days = input.nextInt();
        System.out.print("How much money, in USD, are you planning to spend on your trip? ");
        double money = input.nextDouble();
        System.out.print("What is the three letter currency symbol for your travel destination? ");
        String currencySymbol = input.next();
        System.out.print("How many " + currencySymbol + " are there in 1 USD? ");
        double currency = input.nextDouble();
        System.out.println();
        System.out.println("If you are travelling for " + days + " day(s) that is the same as " + days * 24 + " hours or " + days * 1440 + " minutes");
        System.out.println("If you are going to spend $" + (int) money + " USD that means per day you can spend up to $" + money / days + " USD");
        System.out.println("Your total budget in " + currencySymbol + " is " + money * currency + " " + currencySymbol + ", which per day is " + (money * currency) / days + " " + currencySymbol);
        System.out.println("***********\n");
    }

    public static void Time() {
        Scanner input = new Scanner(System.in);
        System.out.println("Hint If the destination time zone is “behind” your home time zone you should enter a negative number.");
        System.out.print("What is the time difference between your home and where you are going? ");
        double timed = input.nextDouble();
        System.out.println("The time will be " + (24.00 + timed) % 24 + " in the destination when it is midnight at home \n and when it is noon at home: " + (12.00 + timed) % 24);
        System.out.println("***********\n");
    }

    public static void Distance() {
        Scanner input = new Scanner(System.in);
        System.out.print("What is the area of their travel destination country in km^2? ");
        double area = input.nextDouble();
        System.out.println("the area of the country in miles^2 is: " + area * 0.62137);
        System.out.println("***********\n");
    }

/*    public static void HackerProblem() {
        Scanner input = new Scanner(System.in);
        System.out.println("First I need your coordination's");
        System.out.print("Provide home's longitudes please");
        double lambda1 = input.nextDouble();
        System.out.print("Provide home's latitudes please");
        double phi1 = input.nextDouble();
        System.out.println("second I need your destination coordination's");
        System.out.print("Provide destination's longitudes please");
        double lambda2 = input.nextDouble();
        System.out.print("Provide destination's latitudes please");
        double phi2 = input.nextDouble();
        // the real math
        double lambda = Math.toRadians(lambda2 - lambda1);
        double phi = Math.toRadians(phi2 - phi1);
        phi1 = Math.toRadians(phi1);
        phi2 = Math.toRadians(phi2);
        double x = Math.pow(Math.sin(lambda / 2), 2) + Math.pow(Math.sin(phi / 2), 2) * Math.cos(phi1) * Math.cos(phi2);
        double c = 2 * Math.asin(Math.sqrt(x));
        double d = 6371.3 * c;
        System.out.println("the distance between home and destination is: " + d);
    }*/

}
