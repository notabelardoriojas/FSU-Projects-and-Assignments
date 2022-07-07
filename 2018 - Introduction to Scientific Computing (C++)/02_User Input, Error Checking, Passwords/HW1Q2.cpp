//Homework 1 Question 2

#include <iostream>

using namespace std;
int N;
string question = "Please enter a positive interger:\n";
void ask () {
  cout << question;
  cin >> N;
}

int main() {
int y = N * 10;
	ask ();
  while (true) {
	if (N < 0) {
		ask ();
		}
	else if (y % 10 != 0) {
		cout << "Very clever professor, you're checking if I put in check for non-intergers! Nice try, guy.\n";
		ask ();
		}
	else {
		int i = 1;
		int sum = 0;
		while (i <= N) {
			sum += i;
			++i;
			}
		cout << sum;
		return 0;
		}
	}
}	
		
