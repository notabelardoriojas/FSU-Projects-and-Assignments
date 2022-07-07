//Homework 2 Question 1
//Abelardo Riojas ISC 3313 FSUID ar18aa
#include<iostream>
#include<stdlib.h>
#include<iomanip>
#include<cmath>
using namespace std;
int main () {
  // initalizing variables
  int circlepoints = 0;
  int squarepoints = 0;
  int i = 1;
  int interval;
  cout << "Please input the number of raindrops that are falling today:" << endl;
  cin >> interval;
  // check for a negative interger
  while (interval <= 0) {
      cout << "You need to input a positive number of raindrops" << endl;
      cin >> interval;
  }
  // main while loop
  while (i <= interval) {
    // generation of random X Y coordinates between 0 and 1
    float randX = (float)rand()/RAND_MAX;
    float randY = (float)rand()/RAND_MAX;
    i++;
    // squarepoints always gets incremented because logic
    squarepoints++;
    // origin at .5, .5. apply distance formula to radius .5 increment circlepoints if true
    if (sqrt(((randX - .5) * (randX - .5)) + ((randY - .5) * (randY - .5))) <= .5) {
      circlepoints++;
    }
  }
  // remember to cast floats as floats, math operators return intergers!
    float pi = 4 * (float)circlepoints/squarepoints;
    cout << "The value of pi for this interval is " << fixed << setprecision(4) << pi << endl;
    return 0;
}
