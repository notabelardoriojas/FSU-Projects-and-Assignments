//Homework 1 Question 3

#include <iostream>
#include <string>

using namespace std;
string x;
void ask () {
  cout << "What is the password?";
  cin >> x;
}

int main() {
  ask ();
while (true) {
	if (x == "password") {
		cout << "Congratulations, login successful.";
		return 0;
	}
	else if (x != "password") {
		cout << "Login not successful";
		ask ();
	}
 }
}
