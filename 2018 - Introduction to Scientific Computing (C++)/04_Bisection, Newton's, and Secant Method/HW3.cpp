//Abelardo Riojas FSUID ar18aa
//ISC3313 Homework 3 Questions 1, 2, and 3
#include<iostream>
#include<cmath>
#include<iomanip>
#include<stdlib.h>
#include<math.h>
using namespace std;

float a, b, x, nx;
// this is a function to ask the user for the interval because I was lazy and didn't want to copy past a bunch of code
void ask () {
    cout << endl << "Please enter the points you would like to evaluate the function at: " << endl << "a: ";
	cin >> a;
	cout << "b: ";
	cin >> b;
}
// this is the main function function
float f(float x) {
  return log(x) + (x*x) - 6;
}
// this a fucntion that serves as the derivative of the function for newtons method
float fp(float x) {
    return 2 * x + (1/x);
}
// this function checks if you have valid bisection method intervals
bool validbisectionInput(float a, float b) {
  float fa = f(a);
  float fb = f(b);
  //for bisection method, you want two numbers that evaluate to different signs, this means the product of fa and fb has to be negative
  if (fa * fb < 0) {
   return true;
  }
  else  {
    return false;
    }
}

//this function does the bisectionmethod for you
float bisectionMethod(float a, float b) {
    // this while loop runs until the absolute value of the difference between a and b is basically 0 (we're at the root!)
  while (abs(a - b) >= .000001) {
    float c = (float)(a + b) / 2;
    float fc = f(c);
    // if f(c) evaluates to a negative number, we make a the new c
    // "but wait, abelardo, what if the user doesn't input an a value that orginally evaluates to a negative number?!?!" <-- that's you, future abelardo, reading this
    // "that's where we put an if statement in main that switches a and b if b evaluates negative and a evaluates positive" <--- that's me, past abelardo, telling you
    if (fc < 0) {
      a = c;
    }
    // if f(c) evaluates to a postive number, we make b the the c
    else if (fc > 0) {
      b = c;
    }
    // and then we iterate
    while (abs(a-b) <= .000001) {
        // once we're at the root, we tell the function that it returns c
        return c;
        }
    }   

}
// this function does newtons method for you
float newtonsMethod (float x) {
    float nx;
    // while the abs of the root is far away from 0
    while (abs(f(x)) >= .000001) {
    // you can make sense of this algorithm part if you read the explantion in the solving equations lecture notes
    nx = x + -f(x)/fp(x);
    // it makes x the new nx
    x = nx;
    }
    while (f(x) <= .000001) {
        return nx;
    }
}

float secantMethod(float a, float b) 
{ 
    float intVal; 
    // while a and be are not close and we have a positive and negative value
	while (abs(a - b) >= .00001 && f(a) * f(b) < 0) {
            // calculate the intermediate value 
            intVal = (float)((a * f(b)) - (b * f(a))) / (f(b) - f(a)); 
            a = b; 
            b = intVal; 
            //throw away the oldest
	}
	return intVal;
}

int main () {
  int method;
  cout << "With what method would you like to evaluate your function at?" << endl << "Input 1 for bisection method" << endl << "Input 2 for Newton's method" << endl << "Input 3 for secant method" << endl;
  cout << "Your method: ";
  cin >> method;
  // check for invalid input
 while (cin.fail()) {
    cin.clear();
    cin.ignore();
    cout << "With what method would you like to evaluate your function at?" << endl << "Input 1 for bisection method" << endl << "Input 2 for Newton's method" << endl << "Input 3 for secant method" << endl;
    cout << "Your method: ";
    cin >> method;
 }
 // if it's the first method we run bisection method
  if (method == 1) {
  ask();
  while (cin.fail()) {
    cin.clear();
    cin.ignore();
    ask();
    }
  // switch commands for a and b if a > 0 and b < 0
  if (f(a) > 0 && f(b) < 0) {
      float switcha, switchb;
      switcha = a;
      switchb = b;
      a = switchb;
      b = switcha;
  }
  // we have to check if the interval even contains a zero with valid bisection input
  if (validbisectionInput(a,b)) {
      // if it is, then we tell it to print out the output of bisectionMethod with a and b as it's inputs
    cout << endl << "the root of this function is: " << fixed << setprecision(6) << bisectionMethod(a,b) << endl;
    return 0;
  }
  else {
      // otherwise, we tell the user there's no roots!
    cout << endl <<  "There are no roots in this interval" << endl;
    return 0;
  }
}
// if method == 2 then we run secant method
  else if (method == 2) {
  cout << "Please input the value you want to evalue the function at: " << endl << "x: ";
  cin >> x;
      while (cin.fail()) {
        cin.clear();
        cin.ignore();
          cout << "Please input the value you want to evalue the function at: " << endl << "x: ";
          cin >> x;
      }
      //if we have a straight line for x, that won't work so we have to have a new x values
	  while (f(x) == (f(x) + 100)) {
		  cout << "This value won't work, try antoher one" << endl;
		  cin >> x;
	  }
        
  cout << "The root for newtwons method is " << newtonsMethod(x) << endl;
  return 0;
}
// "If method == 3 we run secant method"
  else if (method == 3) {
    ask();
    while (cin.fail()) {
        cin.clear();
        cin.ignore();
        ask();
    }
	if (f(a) * f(b) > 0) {
	  cout << endl << "There are no roots in this interval" << endl;
	    return 0;
	}
	cout << endl << "The root of this function is " << fixed << setprecision(6) << secantMethod(a, b) << endl; 
    return 0; 
  }
  // if they input an invalid int for the first question then we kick out the the neverdowell
  else {
      cout << "That wasn't one of the methods bro";
  }
}
