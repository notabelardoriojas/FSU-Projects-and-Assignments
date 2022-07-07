//Abelardo Riojas FSUID ar18aa
//ISC 3133 Homework 6 Question 2
#include <iostream>
#include <cmath>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>

using namespace std;

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
		vector<vector<double>> a(ni, vector<double>(2));
		for (i = 0; i <= (ni - 1); i++) {
			a[i][0] = 1;
			a[i][1] = xVal[i];
			//cout << a[i][0] << " " << a[i][1] << endl;
		}

		vector<vector<double>> aT(2, vector<double>(ni));
		for (i = 0; i <= (ni - 1); i++) {
			aT[0][i] = 1;
			aT[1][i] = xVal[i];
			//cout << a[0][i] << " " << a[1][i] << endl;
		}

		vector<vector<double>> aTa(2, vector<double>(2));
		for (i = 0; i <= (ni - 1); i++) {
			aTa[0][0] += aT[0][i] * a[i][0];
			aTa[0][1] += aT[0][i] * a[i][1];
			aTa[1][0] += aT[1][i] * a[i][0];
			aTa[1][1] += aT[1][i] * a[i][1];
		}
		//cout << aTa[0][0] << " " << aTa[0][1] << endl;
		//cout << aTa[1][0] << " " << aTa[1][1];

		vector<vector<double>> aTy(2, vector<double>(1));
		for (i = 0; i <= (ni - 1); i++) {
			aTy[0][0] += aT[0][i] * yVal[i];
			aTy[1][0] += aT[1][i] * yVal[i];
		}
		//cout << aTy[0][0] << " " << aTy[1][0] << endl;

		vector<vector<double>> g(2, vector<double>(3));

		g[0][0] = aTa[0][0]; g[0][1] = aTa[0][1]; g[0][2] = aTy[0][0];
		g[1][0] = aTa[1][0]; g[1][1] = aTa[1][1]; g[1][2] = aTy[1][0];
		//making g[0][0] = 1
		for (i = 0; i <= 2; i++) {
			if (i == 2) {
				g[0][2] = aTy[0][0] / aTa[0][0];
				//cout << g[0][2];
				break;
			}
			g[0][i] = aTa[0][i] / aTa[0][0];
			//cout << g[0][i] << " ";
		}
		//making g[1][0] = 0
		for (i = 0; i <= 2; i++) {
			if (i == 2) {
				g[1][2] = (g[0][2] * -aTa[1][0]) + g[1][2];
				//cout << g[1][2];
				break;
			}
			g[1][i] = (g[0][i] * -aTa[1][0]) + aTa[1][i];
			//cout << g[1][i] << " ";
		}
		//making g[1][1] = 1
		double temp = g[1][1];
		for (i = 0; i <= 2; i++) {
			g[1][i] = g[1][i] / temp;
			//cout << g[1][i] << " ";
		}
		//making g[0][1] = 0;
		cout << endl;
		double temp1 = -g[0][1];
		for (i = 0; i <= 2; i++) {
			g[0][i] = (g[1][i] * temp1) + g[0][i];
			//cout << g[0][i] << " ";
		}


		cout << "The equation for the least squares residual line is: y = " << g[1][2] << "x + " << g[0][2];
		return 0;
	}

}


