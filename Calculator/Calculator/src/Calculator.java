import java.awt.*; //for GUI layout, colors, and fonts
import java.awt.event.*; //for handling events like button clicks
import java.util.Arrays; //for using array method in java utilities
import javax.swing.*; //for Swing components like JFrame, JPanel, JButton, etc
import javax.swing.border.LineBorder; //for adding borders to buttons

public class Calculator {
    int windowWidth = 360; //width of window
    int windowHeight = 540; //height of window

    Color customLightGray = new Color(212, 212, 210); //custom gray color
    Color customDarkGray = new Color(80, 80, 80); //custom dark gray
    Color customBlack = new Color(28, 28, 28); //custom black
    Color customPurple = new Color(143, 78, 255); //custom purple

    String[] buttonValues = { //button values
        "AC", "+/-", "%", "÷", 
        "7", "8", "9", "×", 
        "4", "5", "6", "-",
        "1", "2", "3", "+",
        "0", ".", "√", "="
    };
    String[] rightSymbols = {"÷", "×", "-", "+", "="}; //symbols on right
    String[] topSymbols = {"AC", "+/-", "%"}; //symbols on top

    JFrame frame =  new JFrame("Calculator"); //the window itself (JFrame) with calculator as the name
    JLabel displayLabel = new JLabel(); //label for the text
    JPanel displayPanel = new JPanel(); //panel for the label
    JPanel buttonsPanel = new JPanel(); //buttons panel

    //These variables set the initial values before the user inputs anything that changes them
    String num1 = "0"; //variable that keeps track of the first number 
    String operator = null; //variable thatkeeps track of the operator
    String num2 = null; //variable that keeps track of the second number the user inputs
    //A+B, A-B, A*B, A/B

    Calculator() { //constructor class for window properties
        try {
            UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName()); //forces java to use its own neutral theme the user's operating system’s buttons, before this statement was added, the buttons were all white and the custom colors didn't apply. this wasn't in the guide
        } 
        catch (Exception e) { //catches the error and instead of crashing, the program runs the catch statement. e is just a common variable programmers use
            e.printStackTrace(); //gives name of the error (like ClassNotFoundException) and stack trace showing where the error happened in the code.
        }

        //frame.setVisible(true); //true so the window is visible, this statement is movement down all the way below
        frame.setSize(windowWidth, windowHeight); //frame size is same as window width and height
        frame.setLocationRelativeTo(null); //setting location to null centers the window when the user opens the application
        frame.setResizable(true); //false makes it so the user cannot resize the window in any way
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); //makes it so when the user clicks on the x button the program will be terminated (closed)
        frame.setLayout(new BorderLayout()); //BorderLayout makes it so you can place stuff within the window

        displayLabel.setBackground(customBlack); //label background color
        displayLabel.setForeground(Color.white); //text (foreground) color
        displayLabel.setFont(new Font("Arial", Font.PLAIN, 80)); //font for the label; font, formatting, size
        displayLabel.setHorizontalAlignment(JLabel.RIGHT); //offsets text to the right
        displayLabel.setText("0"); //sets default text
        displayLabel.setOpaque(true); //true makes label opaque

        displayPanel.setLayout(new BorderLayout()); //setting the layout
        displayPanel.add(displayLabel); //putting the text label inside the panel
        frame.add(displayPanel, BorderLayout.NORTH); //putting the panel in our window, display panel offset to top of window

        buttonsPanel.setLayout(new GridLayout(5, 4)); //grid panel; 5 rows, 4 columns
        buttonsPanel.setBackground(customBlack); //button background
        frame.add(buttonsPanel, BorderLayout.CENTER); //adds button panel to window and centers it

        for (int i = 0; i < buttonValues.length; i++) { //for loop that correlates to the buttonValues array and makes new button
            JButton button = new JButton(); //creates new Jbutton instance
            String buttonValue = buttonValues[i]; //gets the button's label from the array
            button.setFont(new Font("Arial", Font.PLAIN, 30)); //font, formatting, size
            button.setText(buttonValue); //sets the button display text
            button.setFocusable(false); //makes the retangular border around the button characters invisible
            button.setBorder(new LineBorder(customBlack)); //button border color
            button.setOpaque(true); //makes the button opaque

            if (Arrays.asList(topSymbols).contains(buttonValue)) { //if statement; if the symbol in the for loop is a part of the topSymbols array, run code inside
                button.setBackground(customLightGray); //button color
                button.setForeground(customBlack); //font (foreground) color
            }
            else if (Arrays.asList(rightSymbols).contains(buttonValue)) { //else if statement; same as the if statement but for rightSymbol arrays instead
                button.setBackground(customPurple); //button color
                button.setForeground(Color.white); //font (foreground) color
            }
            else { //if it's none of the above, run code below
                button.setBackground(customDarkGray); //button color
                button.setForeground(Color.white); //font (foreground) color
            }
            
            buttonsPanel.add(button); //adds the button to the panel

            button.addActionListener(new ActionListener() { //adds an action listener that handles button clicks
                public void actionPerformed(ActionEvent e) { //method is called when said button is clicked
                    JButton button = (JButton) e.getSource(); //gets the button that was clicked
                    String buttonValue = button.getText(); //gets the text of the clicked button
                    if (Arrays.asList(rightSymbols).contains(buttonValue)) {
                        if (buttonValue == "=") { //if = is clicked
                            if (num1 != null) { //if the first number the user inputs isn't equal to null, run code below
                                num2 = displayLabel.getText();
                                double numFirst = Double.parseDouble(num1); //turns string num1 into double numFirst
                                double numSecond = Double.parseDouble(num2); //turns string num2 into double numSecond

                                if(operator == "+") { //if operator is addition, run code below
                                    displayLabel.setText(removeZeroDecimal(numFirst+numSecond));
                                }
                                else if (operator == "-") { //if operator is subtraction, run code below
                                    displayLabel.setText(removeZeroDecimal(numFirst-numSecond));
                                }
                                else if(operator == "×") { //if operator is multiplication, run code below
                                    displayLabel.setText(removeZeroDecimal(numFirst*numSecond));
                                }
                                else if(operator == "÷") { //if operator is division, run code below
                                    displayLabel.setText(removeZeroDecimal(numFirst/numSecond));
                                }
                                clearAll(); //clear all function

                            }
                       }
                       else if ("+-×÷".contains(buttonValue)) { //if operators are clicked
                            if (operator == null) { //if the operator variable is still null, run code below
                                num1 = displayLabel.getText(); //saves the first user input number to num1 variable
                                displayLabel.setText("0"); //resets the display and shows 0 again
                                num2 = "0"; //gives num2 variable a string value of "0"
                            }
                            operator = buttonValue; //makes it so if the user clicks another operator, it doesn't run the code above again, it only changes the operator, i.e. if 12 x 3 is clicked and the user clicks the + button, it only changes the operator value to +, so now the equation is 12 + 3
                       }
                    }
                    else if (Arrays.asList(topSymbols).contains(buttonValue)) {
                        if (buttonValue == "AC") { //if AC is clicked
                            clearAll(); //clear all function, code is down all the way below
                            displayLabel.setText("0");
                        }
                        else if (buttonValue == "+/-") { //if +/- is clicked
                            double numDisplay = Double.parseDouble(displayLabel.getText()); //gets the string and converts that into a double
                            numDisplay *= -1; //multiplies the number by -1
                            displayLabel.setText(removeZeroDecimal(numDisplay)); //remove zero decimal function, code is down all the way below
                        }
                        else if (buttonValue == "%") { //if % is clicked
                            double numDisplay = Double.parseDouble(displayLabel.getText()); //gets the string and converts that into a double
                            numDisplay /= 100; //divides the number by 100
                            displayLabel.setText(removeZeroDecimal(numDisplay)); //remove zero decimal function, code is down all the way below
                        }
                    }
                    else { //digits or
                        if (buttonValue == ".") { //if . is clicked
                            if (!displayLabel.getText().contains(buttonValue)) { //if the display doens't have a "." then it will display it. if there already is a "." in the number, it won't register
                                displayLabel.setText(displayLabel.getText() + buttonValue);
                            }
                        }
                        else if ("0123456789".contains(buttonValue)) { //if any of the digits are clicked
                            if (displayLabel.getText() == "0") { //if the current display label text is a 0, run code below
                                displayLabel.setText(buttonValue); //i.e. 05 becomes 5
                            }
                            else {
                                displayLabel.setText(displayLabel.getText() + buttonValue); //clicking 5 2 times will be 55, works smoothly
                            }
                        }
                        else if (buttonValue == "√") {
                            double numDisplay = Double.parseDouble(displayLabel.getText()); //gets the string and converts that into a double
                            numDisplay = Math.sqrt(numDisplay); //gets the square root of the number
                            displayLabel.setText(removeZeroDecimal(numDisplay)); //remove zero decimal function, code is down all the way below
                        }
                    }
                }
            });
            frame.setVisible(true); //set last so the program runs more optimally
        }
    }

    void clearAll() { //clear all function resets the variables to their initial values
        num1 = "0";
        operator = null;
        num2 = null;

    }

    String removeZeroDecimal(double numDisplay) {
        if (numDisplay % 1 == 0) { //if the number is a whole number, run code below
            return Integer.toString((int) numDisplay); //converts the number to an integer and returns it as a string
        }
        return Double.toString(numDisplay);
    }
}