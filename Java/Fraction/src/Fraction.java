import java.util.*;

public class Fraction {
    private int numerator;
    private int denominator;

// CONSTRUCTORS
    public Fraction(int num, int den){
        if (den == 0) {
            // throw an IllegalArgumentException if the denominator is zero
            throw new IllegalArgumentException("Not possible to user denominator zero");
        } else if (den < 0){
            //If the user enters a negative denominator bump the negative sign to the numerator
            this.numerator = num *-1;
            this.denominator = den*-1;
        } else {
            this.numerator = num;
            this.denominator = den;
        }
    }

    public Fraction(int num){
        //one parameter constructor that initializes the object equal in value to the integer parameter
        this(num, 1);
    }

    public Fraction(){
        //zero parameter constructor that initializes the object to 0, meaning the numerator is 0 and the denominator is 1
        this(0);
    }

// METHODS
    public int getNumerator(){
        //exposes the value of the numerator field to the user
        return numerator;
    }

    public int getDenominator(){
        //exposes the value of the denominator field to the user
        return denominator;
    }

    public String toString(){
        //"numerator/denominator", a String representation of the Fraction
        return numerator+"/"+denominator;
    }

    public double toDouble(){
        //the result of numerator / denominator
        return numerator/denominator;
    }

    public Fraction add(Fraction other){
        //returns a new Fraction that is the sum of other and this fraction
        Fraction newFrac= new Fraction(((this.numerator*other.denominator)+(other.numerator*this.denominator)),(this.denominator*other.denominator));
        newFrac.toLowestTerms();
        return newFrac;
    }

    public Fraction subtract(Fraction other){
        //returns a new Fraction that is the difference between the other and this fraction
        Fraction newFrac= new Fraction(((this.numerator*other.denominator)-(other.numerator*this.denominator)),(this.denominator*other.denominator));
        newFrac.toLowestTerms();
        return newFrac;
    }

    public Fraction multiply(Fraction other){
        //returns a new Fraction that is the product of the other and this fraction
        Fraction newFrac= new Fraction((this.numerator*other.numerator),(this.denominator*other.denominator));
        newFrac.toLowestTerms();
        return newFrac;
    }

    public Fraction divide(Fraction other){
        // returns a new Fraction that is the division of the other and this fraction, throw an IllegalArgumentException() if the user asks you to divide by 0
        if (other.numerator==0){
            throw new IllegalArgumentException();
        } else {
            Fraction newFrac = new Fraction((this.numerator*other.denominator),(this.denominator*other.numerator));
            newFrac.toLowestTerms();
            return newFrac;
        }
    }

    public boolean equals(Object other){
        //must take in an "Object" to properly override the Object class's equals method, but should ultimately check if two fractions are equal
        if (other instanceof Fraction){
            Fraction otherNew = (Fraction) other; //casting other to Fraction
            otherNew.toLowestTerms();

            Fraction thisFrac = new Fraction(this.numerator,this.denominator);
            thisFrac.toLowestTerms();

            return (thisFrac.numerator == otherNew.numerator) && (thisFrac.denominator == otherNew.denominator);
        } else {
            throw new InputMismatchException("Fraction expected.");
        }
    }

    public void toLowestTerms(){
        //converts the current fraction to the lowest terms
        int gcd = gcd(this.numerator,this.denominator);

        numerator = this.numerator/gcd;
        denominator = this.denominator/gcd;
    }

    public int gcd(int num, int den){
        //takes in two ints and determines the greatest common divisor of the two ints, should be a static method
        while (num != 0 && den != 0){
            int remainder = num%den;
            num = den;
            den = remainder;
        }
        return num;
    }
}
