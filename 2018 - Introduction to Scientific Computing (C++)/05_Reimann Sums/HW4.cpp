#include<iostream>
#include<cmath>
#include<math.h>
#include<string>
using namespace std;
double N;
double f(double x) {
return  log(x) + (x*x) - 3;
}

double rectRiemannSum(double N) {

  double a = 1;
  double b = 3;
  double sum = 0;
  double width = (b-a)/N;
  for (int i = 0; i < N; i++)
    {
      double height = f(a + width*i);
      sum += height * width;
    }
  return sum;
}
  
  /*
int aI = 1;
  int bI = 1;
  double a = 1;
  double b = 3;
  double aSum, bSum;
  while (aI <= N) {
  double width = (a) * (1/N);
  double height = f(a + (a) * (aI/N));
  aSum = aSum + (height * width);
    aI++;
    }
  while (bI <= N) {
  double width = (b) * (1/N);
  double height = f((b) * (bI/N));
  bSum = bSum + (height * width);
    bI++;
    }
  return (bSum - aSum);
}
 */
double trapRiemannSum(double N) {
  double a = 1;
  double b = 3;
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
    
/*
  int aLeft = 0;
  int aRight = 1;
  int bLeft = 0;
  int bRight = 1;
  double a = 1;
  double b = 3;
  double aSum = 0;
  double bSum = 0;
  while (aRight <= N) {
  double awidth = a * (1/N);
  double leftHeight = f(a) * (aLeft/N);
  double rightHeight = f((a) * (aRight/N));
  aSum = aSum + (((leftHeight + rightHeight)/2) * awidth);
    aRight++;
    aLeft++;
    }
while (bRight <= N) {
  double bwidth = b * (1/N);
  double leftHeight = f((b) * (bLeft/N));
  double rightHeight = f((b) * (bRight/N));
  bSum = bSum + (((leftHeight + rightHeight)/2) * bwidth);
    bRight++;
    bLeft++;
    }
  return (bSum - aSum);
  */
void rectAsk() {
  cout << endl << "How many rectangles would you like to use for this approximation? ";
  cin >> N;
}
void trapAsk() {
  cout << endl << "How many trapezoids would you like to use for this approximation? ";
  cin >> N;
}

int main () {
string answer;
cout << "Welcome to Abelardo's Riemann Sum program!" << endl << "Before we get started, what do you like more: rectangles or trapezoids?" << endl;
cin >> answer;
while (cin.fail()) {
    cin.clear();
    cin.ignore();
    cout << endl << "I said, what do you like more: rectangles or trapezoids?" << endl;
    cin >> answer;
  }
if (answer == "rectangles") {
  rectAsk();
  while (cin.fail()) {
    cin.clear();
    cin.ignore();
    rectAsk();
  }
  cout << endl << "The value of the Riemann Sum for " << N << " rectangles is " << rectRiemannSum(N) << endl;
  return 0;
}
else if (answer == "trapezoids") {
    trapAsk();
    while (cin.fail()) {
    cin.clear();
    cin.ignore();
    trapAsk();
  }
  cout << endl << "The value of the Riemann Sum for " << N << " trapezoids is " << trapRiemannSum(N) << endl;
  return 0;
    }
else {
    cout << "You didn't put in a correct answer to that question, chief.";
    return 0;
}
}