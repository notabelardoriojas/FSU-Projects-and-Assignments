//Abelardo Riojas FSUID ar18aa
//ISC 3313 Homework 5
#include<iostream>
#include<cmath>
#include<iomanip>
#include<stdlib.h>
#include<math.h>

class myMath {
int N;
int iterations = 0;
double E = .000001;
public:
double f(double x) {

  return  log(x) + (x*x) - 6;
}

double fp(double x) {
    return 2 * x + (1/x);
}

bool validbisectionInput(double a, double b) {
  double fa = f(a);
  double fb = f(b);
  if (fa * fb < 0) {
   return true;
  }
  else  {
    return false;
    }
}

double bisectionMethod(double a, double b) {
  iterations = 0;
  while (abs(a - b) >= E) {
  double c = (a + b) / 2;
    if (validbisectionInput(b,c)) {
      a = c;
      iterations++;
    }
    else  if (validbisectionInput(a,c)) {
		b = c;
		iterations++;
	}
    if (abs(a-b) <= E) {
     return c;   
    }
}
}

double newtonsMethod (double x) {
    iterations = 0;
    while (abs(f(x)) >= E) {
    double nx = x + -f(x)/fp(x);
    x = nx;
	iterations++;
	while (abs(f(x)) <=  E) {
	    return nx;
	}
    } 
}

double secantMethod(double a, double b) {
  iterations = 0;
    double intVal; 
	while (abs(a - b) >= E && validbisectionInput(a,b)) {
            // calculate the intermediate value 
            intVal = (double)((a * f(b)) - (b * f(a))) / (f(b) - f(a)); 
 
            a = b; 
            b = intVal; 
			iterations++;
	}
	return intVal;
}


double rectRiemannSum(double a, double b, double N) {
  double sum = 0;
  double width = (b-a)/N;
  for (int i = 0; i < N; i++)
    {
      double height = f(a + width*i);
      sum += height * width;
    }
  return sum;
}

double trapRiemannSum(double a, double b, double N) {
  double sum = 0;
  int e = 1;
  double width = (b-a)/N;
  for (int i = 0; i < N; i++)
    {
      double leftheight = f(a + width*i);
      double rightheight = f(a + width*e);
      sum += (leftheight + rightheight) /2  * width;
      e++;
    }
  return sum;
}

int maximumf (float a, float b){
float maxf = f(a);
float increment = .01;
while ((a+increment) <= b){
float c = f(a + increment);
if (c > maxf) {
maxf = c;
}
increment += .01;
if (a+increment > b) {
return maxf + 1;
}
}
}

int minimumf (float a, float b){
float minf = f(a);
float increment = .01;
while ((a+increment) <= b){
float c = f(a + increment);
if (c < minf) {
minf = c;
}
increment += .01;
if (a+increment > b) {
return minf;
}
}
}

float badmontecarlo(int a, int b, int points) {

int inpoints = 0;
int countedpoints = 0;
int minF = minimumf(a,b);
int maxF = maximumf(a,b);
while (countedpoints <= points) {
//generation of x y points
float randX = (rand() % (b - a) + a) + (float)rand()/RAND_MAX;
float randY = (rand() % (maxF - minF) + minF) + (float)rand()/RAND_MAX;
// cout << "random x point: " << randX << " random y point: " << randY << endl;
if(abs(f(randX)) >= abs(randY) && f(randX) >= 0) {
inpoints++;
//cout << "inpoints increased by one" << endl;
}
else if(abs(f(randX)) >= abs(randY) && f(randX) <= 0 ) {
inpoints--;
//cout << "inpoints decreased by one" << endl;
}
countedpoints++;
if (countedpoints >= points) {
  std:: cout << std::endl << "inpoints: " << inpoints << std::endl << "countedpoints: " << countedpoints << std::endl;
  return (float)inpoints/points * (b-a) * (maximumf(a,b) - minimumf(a,b));
}
}
}



void getIterations () {
	std::cout << std::endl<< "The number of iterations needed to reach this particular root was " << iterations << std::endl;
}
	
} ;

int main () {
    int N;
    int points;
    double a,b;
    std::string str;
    myMath root, sum;
	std::cout << "This is a program that verifies that myMath's methods are functioning" << std::endl;
	std::cout << "Do you want to find the root of a function or the approximate integral?" << std::endl << "Please input either 'root' or 'integral': ";
	std::cin >> str;
	if (str == "root") {
		std::cout << "How do you want to find the root of this function?" << std::endl;
		std::cout << "Please input 'bisection', 'Newtons', or 'secant'." << std::endl;
		std::cin >> str;
		if (str == "bisection") {
			std::cout <<  "Please input the interval you want to evaluate the function at: " << std::endl << "a: ";
			std::cin >> a;
			std::cout << std::endl << "b: ";
			std::cin >> b;
			if (root.validbisectionInput(a,b)) {
				std::cout << "The root of this function using bisection method is " << root.bisectionMethod(a,b);
				root.getIterations();
				return 0;
			}
			else {
				std::cout << std::endl << "There are no roots in this interval";
				return 0;
			}
			
		}
		else if (str == "Newtons") {
			std::cout <<  "Please input the point you want to evaluate the function at: " << std::endl << "x: ";
			std::cin >> a;
			if (root.fp(a) != (root.fp(a) + 10000)) {
			std::cout << "The root of this function using Newton's method is " << root.newtonsMethod(a);
			root.getIterations();
			return 0;
			}
			else {
			 std::cout << std::endl << "Pick a different point next time, bud.";
			 return 0;
			}
		}
		else if (str == "secant") {
			std::cout <<  "Please input the interval you want to evaluate the function at: " << std::endl << "a: ";
			std::cin >> a;
			std::cout << std::endl << "b: ";
			std::cin >> b;
			if (root.validbisectionInput(a,b)) {
				std::cout << "The root of this function using secant method is " << root.secantMethod(a,b);
				root.getIterations();
				return 0;
			}
			else {
				std::cout << std::endl << "There are no roots in this interval";
				return 0;
			}
			
		}
		else {
			std::cout << "I can't follow simple directions";
			return 0;
		}
		return 0;
	}
	else if (str == "integral") {
		std::cout << "What do you like more: rectangles, trapezoids, or randomness?" << std::endl;
		std::cin >> str;
		if (str == "rectangles") {
			std::cout <<  "Please input the interval you want to evaluate the function at: " << std::endl << "a: ";
			std::cin >> a;
			std::cout << std::endl << "b: ";
			std::cin >> b;
			std::cout <<  "Please input the number of rectangles you want to use: " << std::endl;
			std::cin >> N;
			if (a < b) {
				std::cout << "The value of the rienmann sum for " << N << " rectangles is " << sum.rectRiemannSum(a,b,N);
				return 0;
			}
			else {
			  std::cout << "b needs to be larger for a for this to work, son";
				return 0;
			}
		}
		else if (str == "trapezoids") {
			std::cout <<  "Please input the interval you want to evaluate the function at: " << std::endl << "a: ";
			std::cin >> a;
			std::cout << std::endl << "b: ";
			std::cin >> b;
			std::cout <<  "Please input the number of trapezoids you want to use: " << std::endl;
			std::cin >> N;
			if (a < b) {
				std::cout << "The value of the rienmann sum for " << N << " trapezoids is " << sum.trapRiemannSum(a,b,N);
				return 0;
			}
			else {
			  std::cout << "b needs to be larger than a for this to work, son";
				return 0;
			}
		}
		else if (str == "randomness") {
			std::cout <<  "Please input the interval you want to evaluate the function at: " << std::endl << "a: ";
			std::cin >> a;
			std::cout << std::endl << "b: ";
			std::cin >> b;
			std::cout <<  "Please input the number of points you want to use: " << std::endl;
			std::cin >> points;
			if (a < b) {
				std::cout << "The value of the Monte Carlo integration sum for " << points << " points is " << sum.badmontecarlo(a,b,points);
				return 0;
			}
			else {
			  std::cout << "b needs to be larger than a for this to work, son";
				return 0;
			}
		}
		else {
			std::cout << "I can't follow simple instructions";
			return 0;
		}
	}
	else {
		std::cout << "I can't follow simple instructions";
		return 0;
	}
	
	/*
    std::cin >> a;
    std::cin >> b;
    
    std::cout << "The root of this function using bisection method is " << root.bisectionMethod(a,b);
    root.getIterations();
    std::cout << "The root of this function using Newton's method is " << root.newtonsMethod(a);
    root.getIterations();
    std::cout << "The root of this function using secant method is " << root.secantMethod(a,b);
    root.getIterations();
    // return 0;
	// riemann sums start here
    std::cin >> N;
    std::cout << "The value of the rienmann sum for " << N << " rectangles is " << sum.rectRiemannSum(N) << std::endl;
    std::cin >> N;
    std::cout << "The value of the rienmann sum for " << N << " trapezoids is " << sum.trapRiemannSum(N);
	return 0;
	*/
}
