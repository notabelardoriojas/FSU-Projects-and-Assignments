#include <iostream>
#include <cmath>
#include <cstdlib>
#include <vector>
#include <fstream>
#include <complex>
#include <string>
using namespace std;
double calcz(complex<double> z, complex<double> c, double zabsmax) {
  long nit = 0;
  long nitmax = 1000;
  double ratio = 0.0;
  while (abs(z) < zabsmax && nit < nitmax) {
    z = z*z + c;
    nit++;
    ratio = (float(nit)/nitmax)*225.0;
  }
  return ratio;
}

vector<vector<double> > julia_loop(long im_width, long im_height, double xwidth, double yheight, double xmin, double ymin, long nitmax) {
    int nit;
    cout << "Calculate the 2D plane..."<< endl;
    float zabsmax = 10.0;
    complex<double> c(-0.1, 0.65);
    vector<vector<double> > julia(im_width, vector<double>(im_height));
    for (int xi = 0; xi < im_width; xi++) {
      for (int yi = 0; yi < im_height; yi++) {
          nit = 0;
          complex<double> z(double(xi) / im_width * xwidth + xmin, double(yi) / im_height * yheight + ymin);
          julia[xi][yi] = calcz(z,c,zabsmax);
      }
    }
    return julia;
  }

int main() {
  long im_width = 1000;
  long im_height = 1000;
  double xmin = -.5;
  double xmax = .5;
  long xwidth = xmax - xmin;
  double ymin = -.5;
  double ymax = .5;
  long yheight = ymax - ymin;
  long nitmax = 1000;
  long zabsmax = 10.0;
  string title = "Julia set fractal generator";
  vector<vector<double> > julia = julia_loop(im_width, im_height, xwidth, yheight, xmin, ymin, nitmax);
  ofstream myfile;
  myfile.open("juliadata.txt");
  myfile << im_width << endl;
  myfile << im_height << endl;
  myfile << xmin << endl;
  myfile << xmax << endl;
  myfile << xwidth << endl;
  myfile << ymin << endl;
  myfile << ymax << endl;
  myfile << yheight << endl;
  for (int i = 0; i < im_width; i++)
  {
    for (int j = 0; j < im_height; j++)
    {
      myfile << julia[i][j] << "\t";
    }
  }
    myfile.close();
}
