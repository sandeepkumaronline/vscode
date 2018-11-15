var userName = window.prompt("Please enter your name: ");
document.getElementById("greeting").innerHTML += ", " + userName;

var num1 = parseInt(window.prompt("Enter a number: "));
document.getElementById("operand1").innerHTML += num1;

var num2 = parseInt(window.prompt("Enter another number: "));
document.getElementById("operand2").innerHTML += num2;

var sum = num1 + num2;
document.getElementById("addition").innerHTML = "The sum of " + num1 + " and " + num2 + " is: " + sum;

var difference = num1 - num2;
document.getElementById("subtraction").innerHTML = "The difference of " + num1 + " and " + num2 + " is: " + difference;

var product = num1 * num2;
document.getElementById("multiplication").innerHTML = "The product of " + num1 + " and " + num2 + " is: " + product;

var quotient = num1 / num2;
document.getElementById("division").innerHTML = "The quotient of " + num1 + " and " + num2 + " is: " + quotient;

var modResult = num1 % num2;
document.getElementById("modulus").innerHTML = "The modResult of " + num1 + " and " + num2 + " is: " + modResult;

