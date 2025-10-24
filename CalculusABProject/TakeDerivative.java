import java.util.Scanner;

public class TakeDerivative {
    public static void main(String[] args) 
    {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter a function (like 3x^2, e^x, 2^x, 1/x, ln(x)): ");
        String term = scanner.nextLine();
        term = term.replace(" ", ""); // makes so spaces don't mess up the function
        term = term.replaceAll("\\^-x", "^-1x").replaceAll("^-x", "-1x"); // makes so when you type -x, it doesn't mess up the program


        if (term.equals("ln(x)") || term.equals("lnx")) 
        {
            System.out.println("Derivative: 1/x");
        }


        else if (term.contains("e^")) 
        {
            int index = term.indexOf("^") + 1;
            String power = term.substring(index);

            if (power.equals("x")) 
            {
                System.out.println("Derivative: e^x");
            }

            else if (power.equals("-1x")) 
            {
                System.out.println("Derivative: -e^-x");
            }

            else if (power.endsWith("x")) 
            {
                String num = power.replace("x", "");
                System.out.println("Derivative: " + num + "e^" + num + "x");
            } 

            else 
            {
                System.out.println("can't do that yet lol");
            }
        }

        else if (term.contains("^x")) 
        {
            int powerIndex = term.indexOf("^");
            String base = term.substring(0, powerIndex);

            if (base.startsWith("-")) 
            {
                base = base.substring(1);
                System.out.println("Derivative: -ln(" + base + ")*" + base + "^x");
            } 

            else 
            {
                System.out.println("Derivative: ln(" + base + ")*" + base + "^x");
            }
        }


        else if (term.contains("/") && term.contains("x")) 
        {
            int xIndex = term.indexOf("x");
            String fraction = term.substring(0, xIndex);
            System.out.println("Derivative: -" + fraction + "x^2");
        }


        else if (term.contains("x")) 
        {
            int coefficient = 1;
            int exponent = 1;

            int xIndex = term.indexOf("x");
            if (xIndex > 0) 
            {
                coefficient = Integer.parseInt(term.substring(0, xIndex));
            }

            if (term.contains("^")) 
            {
                exponent = Integer.parseInt(term.substring(term.indexOf("^") + 1));
            }

            int newCoefficient = coefficient * exponent;
            int newExponent = exponent - 1;

            if (newExponent == 0) 
            {
                System.out.println("Derivative: " + newCoefficient);
            } 
            
            else if (newExponent == 1) 
            {
                System.out.println("Derivative: " + newCoefficient + "x");
            } 
            
            else 
            {
                System.out.println("Derivative: " + newCoefficient + "x^" + newExponent);
            }
        }


        else 
        {
            System.out.println("Derivative: 0");
        }

        scanner.close();
    }
}