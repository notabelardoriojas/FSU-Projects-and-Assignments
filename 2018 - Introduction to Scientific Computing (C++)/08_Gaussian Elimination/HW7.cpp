//Abelardo Riojas FSUID ar18aa
//ISC 3313 Homework 7
#include<iostream>
#include<cmath>
#include<iomanip>
#include<fstream>
#include<stdlib.h>
#include<vector>
#include<string>
#include<math.h>
using namespace std;
class myMath {
	int N;
	int iterations = 0;
	float E;
	int deg;
	int ni;
	vector<float> coefficients;
public:
	float f(float x) {

		return  log(x) + x * x - 6;
	}

	float fp(float x) {
		return (f(x + .001) - f(x - .001)) / (2 * .001);
	}

	bool validbisectionInput(float a, float b) {
		float fa = f(a);
		float fb = f(b);
		if (fa * fb < 0) {
			return true;
		}
		else {
			return false;
		}
	}

	float bisectionMethod(float a, float b) {
		iterations = 0;
		while (abs(a - b) >= E) {
			float c = (a + b) / 2;
			if (validbisectionInput(b, c)) {
				a = c;
				iterations++;
			}
			else  if (validbisectionInput(a, c)) {
				b = c;
				iterations++;
			}
			if (abs(a - b) <= E) {
				return c;
			}
		}
	}

	float newtonsMethod(float x) {
		iterations = 0;
		while (abs(f(x)) >= E) {
			if (fp(x) == 0) {
				std::cerr << "Something bad happened";
				return 0;
			}
			float nx = x + -f(x) / fp(x);
			x = nx;
			iterations++;
			while (abs(f(x)) <= E) {
				return nx;
			}
		}
	}

	float secantMethod(float a, float b) {
		iterations = 0;
		float intVal = 0;
		while (f(intVal) != 0) {
			// calculate the intermediate value 
			if (f(b) - f(a) == 0) {
				std::cerr << "Something bad happened";
				return 0;
			}
			intVal = (float)((a * f(b)) - (b * f(a))) / (f(b) - f(a));
			a = b;
			b = intVal;
			iterations++;
		}
		return intVal;
	}

	float rectRiemannSum(float a, float b) {
		float sum = 0;
		float width = (b - a) / N;
		for (int i = 0; i < N; i++)
		{
			float height = f(a + width * i);
			sum += height * width;
		}
		return sum;
	}

	float trapRiemannSum(float a, float b) {
		float sum = 0;
		int e = 1;
		float width = (b - a) / N;
		for (int i = 0; i < N; i++)
		{
			float leftheight = f(a + width * i);
			float rightheight = f(a + width * e);
			sum += (leftheight + rightheight) / 2 * width;
			e++;
		}
		return sum;
	}


	void getIterations() {
		std::cout << std::endl << "The number of iterations needed to reach this particular root was " << iterations << std::endl;
	}
	void setN(int number) {
		N = number;
	}
	int getN() {
		return N;
	}
	void setE(float error) {
		E = error;
	}
	void setDeg(int x) {
		deg = x;
	}
	void setni(int x) {
		ni = x;
	}

	void curve(vector<float> &xVal, vector<float> &yVal, int deg, int ni) {
		//making a
		int colnumber = deg + 1;
		vector<vector<float> > a(ni, vector<float>(colnumber));
		for (int i = 0; i <= deg; i++) {
			for (int k = 0; k < ni; k++) {
				a[k][i] = pow(xVal[k], i);
				//cout << a[k][i] << endl;
			}
		}

		//making a transpose
		int rownumber = deg + 1;
		vector<vector<float> > aT(rownumber, vector<float>(ni));
		for (int i = 0; i <= deg; i++) {
			for (int k = 0; k < ni; k++) {
				aT[i][k] = pow(xVal[k], i);
				//cout << aT[i][k] << endl;
			}
		}
		//making aTa
		int number = deg + 1;
		vector<vector<float> > A(number, vector<float>(number));
		for (int i = 0; i <= deg; i++) {
			for (int j = 0; j <= deg; j++) {
				for (int k = 0; k < ni; k++) {
					A[i][j] += aT[i][k] * a[k][j];
				}
			}

		}
		//making aTy
		vector<float> b(number);
		for (int i = 0; i <= deg; i++) {
			for (int j = 0; j < ni; j++) {
				b[i] += aT[i][j] * yVal[j];
			}
		}
		//gaussian elimination
		int n = A.size();

		for (int i = 0; i < n; i++) {
			// Search for maximum in this column
			float maxEl = abs(A[i][i]);
			int maxRow = i;
			for (int k = i + 1; k < n; k++) {
				if (abs(A[k][i]) > maxEl) {
					maxEl = abs(A[k][i]);
					maxRow = k;
				}
			}

			// Swap maximum row with current row (column by column)
			for (int k = i; k < n; k++) {
				float tmp = A[maxRow][k];
				A[maxRow][k] = A[i][k];
				A[i][k] = tmp;
			}
			float tmp = b[maxRow];
			b[maxRow] = b[i];
			b[i] = tmp;

			// Make all rows below this one 0 in current column
			for (int k = i + 1; k < n; k++) {
				float c = -A[k][i] / A[i][i];
				for (int j = i; j < n; j++)
				{
					if (i == j) {
						A[k][j] = 0;
					}
					else {
						A[k][j] += c * A[i][j];
					}
				}
				b[k] += c * b[i];
			}
		}

		// Solve equation Ax=b for an upper triangular matrix A
		for (int i = n - 1; i >= 0; i--) {
			b[i] = b[i] / A[i][i];
			for (int k = i - 1; k >= 0; k--) {
				b[k] -= A[k][i] * b[i];
			}
		}
		coefficients = b;


	}
	vector<float> getCoefficients(){
		return coefficients;
	}

};

int main() {
	int number;
	int points;
	float a1, b;
	myMath root, sum, curve;
	root.setE(.00001);
	std::cout << "This is a program that verifies that myMath's methods are functioning" << std::endl;

	//curve of best fit starts here

	std::cout << "Please type the file name. Example: data1.txt" << std::endl;
	std::vector<float> xVal;
	std::vector<float> yVal;
	int pointnum;
	char filename[50];
	std::ifstream myfile;
	std::cin.getline(filename, 50);
	myfile.open(filename);
	if (!myfile.is_open()) {
		std::cerr << "Couldn't open file";
		return 0;
	}
	while (myfile.good()) {
		std::string line;
		//skip first two lines
		getline(myfile, line);
		std::string n1 = line;
		pointnum = atoi(n1.c_str());
		curve.setni(pointnum);
		getline(myfile, line);
		int i = 0;

		while (getline(myfile, line) && i <= pointnum) {
			int found = line.find(" ");
			std::string xstr = line.substr(0, found);
			std::string ystr = line.substr(found + 1);
			float xvalue = atof(xstr.c_str());
			float yvalue = atof(ystr.c_str());
			xVal.push_back(xvalue);
			yVal.push_back(yvalue);
			i++;

		}


	}

	int tempdeg;
	std::cout << "Enter the highest degree of the curve of best fit" << std::endl;
	std::cin >> tempdeg;
	curve.setDeg(tempdeg);
	curve.curve(xVal, yVal, tempdeg, pointnum);
	vector<float> c = curve.getCoefficients();
	cout << "The equation of the line of best fit is y = ";
	for (int i = 0; i <= tempdeg; i++) {
		if (i == tempdeg) {
			cout << c[i] << "x^" << i << endl;
			break;
		}
		cout << c[i] << "x^" << i << " + ";
	}
	
	//roots start here

	std::cout << "Enter a and b" << std:: endl;
	std::cin >> a1;
	std::cin >> b;

	std::cout << "The root of this function using bisection method is " << root.bisectionMethod(a1,b);
	root.getIterations();
	std::cout << "The root of this function using Newton's method is " << root.newtonsMethod(a1);
	root.getIterations();
	std::cout << "The root of this function using secant method is " << root.secantMethod(a1,b);
	root.getIterations();

	// riemann sums start here

	std::cout << std:: endl << "Enter the number of quadilaterals you want to use" << std:: endl;
	std::cin >> number;
	sum.setN(number);
	std::cout << "The value of the rienmann sum for " << sum.getN() << " rectangles is " << sum.rectRiemannSum(a1,b) << std::endl;
	std::cout << "The value of the rienmann sum for " << sum.getN() << " trapezoids is " << sum.trapRiemannSum(a1,b) << std::endl;
	

	return 0;


}
