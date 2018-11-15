// Update greeting with user's name
var userName = window.prompt("Please enter your name: ");
document.getElementById("greeting").innerHTML += ", " + userName;

// Get numbers from user
var num1 = parseInt(window.prompt("Enter a number: "));
document.getElementById("operand1").innerHTML += num1;

var num2 = parseInt(window.prompt("Enter another number: "));
document.getElementById("operand2").innerHTML += num2;

// Operations
var sum = num1 + num2;
var difference = num1 - num2;
var product = num1 * num2;
var quotient = num1 / num2;
var modResult = num1 % num2;
var numbersString = num1 + " and " + num2 + " is: ";

// Display results
document.getElementById("addition").innerHTML = "The sum of " + numbersString + sum;
document.getElementById("subtraction").innerHTML = "The difference between " + numbersString + difference;
document.getElementById("multiplication").innerHTML = "The product of " + numbersString + product;
document.getElementById("division").innerHTML = "The quotient of " + numbersString + quotient;
document.getElementById("modulus").innerHTML = "The result of the mod operation on " + numbersString + modResult;
