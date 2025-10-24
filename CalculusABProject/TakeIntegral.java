import java.util.Scanner;

public class TakeIntegral 
{
    public static void main(String[] args) 
    {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a polynomial with only one term like 3x^2: ");
        String term = scanner.nextLine();

        int coefficient = 1;
        int exponent = 1;

        if (term.contains("x")) 
        {
            int indexOfX = term.indexOf("x");
            String coefficientStr = term.substring(0, indexOfX);
            if (!coefficientStr.isEmpty()) 
            {
                coefficient = Integer.parseInt(coefficientStr);
            }

            if (term.contains("^")) 
            {
                int powerIndex = term.indexOf("^");
                String exponentStr = term.substring(powerIndex + 1);
                exponent = Integer.parseInt(exponentStr);
            } 
            
            else 
            {
                exponent = 1;
            }

            int newExponent = exponent + 1;
            double newCoefficient = (double) coefficient / newExponent;


            if (newCoefficient == 1.0) {
                System.out.println("Integral: x^" + newExponent + " + C");
            } 
            
            else if (newCoefficient == -1.0) 
            {
                System.out.println("Integral: -x^" + newExponent + " + C");
            } 
            
            else 
            {
                System.out.println("Integral: " + newCoefficient + "x^" + newExponent + " + C");
            }
        } 
        
        else 
        {
            double newCoefficient = (double) coefficient;
            System.out.println("Integral: " + newCoefficient + "x + C");
        }
    }
}