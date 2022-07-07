//Abelardo Riojas FSUID ar18aa
//ISC 3133 Homework 6 Question 1
#include <iostream>
#include <cmath>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>

using namespace std;

double xavg(vector<double> xVal, int n) {
	int i = 0;
	double xsum = 0;
	while (i <= n) {
		xsum = xsum + xVal[i];
		i++;
		if (i == n) {
			return xsum / n;
		}
	}
}

double yavg(vector<double> yVal, int n) {
	int i = 0;
	double ysum = 0;
	while (i <= n) {
		ysum = ysum + yVal[i];
		i++;
		if (i == n) {
			return ysum / n;
		}
	}
}

double numerator(vector<double> xVal, vector<double> yVal, int n) {
	double avgx = xavg(xVal, n);
	double avgy = yavg(yVal, n);
	int i = 0;
	double sum = 0;
	while (i <= n) {
		sum += (xVal[i] - avgx) * (yVal[i] - avgy);
		i++;
		if (i == n) {
			return sum;
		}
	}
}

double denominator(vector<double> xVal, int n) {
	double avgx = xavg(xVal, n);
	int i = 0;
	double sum = 0;
	while (i <= n) {
		sum += (xVal[i] - avgx) * (xVal[i] - avgx);
		i++;
		if (i == n) {
			return sum;
		}
	}
}

double slope(vector<double> xVal, vector<double> yVal, int n) {
	return numerator(xVal, yVal, n) / denominator(xVal, n);
}

double b(vector<double> xVal, vector<double> yVal, int n) {
	return yavg(yVal, n) - (slope(xVal, yVal, n) * xavg(xVal, n));
}

int main() {
	cout << "Please type the file name. Example: data1.txt" << endl;
	vector<double> xVal;
	vector<double> yVal;
	char filename[50];
	ifstream myfile;
	cin.getline(filename, 50);
	myfile.open(filename);
	if (!myfile.is_open()) {
		cerr << "Couldn't open file";
		return 0;
	}
	while (myfile.good()) {
		string line;
		//skip first two lines
		getline(myfile, line);
		string n = line;
		int ni = atoi(n.c_str());
		getline(myfile, line);
		int i = 0;

		while (getline(myfile, line) && i <= ni) {
			int found = line.find(" ");
			string xstr = line.substr(0, found);
			string ystr = line.substr(found + 1);
			double xvalue = atof(xstr.c_str());
			double yvalue = atof(ystr.c_str());
			xVal.push_back(xvalue);
			yVal.push_back(yvalue);
			i++;

		}
		cout << "The equation for the least squares residual line is: y = " << slope(xVal, yVal, ni) << "x + " << b(xVal, yVal, ni);
		return 0;
	}

}

